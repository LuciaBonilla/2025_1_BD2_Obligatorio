from flask import Blueprint, jsonify, request

from models.Circuito import Circuito

from utils.auth.jwt import access_token_required

circuito_bp = Blueprint("circuito", __name__)

@circuito_bp.route("/<int:codigo>/abrir", methods=["POST"])
@access_token_required
def open_circuito(codigo):
    """
        Ej. SALIDA OK
        {
            "success": true,
            "message": "Circuito abierto correctamente."
        }
    """
    try:
        Circuito.open_circuito(codigo)
        return jsonify({"success": True, "message": "Circuito abierto correctamente."}), 200
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

@circuito_bp.route("/<int:codigo>/cerrar", methods=["POST"])
@access_token_required
def close_circuito(codigo):
    """
        Ej. SALIDA OK
        {
            "success": true,
            "message": "Circuito cerrado correctamente."
        }
    """
    try:
        Circuito.close_circuito(codigo)
        return jsonify({"success": True, "message": "Circuito cerrado correctamente."}), 200
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

@circuito_bp.route("/<int:codigo>", methods=["GET"])
@access_token_required
def get_circuito(codigo):
    """
        Ej. SALIDA OK
        {
            "Codigo": 123,
            "Numero": 456,
            "Serie_Civica": "ABB",
            "Numero_Desde": 1,
            "Numero_Hasta": 300,
            "Esta_Cerrado": true,
            "Tipo": "RURAL",
            "Fecha_Votacion": "Mon 17 ...",
            "Hora_Inicio_Votacion": "10:00:00",
            "Hora_Fin_Votacion": "20:00:00"
        }
    """
    try:
        circuito = Circuito.get_circuito_by_codigo(codigo)
        if not circuito:
            return jsonify({"error": "Circuito no encontrado"}), 404
        return jsonify(circuito), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
