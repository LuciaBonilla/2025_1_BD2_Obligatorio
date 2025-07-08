from flask import Blueprint, request, jsonify

from models.Receptor import Receptor
from models.Circuito import Circuito
from models.TokenAcceso import TokenAcceso
from models.TokenRefresco import TokenRefresco
from models.TokenVoto import TokenVoto

from utils.auth import hash as hash_utils
from utils.auth import jwt as jwt_utils
from utils.auth.jwt import refresh_token_required, access_token_required


auth_bp = Blueprint("auth", __name__)
@auth_bp.route("/receptor/login", methods=["POST"])
def login():
    body = request.get_json()
    ci = body.get("Cedula")
    password = body.get("Password")
    
    if not ci or not password:
        return jsonify({"error": "Cédula y contraseña requeridas"}), 400

    hashed = Receptor.get_hashed_password_by_cedula(ci)
    if not hashed:
        return jsonify({"error": "User no encontrado"}), 404

    if not hash_utils.verify_password(password, hashed):
        return jsonify({"error": f"Contraseña incorrecta {password}, {hashed}"}), 401

    access_data = jwt_utils.generate_access_token(cedula_receptor=ci, expires_minutes=10)
    refresh_data = jwt_utils.generate_refresh_token(cedula_receptor=ci, expires_days=1)
    
    TokenAcceso.save(jti=access_data["jti"], cedula_receptor=ci)
    TokenRefresco.save(jti=refresh_data["jti"], cedula_receptor=ci)
    
    circuito_code = Circuito.get_codigo_circuito_by_cedula_receptor(ci)

    return jsonify({
        "Access_Token": access_data["token"],
        "Refresh_Token": refresh_data["token"],
        "Codigo_Circuito": circuito_code
    }), 200
    
@auth_bp.route("/receptor/refresh-auth", methods=["POST"])
@refresh_token_required
def refresh_access_token():
    data = request.get_json()
    refresh_token = data.get("Refresh_Token")

    refresh_data = jwt_utils.decode_token(refresh_token)
    ci = refresh_data["sub"]
    access_data = jwt_utils.generate_access_token(cedula_receptor=int(ci), expires_minutes=10)
    
    TokenAcceso.save(jti=access_data["jti"], cedula_receptor=ci)
    
    return jsonify({
        "Access_Token": access_data["token"]
    }), 200

@auth_bp.route("/receptor/check-access-token", methods=["GET"])
@access_token_required
def check_access_token():
    return jsonify(), 200

@auth_bp.route("/enable-vote", methods=["POST"])
def get_vote_token():
    body = request.get_json()
    ci = body.get("Cedula")
    password = body.get("Password")

    if not ci or not password:
        return jsonify({"error": "Cédula y contraseña requeridas"}), 400

    hashed = Receptor.get_hashed_password_by_cedula(ci)
    if not hashed:
        return jsonify({"error": "User no encontrado"}), 404

    if not hash_utils.verify_password(password, hashed):
        return jsonify({"error": f"Contraseña incorrecta {password}, {hashed}"}), 401

    vote_data = jwt_utils.generate_access_token(cedula_receptor=ci, expires_minutes=10)
    
    TokenVoto.save(jti=vote_data["jti"], cedula_receptor=ci)
    
    circuito_code = Circuito.get_codigo_circuito_by_cedula_receptor(ci)

    return jsonify({
        "Vote_Token": vote_data["token"],
        "Codigo_Circuito": circuito_code
    }), 200