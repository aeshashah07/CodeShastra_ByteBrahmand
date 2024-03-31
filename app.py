import google.generativeai as genai
import requests
import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from flask import Flask, request, jsonify, send_file
import io
from datetime import date
import matplotlib.pyplot as plt


genai.configure(api_key= 'AIzaSyDZ7q5vFZARCv2nShdqnjqE4K7dh3z23PU')
model = genai.GenerativeModel('gemini-pro')


app = Flask(__name__)

# Configure generative AI
genai.configure(api_key="AIzaSyDZ7q5vFZARCv2nShdqnjqE4K7dh3z23PU")
model = genai.GenerativeModel('gemini-pro')

@app.route('/weather_forecast', methods=['GET'])
def weatherForecast():
    args = request.args
    city = args.get('city')
    api_url = f"https://api.openweathermap.org/data/2.5/forecast?q={city}&appid=6144d8760d40c44ade5de8ad9496ac5b"
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
    
    query = f"List the crops that a farmer with their farm in city {city} with humid weather can grow for the next season, the number of days left for the harvesting season, and 3 tips for irrigation based on the following predicted weather forecast of the next few days: {analysis_data} without any other bullshit"
    response = model.generate_content(query)
   
    output = {'forecast': analysis_data, 'analysis': response.text}
    return output
    
@app.route('/', methods=['GET'])
def index():
    return "Hello, World!"

@app.route('/get_prices', methods=['POST'])
def get_prices():
    try:
        print(request)
        print('req: ', request.json)
        state = request.json.get('state')
        crop = request.json.get('crop')
        print(state, crop)
        data = get_data(state.upper())
        print(data)
        if data:
            data1 = [entry for item in data for entry in item['data'] if crop.upper() in entry['commodity'].split()[0]]
            regions = [entry['apmc'] for entry in data1]
            prices = [float(entry['modal_price']) for entry in data1]
            plot_img = plot_prices(regions,prices) 
            return send_file(plot_img, mimetype='image/png')
        else:
            return jsonify({'error': 'No data available for the given state and crop.'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

def get_data(state):
    url = 'https://enam.gov.in/web/Liveprice_ctrl/trade_data_list'
    today = date.today()
    stateName = state
    payload = {
        'language': 'en',
        'stateName': stateName,
        'fromDate': today,
        'toDate': today
    }
    data = []
    response = requests.post(url, data=payload)
    if response.status_code == 200:
        try:
            dic = response.json()
            if dic['status'] == 200:
                data.append(dic)
                for i in dic['data']:
                    if i['modal_price']=='0':
                        continue
        except ValueError:
            print("Failed to parse JSON response")
    else:
        print("Failed to retrieve the page")
    return data
        
def plot_prices(regions, prices):
    non_zero_regions = []
    non_zero_prices = []
    
    for region, price in zip(regions, prices):
        if price != 0:
            non_zero_regions.append(region)
            non_zero_prices.append(price)
    
    colormap = plt.cm.Blues
    normalize = plt.Normalize(vmin=min(non_zero_prices), vmax=max(non_zero_prices))
    
    plt.figure(figsize=(8, 5))
    bars = plt.bar(non_zero_regions, non_zero_prices, color=colormap(normalize(non_zero_prices)), edgecolor='white')
    
    avg_price = sum(non_zero_prices) / len(non_zero_prices)
    plt.title(f'Average Price: {avg_price:.2f}', fontsize=16)
    plt.xlabel('Regions', fontsize=14)
    plt.ylabel('Price (in Qui)', fontsize=14)
    plt.xticks(rotation=90, ha='center', fontsize=10)
    plt.yticks(fontsize=10)
    plt.grid(axis='y', linestyle='--', alpha=0.5)
    
    plt.tight_layout()
    img_buf = io.BytesIO()
    plt.savefig(img_buf, format='png')
    img_buf.seek(0)
    
    plt.close()  # Close the plot to free up resources
    
    return img_buf


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
