from flask import Blueprint, jsonify
from models.ResultadosVotacion import ResultadosVotacion

results_bp = Blueprint("resultados", __name__)

@results_bp.route("/", methods=["GET"])
def get_resultados_votacion():
    try:
        resultados = ResultadosVotacion.get_resultados_votacion()
        if "error" in resultados:
            return jsonify({"error": resultados["error"]}), 404
        return jsonify(resultados), 200
    except Exception as e:
        return jsonify({"error": f"Ocurrió un error al obtener los resultados: {str(e)}"}), 500