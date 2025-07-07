from Database import Database

from logger import logger

class Elector:
    @staticmethod
    def get_elector_by_ci(ci : int) -> dict | None:
        result = None
        conn = Database.get_database_connection()
        with conn.cursor() as cursor:
            cursor.callproc("obtener_elector_por_cedula", (ci,))
            result = cursor.fetchone()
        logger.info(result)
        return result
    
    @staticmethod
    def get_elector_by_cc(serie : str, numero : int) -> dict | None:
        result = None
        conn = Database.get_database_connection()
        with conn.cursor() as cursor:
            cursor.callproc("obtener_elector_por_credencial", (serie, numero))
            result = cursor.fetchone()
        return result