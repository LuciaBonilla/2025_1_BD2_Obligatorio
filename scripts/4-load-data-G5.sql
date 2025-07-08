USE AM_Grupo5;

SHOW VARIABLES LIKE "secure_file_priv";

LOAD DATA INFILE "/var/lib/mysql-files/LOCALIDAD.csv"
INTO TABLE LOCALIDAD
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
IGNORE 1 LINES
(Nombre,Codigo_Departamento,Codigo_Tipo_Localidad);

LOAD DATA INFILE "/var/lib/mysql-files/ESTABLECIMIENTO.csv"
INTO TABLE ESTABLECIMIENTO
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
IGNORE 1 LINES
(Nombre,Calle,Codigo_Postal,Nombre_Barrio,Es_Accesible,Codigo_Localidad);

LOAD DATA INFILE "/var/lib/mysql-files/LUGAR_DE_TRABAJO.csv"
INTO TABLE LUGAR_DE_TRABAJO
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
IGNORE 1 LINES
(Nombre);

LOAD DATA INFILE "/var/lib/mysql-files/PERSONA.csv"
INTO TABLE PERSONA
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
IGNORE 1 LINES
(Cedula_Identidad,Nombre,Apellido,Fecha_Nacimiento,Serie_Credencial_Civica,Numero_Credencial_Civica);

LOAD DATA INFILE "/var/lib/mysql-files/POLICIA.csv"
INTO TABLE POLICIA
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
IGNORE 1 LINES
(Cedula_Identidad,Codigo_Comisaria);

LOAD DATA INFILE "/var/lib/mysql-files/RECEPTOR.csv"
INTO TABLE RECEPTOR
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
IGNORE 1 LINES
(Cedula_Identidad,Hashed_Password);

LOAD DATA INFILE "/var/lib/mysql-files/TRABAJO_DE_RECEPTOR.csv"
INTO TABLE TRABAJO_DE_RECEPTOR
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
IGNORE 1 LINES
(Cedula_Identidad_Receptor,Codigo_Lugar_Trabajo);

LOAD DATA INFILE "/var/lib/mysql-files/ELECTOR.csv"
INTO TABLE ELECTOR
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
IGNORE 1 LINES
(Cedula_Identidad);

LOAD DATA INFILE "/var/lib/mysql-files/CANDIDATO.csv"
INTO TABLE CANDIDATO
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
IGNORE 1 LINES
(Cedula_Identidad);

LOAD DATA INFILE "/var/lib/mysql-files/ELECCION.csv"
INTO TABLE ELECCION
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
IGNORE 1 LINES
(Fecha_Votacion,Hora_Inicio_Votacion,Hora_Fin_Votacion);

LOAD DATA INFILE "/var/lib/mysql-files/CIRCUITO.csv"
INTO TABLE CIRCUITO
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
IGNORE 1 LINES
(Numero,Serie_Civica,Numero_Desde,Numero_Hasta,Esta_Cerrado,Codigo_Tipo_Circuito,Codigo_Establecimiento,Codigo_Eleccion);

LOAD DATA INFILE "/var/lib/mysql-files/PARTIDO_POLITICO.csv"
INTO TABLE PARTIDO_POLITICO
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
IGNORE 1 LINES
(Codigo,Lema,Codigo_Sede);

LOAD DATA INFILE "/var/lib/mysql-files/FORMULA_PRESIDENCIAL.csv"
INTO TABLE FORMULA_PRESIDENCIAL
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
IGNORE 1 LINES
(Codigo_Partido);

LOAD DATA INFILE "/var/lib/mysql-files/HOJA_DE_VOTACION.csv"
INTO TABLE HOJA_DE_VOTACION
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
IGNORE 1 LINES
(Numero,Codigo_Eleccion,Codigo_Departamento,Codigo_Formula_Presidencial);

LOAD DATA INFILE "/var/lib/mysql-files/CANDIDATURA.csv"
INTO TABLE CANDIDATURA
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
IGNORE 1 LINES
(Cedula_Identidad_Candidato,Codigo_Cargo_Politico,Codigo_Formula_Presidencial);

LOAD DATA INFILE "/var/lib/mysql-files/SUPERVISION.csv"
INTO TABLE SUPERVISION
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
IGNORE 1 LINES
(Cedula_Identidad_Receptor,Codigo_Rol_Comision,Codigo_Circuito);

LOAD DATA INFILE "/var/lib/mysql-files/CUSTODIA.csv"
INTO TABLE CUSTODIA
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
IGNORE 1 LINES
(Cedula_Identidad_Policia,Codigo_Circuito);