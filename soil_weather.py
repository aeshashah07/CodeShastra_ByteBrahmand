# requests, numpy, pandas, sklearn.ensemble

import requests
import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestClassifier


from flask import Flask, request, jsonify
# from werkzeug.utils import secure_filename
# import speech_recognition as sr
import google.generativeai as genai

app = Flask(_name_)

# Configure generative AI
genai.configure(api_key="AIzaSyDZ7q5vFZARCv2nShdqnjqE4K7dh3z23PU")
model = genai.GenerativeModel('gemini-pro')

@app.route('/weather_forecast', methods=['GET'])
def weatherForecast():
    args = request.args
    print(args)
    city = args.get('city')
    # city = 
    # api_url_1 = "https://api.openweathermap.org/data/2.5/forecast?q="
    # api_url_2 = "&appid=5de5b3855c085044ca313934c09cd5ce"
    api_url = f"https://api.openweathermap.org/data/2.5/forecast?q={city}&appid=6144d8760d40c44ade5de8ad9496ac5b"
    # response = requests.get(api_url_1+city+api_url_2)
    response = requests.get(api_url)
    weather_data = response.json()

    data = []
    analysis_data = []
    for i in range(len(weather_data['list'])):
        item = weather_data['list'][i]
        row = {
            'temperature': item['main']['temp'],
            'temp_min': item['main']['temp_min'],
            'temp_max': item['main']['temp_max'],
            'humidity': item['main']['humidity'],
            'wind_speed': item['wind']['speed'],
            'rain': 1 if 'rain' in item and item['rain'] else 0,  # Check if rain data is available
            # 'region': city
        }
        if (i-1)%8 == 0:
            data.append(row)
            analysis_data.append(item['main'])
    df = pd.DataFrame(data)
    df['soil_condition'] = np.random.choice([0, 1, 2], size=len(df))  # Random soil condition types

    X_soil = df[['temperature', 'temp_min', 'temp_max', 'humidity', 'wind_speed']]
    y_soil = df['soil_condition']
    X_rain = df[['temperature', 'temp_min', 'temp_max', 'humidity', 'wind_speed']]
    y_rain = df['rain']

    soil_model = RandomForestClassifier(n_estimators=100, random_state=42)
    soil_model.fit(X_soil, y_soil)
    rain_model = RandomForestClassifier(n_estimators=100, random_state=42)
    rain_model.fit(X_rain, y_rain)
    soil_predictions = soil_model.predict(X_soil)
    rain_predictions = rain_model.predict(X_rain)
    # Output soil fertility, and rainfall predictions
    for i in range(len(df)):
        soil_type = soil_predictions[i]
        rainfall = "Yes" if rain_predictions[i] else "No"
        if soil_type == 0:
            fert = 'Low'
        elif soil_type == 1:
            fert = 'Medium'
        elif soil_type == 2:
            fert = 'High'
        data[i]['rainfall'] = rainfall
        data[i]['soil_fertility'] = fert
    
    # query = 'List the crops that a farmer with their farm in city Mumbai with humid weather can grow for the next season, the number of days left for the harvesting season, and 3 tips for irrigation based and the following predicted weather forecast of next few days: ' + str(analysis_data) + 'city: ' + city
    # query = f"List the crops that a farmer with their farm in city {city} with humid weather can grow for the next season, the number of days left for the harvesting season, and 3 tips for irrigation based on the following predicted weather forecast of the next few days: {analysis_data}"
    # query="what is doraemon?"
    # query = f"List the crops that a farmer with their farm in city {city} with humid weather can grow for the next season, the number of days left for the harvesting season, and 3 tips for irrigation based on the following predicted weather forecast of the next few days: {analysis_data}"
    query = f"List the crops that a farmer with their farm in city {city} with humid weather can grow for the next season, the number of days left for the harvesting season, and 3 tips for irrigation based on the following predicted weather forecast of the next few days: {analysis_data} without any other bullshit"

    print(analysis_data)

    response = model.generate_content(query)
   
    output = {'forecast': analysis_data, 'analysis': response.text}
    # print(response.text)
    return output
    
@app.route('/', methods=['GET'])
def index():
    return "Hello, World!"

if _name_ == '_main_':
    app.run(host='0.0.0.0', port=5000)
