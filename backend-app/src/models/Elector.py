from Database import Database
#
class Elector:
    @staticmethod
    def get_elector_by_cedula(cedula_elector : int) -> dict | None:
        """
            Retorna info del elector. --
        """
        result = None
        conn = Database.get_database_connection()
        with conn.cursor() as cursor:
            cursor.callproc("obtener_elector_por_cedula", (cedula_elector,))
            result = cursor.fetchone()
        return result
    
    @staticmethod
    def get_elector_by_credencial(serie_cc : str, numero_cc : int) -> dict | None:
        """
            Retorna info del elector, pero busca por la credencial. --
        """
        result = None
        conn = Database.get_database_connection()
        with conn.cursor() as cursor:
            cursor.callproc("obtener_elector_por_credencial", (serie_cc, numero_cc))
            result = cursor.fetchone()
        return result