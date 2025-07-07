from flask import Blueprint, request, jsonify

from models.Receptor import Receptor
from models.TokenAcceso import TokenAcceso
from models.TokenRefresco import TokenRefresco

from utils.auth import hash as hash_utils
from utils.auth import jwt as jwt_utils
from utils.auth.jwt import refresh_token_required, access_token_required

from logger import logger

auth_bp = Blueprint("auth", __name__)

@auth_bp.route("/login", methods=["POST"])
def login():
    body = request.get_json()
    ci = body.get("cedula")
    password = body.get("password")

    if not ci or not password:
        return jsonify({"error": "Cédula y contraseña requeridas"}), 400

    hashed = Receptor.get_hashed_password_by_ci(ci=ci)
    if not hashed:
        return jsonify({"error": "User no encontrado"}), 404

    if not hash_utils.verify_password(password, hashed):
        return jsonify({"error": f"Contraseña incorrecta {password}, {hashed}"}), 401

    access_data = jwt_utils.generate_access_token(ci=ci, expires_minutes=10)
    refresh_data = jwt_utils.generate_refresh_token(ci=ci, expires_days=1)
    
    TokenAcceso.save(jti=access_data["jti"], ci=ci)
    TokenRefresco.save(jti=refresh_data["jti"], ci=ci)

    return jsonify({
        "access_token": access_data["token"],
        "refresh_token": refresh_data["token"]
    }), 200
    
@auth_bp.route("/auth/refresh", methods=["POST"])
@refresh_token_required
def refresh_access_token():
    data = request.get_json()
    refresh_token = data.get("refresh_token")
    # Step 4: Generate new access token
    
    refresh_data = jwt_utils.decode_token(refresh_token)
    ci = refresh_data["sub"]
    
    access_data = jwt_utils.generate_access_token(int(ci))
    
    TokenAcceso.save(jti=access_data["jti"], ci=ci)
    
    return jsonify({
        "access_token": access_data["token"]
    }), 200

@auth_bp.route("/check_access_token", methods=["GET"])
@access_token_required
def check_access_token():
    return jsonify(), 200