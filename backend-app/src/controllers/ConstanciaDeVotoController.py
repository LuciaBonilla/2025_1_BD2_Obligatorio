from flask import Blueprint, request, jsonify
from models.ConstanciaDeVoto import ConstanciaDeVoto
from utils.auth.jwt import access_token_required

constancia_bp = Blueprint("constancia", __name__)

@constancia_bp.route("/registrar", methods=["POST"])
@access_token_required
def registrar_constancia():
    """
        Ej. ENTRADA OK
        {
            "Cedula_Votante": 837482378
            "Codigo_Circuito": 123
            "Codigo_Tipo_observacion": 1,
            "Comentarios_Observacion": "no sé"
        }
        Ej. SALIDA OK
        {
            "success": true,
            "message": "Constancia de voto registrada"
        }
    """
    try:
        data = request.get_json()
        ci = data.get("Cedula_Votante")
        circuito_code = data.get("Codigo_Circuito")
        tipo_observacion = data.get("Codigo_Tipo_observacion")
        comentarios = data.get("Comentarios_Observacion")

        if not ci or not circuito_code:
            return jsonify({"error": "Datos faltantes"}), 400

        ConstanciaDeVoto.save(codigo_circuito=circuito_code,
                              cedula_votante=ci,
                              codigo_tipo_observacion=tipo_observacion,
                              comentarios_observacion=comentarios)
        return jsonify({"success": True, "message": "Constancia de voto registrada"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500