USE AM_Grupo5;

/*
TINYINT 	UNSIGNED 0-255
SMALLINT	UNSIGNED 0-65_535
MEDIUMINT	UNSIGNED 0-16_777_215
INT			UNSIGNED 0-4_294_967_295
*/

-- Tablas para categorizar
/*
	Ponemos ENUM en los atributos Nombre, pero esto se puede cambiar a VARCHAR(n)
	para que la base de datos sea extensible permitiendo agregar nuevos tipos sin alterar
	los viejos.
	Por ahora los tipos ya están definidos.
*/
CREATE TABLE TIPO_DE_LOCALIDAD (-- +++
    Codigo TINYINT UNSIGNED 			 		AUTO_INCREMENT,
    Nombre ENUM("PARAJE", "PUEBLO", "CIUDAD") 	NOT NULL UNIQUE,
    
    CONSTRAINT chk_mayus_tipo_localidad			CHECK(Nombre = UPPER(Nombre)), -- para forzar mayúsculas en el futuro.
    
    PRIMARY KEY (Codigo)
) AUTO_INCREMENT = 0;

CREATE TABLE TIPO_DE_CIRCUITO (-- +++
    Codigo TINYINT UNSIGNED 			 		AUTO_INCREMENT,
    Nombre ENUM("RURAL", "URBANO") 				NOT NULL UNIQUE,
    
    CONSTRAINT chk_mayus_tipo_circuito			CHECK(Nombre = UPPER(Nombre)),
    
    PRIMARY KEY (Codigo)
) AUTO_INCREMENT = 0;

CREATE TABLE TIPO_DE_VOTO (-- +++
    Codigo TINYINT UNSIGNED 			 		AUTO_INCREMENT,
    Nombre ENUM("ANULADO", "EN BLANCO") 		NOT NULL UNIQUE,
    
    CONSTRAINT chk_mayus_tipo_voto				CHECK(Nombre = UPPER(Nombre)),
    
    PRIMARY KEY (Codigo)
) AUTO_INCREMENT = 0;

CREATE TABLE TIPO_DE_OBSERVACION (-- +++
    Codigo TINYINT UNSIGNED 			 		AUTO_INCREMENT,
    Nombre ENUM("SIMPLE", "POR IDENTIDAD") 		NOT NULL UNIQUE,
    
	CONSTRAINT chk_mayus_tipo_observacion		CHECK(Nombre = UPPER(Nombre)),
    
    PRIMARY KEY (Codigo)
) AUTO_INCREMENT = 0;

CREATE TABLE ROL_DE_COMISION_RECEPTORA (-- +++
    Codigo TINYINT UNSIGNED 			 		AUTO_INCREMENT,
    Nombre ENUM("PRESIDENTE", "SECRETARIO",
				"VOCAL", "SUPLENTE") 			NOT NULL UNIQUE,
                
    CONSTRAINT chk_mayus_rol_comision			CHECK(Nombre = UPPER(Nombre)),
    
    PRIMARY KEY (Codigo)
) AUTO_INCREMENT = 0;

CREATE TABLE CARGO_POLITICO (-- +++
    Codigo TINYINT UNSIGNED 			 		AUTO_INCREMENT,
    Nombre ENUM("PRESIDENTE", "VICEPRESIDENTE") NOT NULL UNIQUE,
    
    CONSTRAINT chk_mayus_cargo_politico 		CHECK(Nombre = UPPER(Nombre)),
    
    PRIMARY KEY (Codigo)
) AUTO_INCREMENT = 0;

-- Tablas acerca de Zonas
CREATE TABLE DEPARTAMENTO (-- +++
    Codigo TINYINT UNSIGNED 					AUTO_INCREMENT,
    Nombre VARCHAR(30) 							NOT NULL UNIQUE,
    
    CONSTRAINT chk_mayus_departamento			CHECK(Nombre = UPPER(Nombre)),
    
    PRIMARY KEY (Codigo)
) AUTO_INCREMENT = 0;

CREATE TABLE LOCALIDAD (-- +++
    Codigo SMALLINT UNSIGNED 					AUTO_INCREMENT,
    Nombre VARCHAR(30) 							NOT NULL,
    Codigo_Departamento TINYINT UNSIGNED		,
    Codigo_Tipo_Localidad TINYINT UNSIGNED 		NOT NULL,
    
    CONSTRAINT chk_mayus_localidad				CHECK(Nombre = UPPER(Nombre)),
    
    PRIMARY KEY (Codigo),
    FOREIGN KEY (Codigo_Departamento) 	REFERENCES DEPARTAMENTO(Codigo),
    FOREIGN KEY (Codigo_Tipo_Localidad) REFERENCES TIPO_DE_LOCALIDAD(Codigo)
) AUTO_INCREMENT = 0;

CREATE TABLE ESTABLECIMIENTO (-- +++
    Codigo SMALLINT UNSIGNED 					AUTO_INCREMENT,
    Nombre VARCHAR(60) 							NOT NULL,
    Calle VARCHAR(60)							,
    Codigo_Postal MEDIUMINT UNSIGNED 			NOT NULL,
    Nombre_Barrio VARCHAR(60)					,
    Es_Accesible BOOLEAN						NOT NULL,
    Codigo_Localidad SMALLINT UNSIGNED,
    
    CONSTRAINT chk_mayus_establecimiento		CHECK(Nombre = UPPER(Nombre)
													AND Calle = UPPER(Calle)
                                                    AND Nombre_Barrio = UPPER(Nombre_Barrio)),
    
    PRIMARY KEY (Codigo),
    FOREIGN KEY (Codigo_Localidad) REFERENCES LOCALIDAD(Codigo)
) AUTO_INCREMENT = 0;

CREATE TABLE LUGAR_DE_TRABAJO (-- ++
    Codigo MEDIUMINT UNSIGNED 					AUTO_INCREMENT,
    Nombre VARCHAR(60) 							NOT NULL UNIQUE,
	CONSTRAINT chk_mayus_lugar_trabajo			CHECK(Nombre = UPPER(Nombre)),
    
    PRIMARY KEY (Codigo)
) AUTO_INCREMENT = 0;

-- Tablas acerca de Personas
CREATE TABLE PERSONA (-- +++
    Cedula_Identidad INT UNSIGNED 				NOT NULL,
    Nombre VARCHAR(30) 							NOT NULL,
    Apellido VARCHAR(30) 						NOT NULL,
    Fecha_Nacimiento DATE 						NOT NULL,
    Serie_Credencial_Civica CHAR(3) 			NOT NULL,
    Numero_Credencial_Civica MEDIUMINT UNSIGNED NOT NULL,
    
    CONSTRAINT validar_rango_cedula 			CHECK (Cedula_Identidad < 99999999 AND Cedula_Identidad > 100000), -- valida que la cédula entre en el rango numérico
    CONSTRAINT chk_mayus_persona				CHECK(Nombre = UPPER(Nombre)
													AND Apellido = UPPER(Apellido)
                                                    AND Serie_Credencial_Civica = UPPER(Serie_Credencial_Civica)),
	CONSTRAINT validar_unicidad_credencial		UNIQUE(Serie_Credencial_Civica, Numero_Credencial_Civica),

    PRIMARY KEY (Cedula_Identidad)
);

CREATE TABLE POLICIA (-- +++
    Cedula_Identidad INT UNSIGNED 				NOT NULL,
    Codigo_Comisaria SMALLINT UNSIGNED			,
    
    PRIMARY KEY (Cedula_Identidad),
    FOREIGN KEY (Cedula_Identidad) REFERENCES PERSONA(Cedula_Identidad),
    FOREIGN KEY (Codigo_Comisaria) REFERENCES ESTABLECIMIENTO(Codigo)
);

CREATE TABLE RECEPTOR (-- +++
    Cedula_Identidad INT UNSIGNED 				NOT NULL, -- usuario
    Hashed_Password VARCHAR(255) 				NOT NULL, -- contraseña
    
    PRIMARY KEY (Cedula_Identidad),
    FOREIGN KEY (Cedula_Identidad) REFERENCES PERSONA(Cedula_Identidad)
);

CREATE TABLE TRABAJO_DE_RECEPTOR (-- +++
    Cedula_Identidad_Receptor INT UNSIGNED		NOT NULL,
    Codigo_Lugar_Trabajo MEDIUMINT UNSIGNED		NOT NULL,
    
    PRIMARY KEY (Cedula_Identidad_Receptor, Codigo_Lugar_Trabajo),
    FOREIGN KEY (Cedula_Identidad_Receptor) REFERENCES RECEPTOR(Cedula_Identidad),
    FOREIGN KEY (Codigo_Lugar_Trabajo) 		REFERENCES LUGAR_DE_TRABAJO(Codigo)
);

CREATE TABLE ELECTOR (-- +++
    Cedula_Identidad INT UNSIGNED 				NOT NULL,
    
    PRIMARY KEY (Cedula_Identidad)				,
    FOREIGN KEY (Cedula_Identidad) REFERENCES PERSONA(Cedula_Identidad)
);

CREATE TABLE CANDIDATO (-- +++
    Cedula_Identidad INT UNSIGNED 				NOT NULL,
    
    PRIMARY KEY (Cedula_Identidad)				,
    FOREIGN KEY (Cedula_Identidad) REFERENCES PERSONA(Cedula_Identidad)
);

-- Tablas acerca de Elecciones
CREATE TABLE ELECCION (-- +++
    Codigo TINYINT UNSIGNED					AUTO_INCREMENT,
    Fecha_Votacion DATE 					NOT NULL,
    Hora_Inicio_Votacion TIME 				NOT NULL,
    Hora_Fin_Votacion TIME 					NOT NULL,
    
    PRIMARY KEY (Codigo)
) AUTO_INCREMENT = 0;

CREATE TABLE CIRCUITO (-- +++
    Codigo MEDIUMINT UNSIGNED 				AUTO_INCREMENT,
    Numero SMALLINT UNSIGNED 				NOT NULL,
    Serie_Civica CHAR(3) 					NOT NULL,
    Numero_Desde MEDIUMINT UNSIGNED 		NOT NULL,
    Numero_Hasta MEDIUMINT UNSIGNED			NOT NULL,
    Esta_Cerrado BOOLEAN					DEFAULT TRUE NOT NULL,
    Codigo_Tipo_Circuito TINYINT UNSIGNED 	NOT NULL,
    Codigo_Establecimiento SMALLINT UNSIGNED,
    Codigo_Eleccion TINYINT UNSIGNED 		NOT NULL,
    
    -- Se dejan esta restricciones que se dijo en el informe que se iban a ignorar.
    CONSTRAINT validar_rango_circuito 		CHECK(Numero_Hasta > Numero_Desde),
    CONSTRAINT chk_mayus_circuito_serie		CHECK(Serie_Civica = UPPER(Serie_Civica)),
    CONSTRAINT validar_unicidad_circuito	UNIQUE(Numero, Serie_Civica, Numero_Desde, Codigo_Eleccion), -- valida combinación única por elección
    
    PRIMARY KEY (Codigo),
    FOREIGN KEY (Codigo_Tipo_Circuito) 		REFERENCES TIPO_DE_CIRCUITO(Codigo),
    FOREIGN KEY (Codigo_Establecimiento) 	REFERENCES ESTABLECIMIENTO(Codigo),
    FOREIGN KEY (Codigo_Eleccion) 			REFERENCES ELECCION(Codigo)
) AUTO_INCREMENT = 0;

CREATE TABLE PARTIDO_POLITICO (-- +++
    Codigo TINYINT UNSIGNED 				AUTO_INCREMENT,
    Lema VARCHAR(60) 						NOT NULL UNIQUE,
    Codigo_Sede SMALLINT UNSIGNED			,
    
    CONSTRAINT chk_mayus_partido			CHECK(Lema = UPPER(Lema)),
    
    PRIMARY KEY (Codigo),
    FOREIGN KEY (Codigo_Sede) REFERENCES ESTABLECIMIENTO(Codigo)
) AUTO_INCREMENT = 0;

CREATE TABLE FORMULA_PRESIDENCIAL (-- +++
    Codigo SMALLINT UNSIGNED 				AUTO_INCREMENT,
    Codigo_Partido TINYINT UNSIGNED 		NOT NULL,
    
    PRIMARY KEY (Codigo),
    FOREIGN KEY (Codigo_Partido) REFERENCES PARTIDO_POLITICO(Codigo)
) AUTO_INCREMENT = 0;

CREATE TABLE HOJA_DE_VOTACION (-- +++
    Codigo MEDIUMINT UNSIGNED 				AUTO_INCREMENT,
    Numero INT UNSIGNED						NOT NULL,
    Codigo_Eleccion TINYINT UNSIGNED		NOT NULL,
    Codigo_Departamento TINYINT UNSIGNED	NOT NULL,
    Codigo_Formula_Presidencial SMALLINT UNSIGNED,
    
    -- Se deja esta restricción que se dijo en el informe que se iba a ignorar.
    CONSTRAINT validar_unicidad_hoja_votacion UNIQUE(Numero, Codigo_Eleccion, Codigo_Departamento), -- valida combinación única por elección
    
    PRIMARY KEY (Codigo),
    FOREIGN KEY (Codigo_Eleccion) REFERENCES ELECCION(Codigo),
    FOREIGN KEY (Codigo_Departamento) REFERENCES DEPARTAMENTO(Codigo),
    FOREIGN KEY (Codigo_Formula_Presidencial) REFERENCES FORMULA_PRESIDENCIAL(Codigo)
) AUTO_INCREMENT = 0;

CREATE TABLE CANDIDATURA (-- +++
    Cedula_Identidad_Candidato INT UNSIGNED			NOT NULL,
    Codigo_Cargo_Politico TINYINT UNSIGNED			NOT NULL,
    Codigo_Formula_Presidencial SMALLINT UNSIGNED	NOT NULL,
    
    PRIMARY KEY (Cedula_Identidad_Candidato, Codigo_Formula_Presidencial),
    FOREIGN KEY (Cedula_Identidad_Candidato) REFERENCES CANDIDATO(Cedula_Identidad),
    FOREIGN KEY (Codigo_Cargo_Politico) REFERENCES CARGO_POLITICO(Codigo),
    FOREIGN KEY (Codigo_Formula_Presidencial) REFERENCES FORMULA_PRESIDENCIAL(Codigo)
) AUTO_INCREMENT = 0;

CREATE TABLE VOTO (-- +++
    Codigo INT UNSIGNED 					AUTO_INCREMENT,
    Codigo_Tipo_Voto TINYINT UNSIGNED		,
    Codigo_Hoja_Votacion MEDIUMINT UNSIGNED	,
    Codigo_Circuito MEDIUMINT UNSIGNED 		NOT NULL,
    
    PRIMARY KEY (Codigo),
    FOREIGN KEY (Codigo_Tipo_Voto) REFERENCES TIPO_DE_VOTO(Codigo),
    FOREIGN KEY (Codigo_Hoja_Votacion) REFERENCES HOJA_DE_VOTACION(Codigo),
    FOREIGN KEY (Codigo_Circuito) REFERENCES CIRCUITO(Codigo)
) AUTO_INCREMENT = 0;

CREATE TABLE CONSTANCIA_DE_VOTO (-- +++
    Codigo INT UNSIGNED 						AUTO_INCREMENT,
    Numero_Ordinal_Votante SMALLINT UNSIGNED 	NOT NULL,
    Hora_Votacion TIME 							NOT NULL,
    Cedula_Identidad_Votante INT UNSIGNED		NOT NULL,
    Codigo_Tipo_Observacion TINYINT UNSIGNED	,
    Comentarios_Observacion TEXT(200)			,
    Codigo_Circuito MEDIUMINT UNSIGNED 			NOT NULL,

    CONSTRAINT validar_unicidad_constancia_voto	UNIQUE(Codigo_Circuito, Cedula_Identidad_Votante), -- se evita que una persona vote 2 veces en el mismo circuito.
    
    PRIMARY KEY (Codigo),
    FOREIGN KEY (Cedula_Identidad_Votante) REFERENCES ELECTOR(Cedula_Identidad),
    FOREIGN KEY (Codigo_Tipo_Observacion) REFERENCES TIPO_DE_OBSERVACION(Codigo),
    FOREIGN KEY (Codigo_Circuito) REFERENCES CIRCUITO(Codigo)
) AUTO_INCREMENT = 0;

CREATE TABLE SUPERVISION (-- +++
    Cedula_Identidad_Receptor INT UNSIGNED		NOT NULL,
    Codigo_Rol_Comision TINYINT UNSIGNED		NOT NULL,
    Codigo_Circuito MEDIUMINT UNSIGNED			NOT NULL,
    
    PRIMARY KEY (Cedula_Identidad_Receptor, Codigo_Circuito),
    FOREIGN KEY (Cedula_Identidad_Receptor) REFERENCES RECEPTOR(Cedula_Identidad),
    FOREIGN KEY (Codigo_Rol_Comision) REFERENCES ROL_DE_COMISION_RECEPTORA(Codigo),
    FOREIGN KEY (Codigo_Circuito) REFERENCES CIRCUITO(Codigo)
);

CREATE TABLE CUSTODIA (-- +++
    Cedula_Identidad_Policia INT UNSIGNED		NOT NULL,
    Codigo_Circuito MEDIUMINT UNSIGNED			NOT NULL,

    PRIMARY KEY (Cedula_Identidad_Policia, Codigo_Circuito),
    FOREIGN KEY (Cedula_Identidad_Policia) REFERENCES POLICIA(Cedula_Identidad),
    FOREIGN KEY (Codigo_Circuito) REFERENCES CIRCUITO(Codigo)
);
