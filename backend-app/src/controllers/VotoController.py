from flask import Blueprint, jsonify, request

from models.Circuito import Circuito
from models.HojaDeVotacion import HojaDeVotacion
from models.Voto import Voto

from utils.auth.jwt import vote_token_required

vote_bp = Blueprint("vote", __name__)

@vote_bp.route("/hojas/<int:codigo_circuito>", methods=["GET"])
@vote_token_required
def get_all_hojas(codigo_circuito):
    try:
        hojas = HojaDeVotacion.get_all_hojas_votacion(codigo_circuito)
        return jsonify(hojas), 200
    except Exception as e:
        return jsonify({"error": f"Error al obtener hojas: {str(e)}"}), 500
    
    
@vote_bp.route("/emitir-voto", methods=["POST"])
@vote_token_required
def emitir_voto():
    data = request.get_json()
    
    tipo_code = data.get("Codigo_Tipo")             
    hoja_code = data.get("Codigo_Hoja")             
    circuito_code = data.get("Codigo_Circuito")

    if tipo_code is None or circuito_code is None:
        return jsonify({"error": "Faltan datos obligatorios"}), 400

    try:
        Voto.save(codigo_tipo_voto=tipo_code, codigo_hoja_votacion=hoja_code, codigo_circuito=circuito_code)
        return jsonify({"success": True, "message": "Voto registrado exitosamente"}), 200
    except Exception as e:
        return jsonify({"error": f"Error al registrar el voto: {str(e)}"}), 500