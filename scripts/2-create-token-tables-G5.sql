USE AM_Grupo5;

CREATE TABLE TOKEN_VOTO (
    JTI VARCHAR(100)                        NOT NULL, -- ID única del JWT
    Cedula_Identidad_Receptor INT UNSIGNED  NOT NULL,        -- quien generó el token
    Creado_En DATETIME                      DEFAULT CURRENT_TIMESTAMP NOT NULL,
    Expira_En DATETIME                      NOT NULL,
    Revocado BOOLEAN 							DEFAULT FALSE NOT NULL,

    PRIMARY KEY (JTI),
    FOREIGN KEY (Cedula_Identidad_Receptor) REFERENCES RECEPTOR(Cedula_Identidad)
);

CREATE TABLE TOKEN_ACCESO (
    JTI VARCHAR(100)                        NOT NULL,
    Cedula_Identidad_Receptor INT UNSIGNED  NOT NULL,
    Creado_En DATETIME                      DEFAULT CURRENT_TIMESTAMP NOT NULL,
    Expira_En DATETIME                      NOT NULL,
    Revocado BOOLEAN                        DEFAULT FALSE NOT NULL,

    PRIMARY KEY (JTI),
    FOREIGN KEY (Cedula_Identidad_Receptor) REFERENCES RECEPTOR(Cedula_Identidad)
);

CREATE TABLE TOKEN_REFRESCO (
    JTI VARCHAR(100)                        NOT NULL,
    Cedula_Identidad_Receptor INT UNSIGNED  NOT NULL,
    Creado_En DATETIME                      DEFAULT CURRENT_TIMESTAMP NOT NULL,
    Expira_En DATETIME                      NOT NULL,
    Revocado BOOLEAN                        DEFAULT FALSE NOT NULL,

    PRIMARY KEY (JTI),
    FOREIGN KEY (Cedula_Identidad_Receptor) REFERENCES RECEPTOR(Cedula_Identidad)
);