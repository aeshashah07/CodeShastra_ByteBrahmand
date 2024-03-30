import requests
import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestClassifier

# Fetch weather data from OpenWeatherMap API
api_url = "https://api.openweathermap.org/data/2.5/forecast?q=Mumbai&appid=5de5b3855c085044ca313934c09cd5ce"
response = requests.get(api_url)
weather_data = response.json()

# Extract relevant features and create dataframe
data = []
for item in weather_data['list']:
    row = {
        'temperature': item['main']['temp'],
        'temp_min': item['main']['temp_min'],
        'temp_max': item['main']['temp_max'],
        'humidity': item['main']['humidity'],
        'wind_speed': item['wind']['speed'],
        'rain': 1 if 'rain' in item and item['rain'] else 0,  # Check if rain data is available
        'region': 'Mumbai'  # Assuming all data is for Mumbai
    }
    data.append(row)

df = pd.DataFrame(data)

# Generate synthetic labels for demonstration purposes
# In a real scenario, you'd need actual soil condition and rain data for training
# For demonstration, let's categorize soil condition into three types: 0, 1, 2
df['soil_condition'] = np.random.choice([0, 1, 2], size=len(df))  # Random soil condition types

# Define features and target variables for soil condition prediction
X_soil = df[['temperature', 'temp_min', 'temp_max', 'humidity', 'wind_speed']]
y_soil = df['soil_condition']

# Define features and target variable for rainfall prediction
X_rain = df[['temperature', 'temp_min', 'temp_max', 'humidity', 'wind_speed']]
y_rain = df['rain']

# Train soil condition prediction model (Random Forest Classifier)
soil_model = RandomForestClassifier(n_estimators=100, random_state=42)
soil_model.fit(X_soil, y_soil)

# Train rainfall prediction model (Random Forest Classifier)
rain_model = RandomForestClassifier(n_estimators=100, random_state=42)
rain_model.fit(X_rain, y_rain)

# Make predictions
soil_predictions = soil_model.predict(X_soil)
rain_predictions = rain_model.predict(X_rain)

# Output soil types, fertility, and rainfall predictions
for i in range(len(df)):
    soil_type = soil_predictions[i]
    rainfall = "Yes" if rain_predictions[i] else "No"
    if soil_type == 0:
        print(f"Day {i+1}: Soil Type - Clay, Fertility - Low, Rainfall - {rainfall}")
    elif soil_type == 1:
        print(f"Day {i+1}: Soil Type - Loam, Fertility - Medium, Rainfall - {rainfall}")
    elif soil_type == 2:
        print(f"Day {i+1}: Soil Type - Sandy, Fertility - High, Rainfall - {rainfall}")