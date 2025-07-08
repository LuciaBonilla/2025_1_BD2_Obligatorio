from Database import Database
from typing import Any
from utils.logger import logger
#
class HojaDeVotacion:
    @staticmethod
    def get_all_hojas_votacion() -> tuple[dict[str, Any], ...] | None:
        """
            Retorna todas las hojas de votación. --
        """
        result = None
        conn = Database.get_database_connection()
        with conn.cursor() as cursor:
            cursor.callproc("obtener_hojas_de_votacion", ())
            result = cursor.fetchall()
        logger.info(result)
        return result