from flask import Flask
from controllers import register_controllers

app = Flask(__name__)
register_controllers(app)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)