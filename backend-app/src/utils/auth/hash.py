import bcrypt

@staticmethod
def hash_password(password: str) -> str:
    """
        Retorna la contraseña hasheada.
    """
    salt = bcrypt.gensalt()
    return bcrypt.hashpw(password.encode('utf-8'), salt).decode('utf-8')

@staticmethod
def verify_password(password: str, hashed: str) -> bool:
    """
        Verifica que la contraseña normal y la hasehada sean iguales.
    """
    return bcrypt.checkpw(password.encode('utf-8'), hashed.encode('utf-8'))