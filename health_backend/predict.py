import sys
import json
import pandas as pd
import joblib

def predict(input_data):
    
    # Load the model
    model = joblib.load('health_model.pkl')

    # Parse input JSON string to dictionary
    input_dict = json.loads(input_data)

    # Ensure that the input contains all required features
    expected_features = ['age', 'bmi', 'blood_pressure', 'cholesterol', 'glucose']

    # Create DataFrame with specified columns
    input_df = pd.DataFrame([input_dict])
    input_df = input_df.reindex(columns=expected_features)  # Reindex to match expected features

    # Predict and return result
    prediction = model.predict(input_df)[0]
    return prediction

if __name__ == "__main__":
    input_data = sys.argv[1]
    result = predict(input_data)

    # Output only the JSON result
    print(json.dumps({"prediction": result}))
