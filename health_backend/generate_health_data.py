import pandas as pd
import numpy as np

# Parameters
num_samples = 500  # Number of samples in the dataset
np.random.seed(42)  # For reproducibility

# Generate synthetic health data
data = {
    "age": np.random.randint(18, 80, size=num_samples),
    "bmi": np.round(np.random.uniform(15, 40, size=num_samples), 1),
    "blood_pressure": np.random.randint(90, 180, size=num_samples),
    "cholesterol": np.random.randint(150, 300, size=num_samples),
    "glucose": np.random.randint(70, 200, size=num_samples),
}

# Target variable (for example, a health risk score or probability of a health condition)
# This is created using a random weighted sum of the features to simulate health risk
data["target"] = (
    0.2 * data["age"]
    + 0.3 * data["bmi"]
    + 0.25 * data["blood_pressure"]
    + 0.15 * data["cholesterol"]
    + 0.1 * data["glucose"]
) / 100 + np.random.normal(0, 0.5, num_samples)  # Adding slight noise

# Create DataFrame and save to CSV
df = pd.DataFrame(data)
df.to_csv("health_data.csv", index=False)
print("health_data.csv generated successfully.")
