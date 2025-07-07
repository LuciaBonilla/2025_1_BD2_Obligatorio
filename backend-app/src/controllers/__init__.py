from controllers.ElectorController import elector_bp
from controllers.AuthController import auth_bp

@staticmethod
def register_controllers(app):
    app.register_blueprint(elector_bp, url_prefix="/api")
    app.register_blueprint(auth_bp, url_prefix="/api")