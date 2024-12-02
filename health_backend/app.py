# from flask import Flask, request, jsonify
# import joblib

# app = Flask(__name__)
# model = joblib.load('health_model.pkl')

# @app.route('/predict', methods=['POST'])
# def predict():
#     data = request.get_json(force=True)
#     prediction = model.predict([data['features']])
#     return jsonify({'prediction': prediction[0]})

# if __name__ == '__main__':
#     app.run(port=5001)

from flask import Flask, request, jsonify
from flask_bcrypt import Bcrypt
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
from pymongo import MongoClient
from bson import ObjectId
import json
import subprocess
import os
import dotenv
from datetime import timedelta
from bson import ObjectId
from flask_cors import CORS


# Load environment variables
dotenv.load_dotenv()

app = Flask(__name__)
CORS(app)
bcrypt = Bcrypt(app)
jwt = JWTManager(app)

# MongoDB Configuration
client = MongoClient("mongodb://localhost:27017/")
db = client["health_management"]

# JWT Secret Key
app.config["JWT_SECRET_KEY"] = os.getenv("JWT_SECRET")

@app.route("/", methods=["GET"])
def home():
    return "Health Management API"

@app.route("/register", methods=["POST"])
def register():
    data = request.json
    username = data.get("username")
    password = data.get("password")
    email = data.get("email")

    if username and password and email:
        hashed_password = bcrypt.generate_password_hash(password).decode("utf-8")
        user = {"username": username, "password": hashed_password, "email": email}
        db.users.insert_one(user)
        return jsonify({"message": "User registered"}), 201
    return jsonify({"error": "Invalid data"}), 400

@app.route("/login", methods=["POST"])
def login():
    data = request.json
    username = data.get("username")
    password = data.get("password")

    user = db.users.find_one({"username": username})
    if user and bcrypt.check_password_hash(user["password"], password):
        # Set token expiration time (1 hour example)
        expires = timedelta(hours=1)
        
        # Specify identity as the 'sub' claim
        token = create_access_token(identity=str(user["_id"]), expires_delta=expires)
        
        return jsonify({"token": token}), 200
    return jsonify({"error": "Invalid username or password"}), 401



@app.route("/predict", methods=["POST"])
def predict():
    input_data = request.json

    try:
        # Run the Python script and pass input_data as argument
        result = subprocess.run(["python", "predict.py", json.dumps(input_data)], 
                                capture_output=True, text=True)

        if result.returncode == 0:
            prediction = json.loads(result.stdout)
            return jsonify(prediction), 200
        return jsonify({"error": "Prediction failed"}), 500
    except Exception as e:
        print(f"Prediction error: {e}")
        return jsonify({"error": "Server error"}), 500

@app.route("/health_data", methods=["GET"])
@jwt_required()
def get_health_data():
    user_id = get_jwt_identity()

    try:
        health_data = db.health_data.find_one({"userId": ObjectId(user_id)})
        if health_data:
            # Convert ObjectId to string for JSON serialization
            health_data["_id"] = str(health_data["_id"])
            health_data["userId"] = str(health_data["userId"])
            return jsonify(health_data), 200
        return jsonify({"error": "Health data not found"}), 404
    except Exception as e:
        print(f"Error fetching health data: {e}")
        return jsonify({"error": "Server error"}), 500


@app.route("/health_data", methods=["POST"])
@jwt_required()
def add_health_data():
    try:
        # Get user ID from token
        user_id = get_jwt_identity()

        # Parse JSON data
        data = request.json
        if not data:
            return jsonify({"error": "No data provided"}), 400

        # Prepare health data for insertion
        health_data = {
            "userId": ObjectId(user_id),  # Convert user_id to ObjectId
            "age": data.get("age"),
            "bmi": data.get("bmi"),
            "bloodPressure": data.get("bloodPressure"),
            "cholesterol": data.get("cholesterol"),
            "glucose": data.get("glucose"),
        }

        # Check if all required fields are present
        if None in health_data.values():
            return jsonify({"error": "Missing required health data fields"}), 400

        # Insert health data into the database
        inserted_id = db.health_data.insert_one(health_data).inserted_id

        # Convert ObjectId to string for JSON response
        health_data["_id"] = str(inserted_id)
        health_data["userId"] = str(health_data["userId"])

        return jsonify({"message": "Health data added successfully", "data": health_data}), 201

    except Exception as e:
        print(f"Error adding health data: {e}")
        return jsonify({"error": "Error adding health data", "details": str(e)}), 500

@app.route("/users", methods=["GET"])
def get_all_users():
    try:
        # users = list(db.users.find({}, {"password": 0}))  # Exclude password
        users = list(db.users.find({})) 
        for user in users:
            user["_id"] = str(user["_id"])
        return jsonify(users), 200
    except Exception as e:
        print(f"Error fetching users: {e}")
        return jsonify({"error": "Server error"}), 500

if __name__ == "__main__":
    app.run(port=int(os.getenv("PORT", 5000)), debug=True)
