# 2025_1_BD2_Obligatorio

Grupo 5: Bonilla, Araujo, Cabrera

Link al informe [aquí](https://docs.google.com/document/d/1_E2cQOXrPmttcPTCjF_R5iAYqrnf_vXnKAsdBzgbgSQ/edit?usp=sharing)

## ¿Cómo Inicializar?

Utilizar el archivo [docker-compose](./docker-compose.yml) para levantar los tres contenedores Docker:

- backend (con Flask)
- frontend (con React+Vite)
- bases de datos (instancia de MySQL)

Cuando se inicialice por primera vez el contenedor de bases de datos, se ejecutarán los [scripts SQL](./scripts) en orden alfabético:

1. crear tablas del modelo
2. crear tablas de token de acceso
3. insertar datos básicos
4. crear los procedimientos con las transacciones correspondientes

## ¿Cómo Cargar Todos los Datos en la Base de Datos?

Para cargar los [datos](./data/datos_bd_uruguay), se debe cambiar en Visual Studio Code el ``End of Line Sequence`` de cada archivo .csv a ``LF`` (esto quiere decir que la líneas del CSV terminan en ``\n``). Luego se debe ejecutar el [archivo para la carga](./data/datos_bd_uruguay/load-data-G5.sql), mientras el contenedor de bases de datos esté encendido.

## ¿Cómo Probar la Aplicación?

Encender los tres contenedores e ir a http://localhost:5173 para probar las funcionalidades básicas a través de una interfaz.

## Funcionalidades de la Aplicación

[]
[]
