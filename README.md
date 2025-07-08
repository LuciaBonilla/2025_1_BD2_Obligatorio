# 2025_1_BD2_Obligatorio

Grupo 5: Bonilla, Araujo, Cabrera

Veanse los documentos relacionados [aquí](./docs/)

## Pasos Previos

Para cargar los [datos](./data/datos_bd_uruguay) en la base de datos, se debe cambiar en Visual Studio Code el ``End of Line Sequence`` de cada archivo .csv a ``LF`` (esto quiere decir que las líneas del CSV terminan en ``\n``). Luego se pueden encender los contenedores.

## ¿Cómo Inicializar?

Utilizar el archivo [docker-compose](./docker-compose.yml) para levantar los tres contenedores Docker:

- backend (con Flask)
- frontend (con React+Vite)
- bases de datos (instancia de MySQL)

Cuando se inicialice por primera vez el contenedor de bases de datos, se ejecutarán los [scripts SQL](./scripts) en orden alfabético:

1. crear tablas del modelo
2. crear tablas de token de acceso
3. insertar datos básicos
4. cargar datos base con load
5. crear los procedimientos con las transacciones correspondientes

## ¿Cómo Probar la Aplicación?

1. Modificar un poco los datos de los archivos .csv para lograr probar las funciones básicas (debido a las fechas y horas).
2. Crear una conexión con la base de datos para ver sus datos.
3. Encender los tres contenedores e ir a http://localhost:5173 para probar las funcionalidades básicas a través de una interfaz sencilla.

Utilizar dos navegadores web (ej. Google por un lado y Microsoft Edge por el otro) para simular:

 - que el presidente de la mesa está en su tablet y (registrando constancias)
 - que el elector vota en el dispositivo dedicado para ello en el circuito (registrando un sólo voto)

## Funcionalidades Básicas de la Aplicación en una Elección

### Como Público general

[x] Ver resultados de la elección (la última elección realizada por fecha).

### Como Receptor de Votos

[x] Iniciar sesión para realizar mis funciones.
[x] Abrir y cerrar el circuito que me tocó.
[x] Buscar electores dada su cédula o credencial.
[x] Registrar constancias de voto normal u observadas como receptor.

### Como Elector

[x] Votar de forma secreta (si no se tienen en cuenta las fechas de creación de los registros ;) ).
[x] Votar anulado, en blanco o a una hoja.
[x] Votar una única vez.
