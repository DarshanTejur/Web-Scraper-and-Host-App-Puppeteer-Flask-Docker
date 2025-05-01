from flask import Flask, jsonify
import json
import os

app = Flask(__name__)

DATA_FILE = "scraped_data.json"

@app.route('/')
def show_data():
    if not os.path.exists(DATA_FILE):
        return jsonify({"error": "scraped_data.json not found"}), 404

    try:
        with open(DATA_FILE, 'r') as file:
            data = json.load(file)
            return jsonify(data)
    except Exception as e:
        return jsonify({"error": f"Could not read data: {str(e)}"}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
