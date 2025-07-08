import pymysql, pymysql.cursors
from flask import g
import os

class Database:
    @staticmethod
    def get_database_connection():
        """
            Retorna una conexión a la base de datos MySQL.
        """
        if "database_connection" not in g:
            try:
                g.database_connection = pymysql.connect(
                    host=os.environ.get("DB_HOST", "localhost"),
                    port=int(os.environ.get("DB_PORT", 3306)),
                    user=os.environ["MYSQL_USER"],
                    password=os.environ["MYSQL_PASSWORD"],
                    database=os.environ["MYSQL_DATABASE"],
                    cursorclass=pymysql.cursors.DictCursor,
                    autocommit=True, # Hacer commit en las transacciones.
                )
            except pymysql.MySQLError as e:
                raise RuntimeError(f"Falló la conexión con la base de datos: {e}")
        return g.database_connection