import sys
import json
import joblib

# Load the model once when the script starts
model = joblib.load('diabetes_model.pkl')  # Update with your model's filename

def predict(input_data):
    input_array = json.loads(input_data)
    # Ensure the input is in the correct shape (2D array for sklearn)
    prediction = model.predict([[
        input_array['Pregnancies'],
        input_array['Glucose'],
        input_array['BloodPressure'],
        input_array['SkinThickness'],
        input_array['Insulin'],
        input_array['BMI'],
        input_array['DiabetesPedigreeFunction'],
        input_array['Age']
    ]])
    return prediction[0]  # Return the first prediction

if __name__ == "__main__":
    input_data = sys.argv[1]  # Get the input data from command line arguments
    result = predict(input_data)
    print(result)  # Print the prediction to standard output
