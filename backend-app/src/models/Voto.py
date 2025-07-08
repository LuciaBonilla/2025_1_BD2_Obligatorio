from Database import Database

class Voto:
    @staticmethod
    def save(codigo_tipo_voto : int, codigo_hoja_votacion: int, codigo_circuito: int) -> bool:
        conn = Database.get_database_connection()
        with conn.cursor() as cursor:
            cursor.callproc("votar", (codigo_tipo_voto, codigo_hoja_votacion, codigo_circuito))
        return True