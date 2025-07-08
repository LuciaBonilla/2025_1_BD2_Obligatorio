from flask import Blueprint, jsonify

from models.Elector import Elector

from utils.auth.jwt import access_token_required

elector_bp = Blueprint("elector", __name__)

@elector_bp.route("/<int:cedula>", methods=["GET"])
@access_token_required
def get_elector_by_cedula(cedula):
    """
        Ej. SALIDA OK
        {
            "Cedula_Identidad": 10000000,
            "Nombre": "Jhon",
            "Apellido": "Doe",
            "Fecha_Nacimiento": "Tues 20 ...",
            "Serie_Credencial_Civica": "BBB",
            "Numero_Credencial_Civica": 17829
        }
    """
    try:
        elector = Elector.get_elector_by_cedula(cedula)
        if elector:
            return jsonify(elector)
        return jsonify({"error": "Elector no encontrado"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@elector_bp.route("/<string:serie>/<int:numero>", methods=["GET"])
@access_token_required
def get_elector_by_credencial(serie, numero):
    """
        Ej. SALIDA OK
        {
            "Cedula_Identidad": 10000000,
            "Nombre": "Jhon",
            "Apellido": "Doe",
            "Fecha_Nacimiento": "Tues 20 ...",
            "Serie_Credencial_Civica": "BBB",
            "Numero_Credencial_Civica": 17829
        }
    """
    try:
        elector = Elector.get_elector_by_credencial(serie_cc=serie, numero_cc=numero)
        if elector:
            return jsonify(elector)
        return jsonify({"error": "Elector no encontrado"}), 404
    except Exception as e:
            return jsonify({"error": str(e)}), 500