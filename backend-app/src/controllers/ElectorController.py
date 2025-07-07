from flask import Blueprint, jsonify, current_app

from models.Elector import Elector

from utils.auth.jwt import access_token_required

elector_bp = Blueprint("elector", __name__)

@elector_bp.route("/elector/<int:ci>", methods=["GET"])
@access_token_required
def get_elector_by_ci(ci):
    elector = Elector.get_elector_by_ci(ci)
    if elector:
        return jsonify(elector)
    return jsonify({"error": "Elector no encontrado"}), 404

@elector_bp.route("/elector/<string:serie>/<int:numero>", methods=["GET"])
@access_token_required
def get_elector_by_cc(serie, numero):
    elector = Elector.get_elector_by_cc(serie, numero)
    if elector:
        return jsonify(elector)
    return jsonify({"error": "Elector no encontrado"}), 404