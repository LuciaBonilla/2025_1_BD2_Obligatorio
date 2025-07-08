import datetime
from zoneinfo import ZoneInfo

from Database import Database
#
class TokenRefresco:    
    @staticmethod
    def save(jti : str, cedula_receptor : int) -> bool:
        # Datos para el insert.
        created_by = cedula_receptor
        created_at = datetime.datetime.now(ZoneInfo("America/Montevideo"))
        expires_at = created_at + datetime.timedelta(days=1)
        
        conn = Database.get_database_connection()
        with conn.cursor() as cursor:
            cursor.callproc("registrar_token_refresco", (jti, created_by, created_at, expires_at))
        return True

    @staticmethod
    def revoke(jti : str) -> bool:
        conn = Database.get_database_connection()
        with conn.cursor() as cursor:
            cursor.callproc("revocar_token_refresco", (jti,))
        return True
    
    @staticmethod
    def get_token_by_jti(jti : str) -> dict | None:
        result = None
        conn = Database.get_database_connection()
        with conn.cursor() as cursor:
            cursor.callproc("obtener_token_refresco_por_jti", (jti,))
            result = cursor.fetchone()
        return result