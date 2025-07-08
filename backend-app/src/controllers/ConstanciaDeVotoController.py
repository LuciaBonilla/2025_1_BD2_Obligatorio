from flask import Blueprint, request, jsonify
from models.ConstanciaDeVoto import ConstanciaDeVoto
from utils.auth.jwt import vote_token_required

constancia_bp = Blueprint("constancia", __name__)

@constancia_bp.route("/registrar", methods=["POST"])
@vote_token_required
def registrar_constancia():
    data = request.get_json()
    ci = data.get("Cedula_Votante")
    circuito_code = data.get("Codigo_Circuito")
    tipo_observacion = data.get("Codigo_Tipo_observacion")
    comentarios = data.get("Comentarios_Observacion")

    if not ci or not circuito_code:
        return jsonify({"error": "Datos faltantes"}), 400

    try:
        ConstanciaDeVoto.save(codigo_circuito=circuito_code,
                              cedula_votante=ci,
                              codigo_tipo_observacion=tipo_observacion,
                              comentarios_observacion=comentarios)
        return jsonify({"success": True, "message": "Constancia de voto registrada"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500