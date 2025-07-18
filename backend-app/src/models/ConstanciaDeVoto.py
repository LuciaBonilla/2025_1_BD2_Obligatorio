import datetime
from zoneinfo import ZoneInfo

from Database import Database
#
class ConstanciaDeVoto:
    @staticmethod
    def save(codigo_circuito: int, cedula_votante : int, codigo_tipo_observacion: int, comentarios_observacion: str) -> bool:
        """
            Registra la constancia de voto del votante. --
        """
        created_at = datetime.datetime.now(ZoneInfo("America/Montevideo"))
        
        conn = Database.get_database_connection()
        with conn.cursor() as cursor:
            cursor.callproc("registrar_constancia_de_voto", (codigo_circuito, created_at, cedula_votante, codigo_tipo_observacion, comentarios_observacion))
        return True