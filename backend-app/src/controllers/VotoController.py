from flask import Blueprint, jsonify, request

from models.HojaDeVotacion import HojaDeVotacion
from models.Voto import Voto

from utils.auth.jwt import vote_token_required

vote_bp = Blueprint("voto", __name__)

@vote_bp.route("/hojas", methods=["GET"])
@vote_token_required
def get_all_hojas():
    """
        Ej. SALIDA OK
        [
            {
                "Codigo_Hoja": 10,
		        "Numero": 17,                          
		        "Partido_Politico": "FRENTE AMPLIO"
            },
            {
                ...
            }
        ]
    """
    try:
        hojas = HojaDeVotacion.get_all_hojas_votacion()
        return jsonify(hojas), 200
    except Exception as e:
        return jsonify({"error": f"Error al obtener hojas: {str(e)}"}), 500
    
    
@vote_bp.route("/emitir-voto", methods=["POST"])
@vote_token_required
def emitir_voto():
    """
        Ej. ENTRADA OK
        {
            "Codigo_Tipo": 1
            "Codigo_Circuito": 67
            "Codigo_Hoja": 789
        }
    """
    try:
        data = request.get_json()
        
        tipo_code = data.get("Codigo_Tipo")             
        hoja_code = data.get("Codigo_Hoja")             
        circuito_code = data.get("Codigo_Circuito")

        if (tipo_code is not None and hoja_code is not None) or (tipo_code is None and hoja_code is None) or circuito_code is None:
            return jsonify({"error": "Faltan datos obligatorios"}), 400

        Voto.save(codigo_tipo_voto=tipo_code, codigo_hoja_votacion=hoja_code, codigo_circuito=circuito_code)
        return jsonify({"success": True, "message": "Voto registrado exitosamente"}), 200
    except Exception as e:
        return jsonify({"error": f"Error al registrar el voto: {str(e)}"}), 500