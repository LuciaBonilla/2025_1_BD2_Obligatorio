from controllers.ElectorController import elector_bp
from controllers.AuthController import auth_bp
from controllers.CircuitoController import circuito_bp
from controllers.ResultadosVotacionController import results_bp
from controllers.ConstanciaDeVotoController import constancia_bp
from controllers.VotoController import vote_bp

@staticmethod
def register_controllers(app):
    app.register_blueprint(elector_bp, url_prefix="/api/elector")
    app.register_blueprint(auth_bp, url_prefix="/api/auth")
    app.register_blueprint(circuito_bp, url_prefix="/api/circuito")
    app.register_blueprint(results_bp, url_prefix="/api/resultados")
    app.register_blueprint(constancia_bp, url_prefix="/api/constancia")
    app.register_blueprint(vote_bp, url_prefix="/api/voto")
    