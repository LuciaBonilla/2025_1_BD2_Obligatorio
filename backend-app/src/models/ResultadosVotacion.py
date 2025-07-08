from Database import Database
#
class ResultadosVotacion:
    @staticmethod
    def get_resultados_votacion():
        """
            Retorna los resultados de la última votación a nivel país. --
        """
        resultados = None
        conn = Database.get_database_connection()
        with conn.cursor() as cursor:
            # Obtener el código de la elección de la última elección transcurrida.
            cursor.callproc("obtener_codigo_de_eleccion_utlima")
            eleccion = cursor.fetchone()
            if not eleccion:
                return {"error": "No hay elección."}

            codigo_eleccion = eleccion["Codigo_Eleccion"]
            resultados = {}

            # 1. Personas habilitadas
            cursor.callproc("Cantidad_Total_De_Personas_Habilitadas")
            resultados["Personas_Habilitadas"] = cursor.fetchone()

            # 2. Votos emitidos
            cursor.callproc("Cantidad_Y_Porcentaje_De_Votos_Emitidos", (codigo_eleccion,))
            resultados["Votos_Emitidos"] = cursor.fetchone()

            # 3. Votos válidos
            cursor.callproc("Cantidad_Y_Porcentaje_De_Votos_Validos", (codigo_eleccion,))
            resultados["Votos_Validos"] = cursor.fetchone()

            # 4. Votos en blanco
            cursor.callproc("Cantidad_Y_Porcentaje_De_Votos_En_Blanco", (codigo_eleccion,))
            resultados["Votos_En_Blanco"] = cursor.fetchone()

            # 5. Votos anulados
            cursor.callproc("Cantidad_Y_Porcentaje_De_Votos_Anulados", (codigo_eleccion,))
            resultados["Votos_Anulados"] = cursor.fetchone()

            # 6. Votos a cada fórmula presidencial
            cursor.callproc("Cantidad_Y_Porcentaje_De_Votos_A_Cada_Formula", (codigo_eleccion,))
            formulas = cursor.fetchall()
            resultados["Votos_Por_Formula"] = formulas

        return resultados