from Database import Database
#
class Receptor:
    @staticmethod
    def get_hashed_password_by_cedula(cedula_receptor : int) -> str | None:
        """
            Retorna la contraseña hasheada del receptor. --
        """
        hashed_password = None
        conn = Database.get_database_connection()
        with conn.cursor() as cursor:
            cursor.callproc("obtener_hashed_password", (cedula_receptor,))
            result = cursor.fetchone()
            if result:
                hashed_password = result.get("Hashed_Password", None)
        return hashed_password