from flask import Blueprint, jsonify
from models.ResultadosVotacion import ResultadosVotacion

results_bp = Blueprint("resultados", __name__)

@results_bp.route("/", methods=["GET"])
def get_resultados_votacion():
    """
        Ej. SALIDA OK
        {
            "Personas_Habilitadas": {
                "Cantidad": 99
            },
            "Votos_Anulados": {
                "Cantidad": 0,
                "Porcentaje": "0.00"
            },
            "Votos_Emitidos": {
                "Cantidad": 5,
                "Porcentaje": "100"
            },
            "Votos_En_Blanco": {
                "Cantidad": 0,
                "Porcentaje": "0.00"
            },
            "Votos_Por_Formula": [
                {
                    "Codigo_Formula": 8,
                    "Partido": "FRENTE AMPLIO",
                    "Cantidad": 3,
                    "Porcentaje": "60"
                },
                {
                    "Codigo_Formula": 10,
                    "Partido": "PARTIDO COLORADO",
                    "Cantidad": 2,
                    "Porcentaje": "20"
                },
            ],
            "Votos_Validos": {
                "Cantidad": 5,
                "Porcentaje": "100"
            }
        }
    """
    try:
        resultados = ResultadosVotacion.get_resultados_votacion()
        if "error" in resultados:
            return jsonify({"error": resultados["error"]}), 404
        return jsonify(resultados), 200
    except Exception as e:
        return jsonify({"error": f"Ocurrió un error al obtener los resultados: {str(e)}"}), 500