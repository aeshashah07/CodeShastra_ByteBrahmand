import io
from flask import Flask, request, jsonify, send_file
import requests
from datetime import date
import matplotlib.pyplot as plt

app = Flask(__name__)

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
    response = requests.post(url, data=payload)
    # data = []
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
    # return data
        
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
  

@app.route('/get_prices', methods=['POST'])
def get_prices():
    state = request.json.get('state')
    crop = request.json.get('crop')
    
    data = []
    get_data(state.upper())
    if data:
        data1 = [entry for item in data for entry in item['data'] if crop.upper() in entry['commodity'].split()[0]]
        regions = [entry['apmc'] for entry in data1]
        prices = [float(entry['modal_price']) for entry in data1]
        plot_img = plot_prices(regions,prices) 
        #return jsonify({'regions': regions, 'prices': prices})
        return send_file(plot_img, mimetype='image/png')
    else:
        return jsonify({'error': 'No data available for the given state and crop.'})


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)