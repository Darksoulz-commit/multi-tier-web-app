from flask import Flask, jsonify
import os
import datetime

app = Flask(__name__)

# Main endpoint - Shows system information
@app.route('/')
def home():
    return jsonify({
        "status": "success",
        "message": "Naveen's DevOps Pipeline is LIVE!",
        "server_time": str(datetime.datetime.now()),
        "hostname": os.uname()[1] if hasattr(os, 'uname') else "Local-Machine",
        "application_tier": "Backend API"
    })

# Health check endpoint - Used by Docker & Kubernetes to monitor app status
@app.route('/health')
def health_check():
    return jsonify({
        "status": "healthy",
        "uptime_status": "100%",
        "status_code": 200
    })

if __name__ == '__main__':
    # Running on port 8000
    app.run(host='0.0.0.0', port=8000, debug=True)