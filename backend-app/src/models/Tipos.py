from Database import Database
from typing import Any
from utils.logger import logger
#
class Tipos:
    @staticmethod
    def get_all_tipos_observacion() -> tuple[dict[str, Any], ...] | None:
        """
            Retorna los tipos de observación. --
        """
        result = None
        conn = Database.get_database_connection()
        with conn.cursor() as cursor:
            cursor.callproc("obtener_tipos_de_observacion", ())
            result = cursor.fetchall()
        return result
    
    @staticmethod
    def get_all_tipos_voto() -> tuple[dict[str, Any], ...] | None:
        """
            Retorna los tipos de . --
        """
        result = None
        conn = Database.get_database_connection()
        with conn.cursor() as cursor:
            cursor.callproc("obtener_tipos_de_voto", ())
            result = cursor.fetchall()
        logger.info(result)
        return result