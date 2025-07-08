from flask import Blueprint, jsonify
from models.Tipos import Tipos

types_bp = Blueprint("tipos", __name__)

@types_bp.route("/observacion", methods=["GET"])
def get_tipos_observacion():
    """
        Ej. SALIDA OK
        [
            {
                "Codigo": 1,
                "Nombre": "SIMPLE"
            },
            {
                "Codigo": 2,
                "Nombre": "POR IDENTIDAD"
            }
        ]
    """
    try:
        result = Tipos.get_all_tipos_observacion()
        return jsonify(result), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@types_bp.route("/voto", methods=["GET"])
def get_tipos_voto():
    """
        Ej. SALIDA OK
        [
            {
                "Codigo": 1,
                "Nombre": "EN BLANCO"
            },
            {
                "Codigo": 1,
                "Nombre": "ANULADO"
            }
        ]
    """
    try:
        result = Tipos.get_all_tipos_voto()
        return jsonify(result), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500