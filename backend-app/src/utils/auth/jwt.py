import jwt
import datetime
import uuid
import os
from functools import wraps
from flask import request, jsonify
from zoneinfo import ZoneInfo

from models.TokenAcceso import TokenAcceso
from models.TokenRefresco import TokenRefresco
from models.TokenVoto import TokenVoto

JWT_SECRET = os.environ["JWT_SECRET"]
JWT_ALGORITHM = os.environ["JWT_ALGORITHM"]

# GENERADORES DE TOKEN

# cedula_receptor: miembro de la comisión receptora de voto es quién creó el token.

@staticmethod
def generate_access_token(cedula_receptor: int, expires_minutes: int = 10) -> dict:
    """
        Genera un token de acceso.
    """
    jti = str(uuid.uuid4())
    exp = datetime.datetime.now(ZoneInfo("America/Montevideo")) + datetime.timedelta(minutes=expires_minutes)

    payload = {
        "jti": jti,
        "sub": str(cedula_receptor),
        "exp": exp,
        "type": "access"
    }

    token = jwt.encode(payload=payload, key=JWT_SECRET, algorithm=JWT_ALGORITHM)
    return {"token": token, "jti": jti}

@staticmethod
def generate_refresh_token(cedula_receptor: int, expires_days: int = 1) -> dict:
    """
        Genera un token de refresco.
    """
    jti = str(uuid.uuid4())
    exp = datetime.datetime.now(ZoneInfo("America/Montevideo")) + datetime.timedelta(days=expires_days)

    payload = {
        "jti": jti,
        "sub": str(cedula_receptor),
        "exp": exp,
        "type": "refresh"
    }

    token = jwt.encode(payload=payload, key=JWT_SECRET, algorithm=JWT_ALGORITHM)
    return {"token": token, "jti": jti}

@staticmethod
def generate_vote_token(cedula_receptor: int, expires_minutes: int = 2) -> dict:
    """
        Genera un token de voto temporal para un elector.
    """
    jti = str(uuid.uuid4())
    exp = datetime.datetime.now(ZoneInfo("America/Montevideo")) + datetime.timedelta(minutes=expires_minutes)

    payload = {
        "jti": jti,
        "sub": str(cedula_receptor),
        "exp": exp,
        "type": "access"
    }

    token = jwt.encode(payload=payload, key=JWT_SECRET, algorithm=JWT_ALGORITHM)
    return {"token": token, "jti": jti}

@staticmethod
def decode_token(token: str) -> dict:
    """
        Decodifica y retorna el payload de un jwt.
    """
    return jwt.decode(jwt=token, key=JWT_SECRET, algorithms=[JWT_ALGORITHM])

# DECORADORES PARA VERIFICAR TOKENS.
@staticmethod
def access_token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        access_token = request.headers.get("Authorization", "").replace("Bearer ", "")

        # Verifica Existencia en el header.
        if not access_token:
            return jsonify({"error": "Token de acceso requerido"}), 401

        try:
            access_data = decode_token(access_token)
            
            # Verifica Tipo.
            if access_data["type"] != "access":
                return jsonify({"error": "Tipo de token invalido"}), 403
            
            # Verifica Existencia en la database (db).
            jti = access_data["jti"]
            token_data = TokenAcceso.get_token_by_jti(jti)
            if not token_data:
                return jsonify({"error": "Token de acceso no encontrado en la base de datos"}), 401

            # Verifica Validación en la db.
            expired_at = token_data["Expira_En"]
            expired_at = expired_at.replace(tzinfo=ZoneInfo("America/Montevideo"))
            revocated = token_data["Revocado"]
            now = datetime.datetime.now(ZoneInfo("America/Montevideo"))
            if now > expired_at:
                if not revocated:
                    TokenAcceso.revoke(jti) # Por si no está revocado.
                return jsonify({"error": "Token de acceso vencido"}), 401
            if revocated:
                return jsonify({"error": "Token de acceso revocado"}), 401
            
        except jwt.ExpiredSignatureError:
            # Verifica Existencia en la db y revoca por las dudas.
            access_data = jwt.decode(
                access_token,
                JWT_SECRET,
                algorithms=[JWT_ALGORITHM],
                options={"verify_exp": False}
            )
            jti = access_data["jti"]
            token_data = TokenAcceso.get_token_by_jti(jti)
            if not token_data:
                return jsonify({"error": "Token no encontrado en la base de datos"}), 401
            TokenAcceso.revoke(jti) # Por si no está revocado.
            return jsonify({"error": "Token vencido"}), 401
        
        except jwt.InvalidTokenError:
            return jsonify({"error": "Token invalido"}), 403
        
        # Token correcto y válido.
        return f(*args, **kwargs)
    return decorated

@staticmethod
def refresh_token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        data = request.get_json()
        refresh_token = data.get("Refresh_Token")

        # Verifica Existencia en el body request.
        if not refresh_token:
            return jsonify({"error": "Token de refresco requerido"}), 401

        try:
            refresh_data = decode_token(refresh_token)
            
            # Verifica Tipo.
            if refresh_data["type"] != "refresh":
                return jsonify({"error": "Tipo de token invalido"}), 403
            
            # Verifica Existencia en la database (db).
            jti = refresh_data["jti"]
            token_data = TokenRefresco.get_token_by_jti(jti)
            if not token_data:
                return jsonify({"error": "Token no encontrado en la base de datos"}), 401

            # Verifica Validación en la db.
            expired_at = token_data["Expira_En"]
            expired_at = expired_at.replace(tzinfo=ZoneInfo("America/Montevideo"))
            revocated = token_data["Revocado"]
            now = datetime.datetime.now(ZoneInfo("America/Montevideo"))
            if now > expired_at:
                if not revocated:
                    TokenRefresco.revoke(jti) # Por si no está revocado.
                return jsonify({"error": "Token vencido"}), 401
            if revocated:
                return jsonify({"error": "Token revocado"}), 401
            
        except jwt.ExpiredSignatureError:
            # Verifica Existencia en la db y revoca por las dudas.
            refresh_data = jwt.decode(
                refresh_token,
                JWT_SECRET,
                algorithms=[JWT_ALGORITHM],
                options={"verify_exp": False}
            )
            jti = refresh_data["jti"]
            token_data = TokenRefresco.get_token_by_jti(jti)
            if not token_data:
                return jsonify({"error": "Token no encontrado en la base de datos"}), 401
            TokenRefresco.revoke(jti) # Por si no está revocado.
            return jsonify({"error": "Token vencido"}), 401
        
        except jwt.InvalidTokenError:
            return jsonify({"error": "Token invalido"}), 403
        
        # Token correcto y válido.
        return f(*args, **kwargs)
    return decorated

@staticmethod
def vote_token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        vote_token = request.headers.get("Authorization", "").replace("Bearer ", "")
        if not vote_token:
            return jsonify({"error": "Token de voto requerido"}), 401

        try:
            data = decode_token(vote_token)
            if data["type"] != "access":
                return jsonify({"error": "Tipo de token inválido"}), 403

            jti = data["jti"]
            token_info = TokenVoto.get_token_by_jti(jti)
            if not token_info:
                return jsonify({"error": "Token de voto no encontrado"}), 401

            expired_at = token_info["Expira_En"].replace(tzinfo=ZoneInfo("America/Montevideo"))
            now = datetime.datetime.now(ZoneInfo("America/Montevideo"))
            if now > expired_at:
                if not token_info["Revocado"]:
                    TokenVoto.revoke(jti)
                return jsonify({"error": "Token de voto vencido"}), 401
            if token_info["Revocado"]:
                return jsonify({"error": "Token de voto revocado"}), 401

        except jwt.ExpiredSignatureError:
            return jsonify({"error": "Token expirado"}), 401
        except jwt.InvalidTokenError:
            return jsonify({"error": "Token inválido"}), 403

        return f(*args, **kwargs)
    return decorated