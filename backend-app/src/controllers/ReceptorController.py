from flask import request, jsonify, Blueprint

from Database import Database
from utils.auth.hash import verify_password
from utils.auth.jwt import generate_access_token, generate_refresh_token

receptor_bp = Blueprint("receptor", __name__)

@receptor_bp.route("/login", methods=["POST"])
def login():
    