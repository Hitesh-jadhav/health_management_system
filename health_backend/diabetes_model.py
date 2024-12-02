import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import StandardScaler

# Load your dataset
data = pd.read_csv('diabetes.csv')

# Check for NaN values
print("Checking for NaN values in the dataset:")
print(data.isnull().sum())

# Separate the features and target variable
X = data.drop('Outcome', axis=1)  # Features
y = data['Outcome']  # Target variable

# Check the unique values in the target variable
print("Unique values in target variable:")
print(y.unique())

# Ensure there are no NaN values in the target variable
print("Checking for NaN values in target variable:")
print(y.isnull().sum())

# Convert continuous target to discrete classes (if needed)
# You may skip this step if 'Outcome' is already categorical (0, 1)
# Uncomment this if you want to bin the target variable
# bins = [0, 0.5, 1.0, np.inf]
# labels = ['low', 'medium', 'high']
# y_binned = pd.cut(y, bins=bins, labels=labels)

# Scale the features
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# Split the data
X_train, X_test, y_train, y_test = train_test_split(X_scaled, y, test_size=0.2, random_state=42)

# Fit the classifier
model = RandomForestClassifier()
model.fit(X_train, y_train)

# Evaluate the model
accuracy = model.score(X_test, y_test)
print(f"Model Accuracy: {accuracy}")
