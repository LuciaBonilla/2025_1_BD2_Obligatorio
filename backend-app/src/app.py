from flask import Flask
from flask_cors import CORS

from controllers import register_controllers

app = Flask(__name__)
CORS(app)

register_controllers(app)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)