FROM python:3.11-slim

# Establece el directorio de trabajo dentro del contenedor.
WORKDIR /backend-app

# Copia el archivo requirements.txt y lo instala.
COPY requirements.txt .

# Instala las dependencias del proyecto.
RUN pip install --no-cache-dir -r requirements.txt

# Expone el puerto 5000.
EXPOSE 5000

# Comando para ejecutar la aplicación con hot reload y debug mode .
CMD ["flask", "--app", "./src/app.py", "--debug", "run","--host=0.0.0.0"]