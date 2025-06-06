# Usa una imagen oficial de ... como base.
FROM alpine:3.13-slim

# Establece el directorio de trabajo dentro del contenedor.
WORKDIR /src

# Copia el archivo requirements.txt y lo instala.
COPY requirements.txt .

# Instala las dependencias del proyecto.
RUN pip install --no-cache-dir -r requirements.txt

# Expone el puerto 5000.
EXPOSE 5000

# Comando para ejecutar la aplicación con hot reload y debug mode .
CMD ["flask", "--app", "app.py", "--debug", "run","--host=0.0.0.0"]