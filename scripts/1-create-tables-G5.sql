USE AM_Grupo5;

-- Tablas para categorizar
CREATE TABLE TIPO_LOCALIDAD (--
    Codigo TINYINT UNSIGNED 					PRIMARY KEY,
    Nombre ENUM('PARAJE', 'PUEBLO', 'CIUDAD') 	NOT NULL
);

CREATE TABLE TIPO_CIRCUITO (--
    Codigo TINYINT UNSIGNED 					PRIMARY KEY,
    Nombre ENUM('RURAL', 'URBANO') 				NOT NULL
);

CREATE TABLE TIPO_VOTO (--
    Codigo TINYINT UNSIGNED 					PRIMARY KEY,
    Nombre ENUM('ANULADO', 'EN BLANCO') 		NOT NULL
);

CREATE TABLE TIPO_OBSERVACION (--
    Codigo TINYINT UNSIGNED 					PRIMARY KEY,
    Nombre ENUM('SIMPLE', 'POR IDENTIDAD') 		NOT NULL
);

CREATE TABLE ROL_COMISION_RECEPTORA (--
    Codigo TINYINT UNSIGNED 					PRIMARY KEY,
    Nombre ENUM('PRESIDENTE', 'SECRETARIO', 'VOCAL', 'SUPLENTE') NOT NULL
);

CREATE TABLE CARGO_POLITICO (--
    Codigo TINYINT UNSIGNED 					PRIMARY KEY,
    Nombre ENUM('PRESIDENTE', 'VICEPRESIDENTE') NOT NULL
);

-- Tablas acerca de Zonas
CREATE TABLE DEPARTAMENTO (--
    Codigo TINYINT UNSIGNED 					PRIMARY KEY,
    Nombre VARCHAR(30) 							NOT NULL UNIQUE
);

CREATE TABLE LOCALIDAD (--
    Codigo SMALLINT UNSIGNED 					PRIMARY KEY,
    Nombre VARCHAR(90) 							NOT NULL,
    Codigo_Departamento TINYINT UNSIGNED		,
    Codigo_Tipo_Localidad TINYINT UNSIGNED 		NOT NULL,
    FOREIGN KEY (Codigo_Departamento) 	REFERENCES DEPARTAMENTO(Codigo),
    FOREIGN KEY (Codigo_Tipo_Localidad) REFERENCES TIPO_LOCALIDAD(Codigo)
);

CREATE TABLE ESTABLECIMIENTO (--
    Codigo INT UNSIGNED 						PRIMARY KEY,
    Nombre VARCHAR(90) 							NOT NULL,
    Calle VARCHAR(90)							,
    Codigo_Postal MEDIUMINT UNSIGNED 			NOT NULL,
    Nombre_Barrio VARCHAR(90)					,
    Codigo_Localidad SMALLINT UNSIGNED,
    
    FOREIGN KEY (Codigo_Localidad) REFERENCES LOCALIDAD(Codigo)
);

CREATE TABLE LUGAR_DE_TRABAJO (--
    Codigo INT UNSIGNED 						PRIMARY KEY,
    Nombre VARCHAR(90) 							NOT NULL
);

-- Tablas acerca de Personas
CREATE TABLE PERSONA (--
    Cedula_Identidad INT UNSIGNED 				PRIMARY KEY,
    CHECK (Cedula_Identidad < 99999999 AND Cedula_Identidad > 1000000),
    
    Nombre VARCHAR(90) 							NOT NULL,
    Apellido VARCHAR(90) 						NOT NULL,
    Dia_Nacimiento DATE 						NOT NULL,
    Anio_Nacimiento SMALLINT UNSIGNED 			NOT NULL,
    Serie_Credencial_Civica VARCHAR(6) 			NOT NULL,
    Numero_Credencial_Civica SMALLINT UNSIGNED 	NOT NULL
);

CREATE TABLE POLICIA (--
    Cedula_Identidad INT UNSIGNED 				PRIMARY KEY,
    CHECK (Cedula_Identidad < 99999999 AND Cedula_Identidad > 1000000),
    
    Codigo_Comisaria INT UNSIGNED				,
    FOREIGN KEY (Cedula_Identidad) REFERENCES PERSONA(Cedula_Identidad),
    FOREIGN KEY (Codigo_Comisaria) REFERENCES ESTABLECIMIENTO(Codigo)
);

CREATE TABLE RECEPTOR (--
    Cedula_Identidad INT UNSIGNED 				PRIMARY KEY,
    CHECK (Cedula_Identidad < 99999999 AND Cedula_Identidad > 1000000),
    
    FOREIGN KEY (Cedula_Identidad) REFERENCES PERSONA(Cedula_Identidad)
);

CREATE TABLE TRABAJO_DE_RECEPTOR (--
    Cedula_Identidad_Receptor INT UNSIGNED		,
    CHECK (Cedula_Identidad_Receptor < 99999999 AND Cedula_Identidad_Receptor > 1000000),
    
    Codigo_Lugar_Trabajo INT UNSIGNED			,
    PRIMARY KEY (Cedula_Identidad_Receptor, Codigo_Lugar_Trabajo),
    FOREIGN KEY (Cedula_Identidad_Receptor) REFERENCES RECEPTOR(Cedula_Identidad),
    FOREIGN KEY (Codigo_Lugar_Trabajo) 		REFERENCES LUGAR_DE_TRABAJO(Codigo)
);

CREATE TABLE ELECTOR (--
    Cedula_Identidad INT UNSIGNED 				PRIMARY KEY,
    CHECK (Cedula_Identidad < 99999999 AND Cedula_Identidad > 1000000),
    
    FOREIGN KEY (Cedula_Identidad) REFERENCES PERSONA(Cedula_Identidad)
);

CREATE TABLE CANDIDATO (--
    Cedula_Identidad INT UNSIGNED 				PRIMARY KEY,
    CHECK (Cedula_Identidad < 99999999 AND Cedula_Identidad > 1000000),
    
    FOREIGN KEY (Cedula_Identidad) REFERENCES PERSONA(Cedula_Identidad)
);

-- Tablas acerca de Elecciones
CREATE TABLE ELECCION (--
    Codigo MEDIUMINT UNSIGNED				PRIMARY KEY,
    Dia_Votacion DATE 						NOT NULL,
    Anio_Votacion SMALLINT UNSIGNED 		NOT NULL,
    Hora_Inicio_Votacion TIME 				NOT NULL,
    Hora_Fin_Votacion TIME 					NOT NULL
);

CREATE TABLE CIRCUITO (--
    Codigo MEDIUMINT UNSIGNED 				PRIMARY KEY,
    Numero MEDIUMINT UNSIGNED 				NOT NULL,
    Serie_Civica VARCHAR(6) 				NOT NULL,
    Numero_Desde SMALLINT UNSIGNED 			NOT NULL,
    Numero_Hasta SMALLINT UNSIGNED			NOT NULL,
    CHECK (Numero_Hasta > Numero_Desde),
    
    Es_Accesible BOOLEAN					,
    Codigo_Tipo_Circuito TINYINT UNSIGNED 	NOT NULL,
    Codigo_Establecimiento INT UNSIGNED		,
    Codigo_Eleccion MEDIUMINT UNSIGNED 		NOT NULL,
    FOREIGN KEY (Codigo_Tipo_Circuito) 		REFERENCES TIPO_CIRCUITO(Codigo),
    FOREIGN KEY (Codigo_Establecimiento) 	REFERENCES ESTABLECIMIENTO(Codigo),
    FOREIGN KEY (Codigo_Eleccion) 			REFERENCES ELECCION(Codigo)
);

CREATE TABLE PARTIDO_POLITICO (--
    Codigo SMALLINT UNSIGNED 				PRIMARY KEY,
    Lema VARCHAR(90) 						NOT NULL,
    Codigo_Sede INT UNSIGNED				,
    FOREIGN KEY (Codigo_Sede) REFERENCES ESTABLECIMIENTO(Codigo)
);

CREATE TABLE FORMULA_PRESIDENCIAL (--
    Codigo SMALLINT UNSIGNED 				PRIMARY KEY,
    Codigo_Partido SMALLINT UNSIGNED 		NOT NULL,
    FOREIGN KEY (Codigo_Partido) REFERENCES PARTIDO_POLITICO(Codigo)
);

CREATE TABLE HOJA_VOTACION (--
    Codigo MEDIUMINT UNSIGNED 				PRIMARY KEY,
    Numero SMALLINT UNSIGNED				NOT NULL,
    Codigo_Eleccion MEDIUMINT UNSIGNED		NOT NULL,
    Codigo_Formula_Presidencial 			SMALLINT UNSIGNED,
    FOREIGN KEY (Codigo_Eleccion) REFERENCES ELECCION(Codigo),
    FOREIGN KEY (Codigo_Formula_Presidencial) REFERENCES FORMULA_PRESIDENCIAL(Codigo)
);

CREATE TABLE CANDIDATURA (--
    Cedula_Identidad_Candidato INT UNSIGNED			,
    CHECK (Cedula_Identidad_Candidato < 99999999 AND Cedula_Identidad_Candidato > 1000000),
    
    Codigo_Cargo_Politico TINYINT UNSIGNED			NOT NULL,
    Codigo_Formula_Presidencial SMALLINT UNSIGNED	,
    PRIMARY KEY (Cedula_Identidad_Candidato, Codigo_Formula_Presidencial),
    FOREIGN KEY (Cedula_Identidad_Candidato) REFERENCES CANDIDATO(Cedula_Identidad),
    FOREIGN KEY (Codigo_Cargo_Politico) REFERENCES CARGO_POLITICO(Codigo),
    FOREIGN KEY (Codigo_Formula_Presidencial) REFERENCES FORMULA_PRESIDENCIAL(Codigo)
);

CREATE TABLE VOTO (--
    Codigo INT UNSIGNED 					PRIMARY KEY,
    Codigo_Tipo_Voto TINYINT UNSIGNED		,
    Codigo_Hoja_Votacion MEDIUMINT UNSIGNED	,
    Codigo_Circuito MEDIUMINT UNSIGNED 		NOT NULL,
    FOREIGN KEY (Codigo_Tipo_Voto) REFERENCES TIPO_VOTO(Codigo),
    FOREIGN KEY (Codigo_Hoja_Votacion) REFERENCES HOJA_VOTACION(Codigo),
    FOREIGN KEY (Codigo_Circuito) REFERENCES CIRCUITO(Codigo)
);

CREATE TABLE CONSTANCIA_VOTO (--
    Codigo INT UNSIGNED 						PRIMARY KEY,
    Numero_Sobre MEDIUMINT UNSIGNED 			NOT NULL,
    Numero_Votante SMALLINT UNSIGNED 			NOT NULL,
    Hora_Votacion TIME 							NOT NULL,
    Cedula_Identidad_Votante INT UNSIGNED		,
    CHECK (Cedula_Identidad_Votante < 99999999 AND Cedula_Identidad_Votante > 1000000),
    
    Codigo_Tipo_Observacion TINYINT UNSIGNED	,
    Comentarios_Observacion TEXT(200)			,
    Codigo_Circuito MEDIUMINT UNSIGNED 			NOT NULL,
    FOREIGN KEY (Cedula_Identidad_Votante) REFERENCES ELECTOR(Cedula_Identidad),
    FOREIGN KEY (Codigo_Tipo_Observacion) REFERENCES TIPO_OBSERVACION(Codigo),
    FOREIGN KEY (Codigo_Circuito) REFERENCES CIRCUITO(Codigo)
);

CREATE TABLE SUPERVISION (--
    Cedula_Identidad_Receptor INT UNSIGNED		,
    CHECK (Cedula_Identidad_Receptor < 99999999 AND Cedula_Identidad_Receptor > 1000000),
    
    Codigo_Rol_Comision TINYINT UNSIGNED		NOT NULL,
    Codigo_Circuito MEDIUMINT UNSIGNED			NOT NULL,
    PRIMARY KEY (Cedula_Identidad_Receptor, Codigo_Circuito),
    FOREIGN KEY (Cedula_Identidad_Receptor) REFERENCES RECEPTOR(Cedula_Identidad),
    FOREIGN KEY (Codigo_Rol_Comision) REFERENCES ROL_COMISION_RECEPTORA(Codigo),
    FOREIGN KEY (Codigo_Circuito) REFERENCES CIRCUITO(Codigo)
);

CREATE TABLE CUSTODIA (--
    Cedula_Identidad_Policia INT UNSIGNED		,
    CHECK (Cedula_Identidad_Policia < 99999999 AND Cedula_Identidad_Policia > 1000000),
    
    Codigo_Circuito MEDIUMINT UNSIGNED,
    PRIMARY KEY (Cedula_Identidad_Policia, Codigo_Circuito),
    FOREIGN KEY (Cedula_Identidad_Policia) REFERENCES POLICIA(Cedula_Identidad),
    FOREIGN KEY (Codigo_Circuito) REFERENCES CIRCUITO(Codigo)
);
