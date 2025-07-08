from Database import Database
from typing import Any
#
class HojaDeVotacion:
    @staticmethod
    def get_all_hojas_votacion(codigo_circuito : int) -> tuple[dict[str, Any], ...] | None:
        """
            Retorna las hojas de votación que puede usar un circuito (o sea, las del departamento donde se ubica). --
        """
        result = None
        conn = Database.get_database_connection()
        with conn.cursor() as cursor:
            cursor.callproc("obtener_hojas_de_votacion", (codigo_circuito,))
            result = cursor.fetchall()
        return result