import requests
from flask import Flask, request, jsonify
from datetime import date

app = Flask(__name__)

def get_data(state, commodity):
    url = 'https://enam.gov.in/web/Liveprice_ctrl/trade_data_list'
    today = '2024-03-30'
    stateName = state
    payload = {
        'language': 'en',
        'stateName': stateName,
        'fromDate': today,
        'toDate': today
    }
    response = requests.post(url, data=payload)
    print(response)
    data = []
    if response.status_code == 200:
        dic = response.json()
        if dic['status'] == 200:
            # data.append(dic)
            for i in dic['data']:
                if i['modal_price'] != '0' and i['commodity'] == commodity:
                    data.append(i)
    return data

@app.route('/get_prices', methods=['GET'])
def get_prices():
    state = request.args.get('state')
    crop = request.args.get('crop')
    
    if not state or not crop:
        return jsonify({"error": "Both 'state' and 'crop' parameters are required."}), 400

    # state_data = get_data(state.upper(), crop.upper())
    crop_data = get_data(state.upper(), crop.upper())
    # if not state_data:
    if not crop_data:
        app.logger.error(f"No data available for the state: {state}")
        return jsonify({"error": "No data available for the given state."}), 404
    # print(state_data[0])
    # print(type(state[0]))
    # for item in state_data:
    #     print(item)
    #     print(type(item))
    #     print(item.values())
    #     print(item['commodity'])
    # crop_data = [item for item in state_data if crop.upper() in item['commodity']]
    # print(crop_data)

    if not crop_data:
        app.logger.error(f"No data available for the crop: {crop}")
        return jsonify({"error": "No data available for the given crop."}), 404

    regions = [entry['apmc'] for entry in crop_data]
    prices = [float(entry['modal_price']) for entry in crop_data]
    avg_price = sum(prices) / len(prices)

    return jsonify({
        "state": state,
        "crop": crop,
        "average_price": avg_price,
        "data": [{"region": region, "price": price} for region, price in zip(regions, prices)]
    })


if __name__ == '__main__':
    app.run(debug=True)
