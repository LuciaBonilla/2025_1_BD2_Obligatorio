from utils.formatData import format_circuito_result

from Database import Database
#
class Circuito:
    @staticmethod
    def get_codigo_circuito_by_cedula_receptor(cedula_receptor: int) -> int | None:
        """
            Retorna el identificador del circuito que le toca supervisar actualmente al receptor. --
        """
        conn = Database.get_database_connection()
        result = None

        # Obtener código de elección.
        with conn.cursor() as cursor:
            cursor.callproc("obtener_codigo_de_eleccion_hoy", ())
            row = cursor.fetchone()
        
        if row is None:
            return None

        codigo_eleccion = row["Codigo_Eleccion"]

        if not codigo_eleccion:
            return None

        # Obtener código de circuito.
        with conn.cursor() as cursor:
            cursor.callproc("obtener_codigo_de_circuito_de_receptor", (cedula_receptor, codigo_eleccion))
            result = cursor.fetchone()

        if result and "Codigo_Circuito" in result:
            return result["Codigo_Circuito"]
        else:
            return None
    
    @staticmethod
    def get_circuito_by_codigo(codigo_circuito : int) -> dict | None:
        """
            Retorna info del circuito.  ---
        """
        result = None
        conn = Database.get_database_connection()
        with conn.cursor() as cursor:
            cursor.callproc("obtener_circuito", (codigo_circuito,))
            result = cursor.fetchone()
            
        if result: # Cuidado, porque retorna en formato timedelta y no en string la hora.
            result = format_circuito_result(result)

        return result
    
    @staticmethod
    def open_circuito(codigo_circuito: int) -> bool:
        """
            Abre el circuito. --
        """
        conn = Database.get_database_connection()
        with conn.cursor() as cursor:
            cursor.callproc("abrir_circuito", (codigo_circuito,))
        return True
    
    @staticmethod
    def close_circuito(codigo_circuito: int) -> bool:
        """
            Cierra el circuito.
        """
        conn = Database.get_database_connection()
        with conn.cursor() as cursor:
            cursor.callproc("cerrar_circuito", (codigo_circuito,))
        return True