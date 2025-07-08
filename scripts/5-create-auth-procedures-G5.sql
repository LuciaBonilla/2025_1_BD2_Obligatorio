USE AM_Grupo5;

SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- --------------------------------------------------------------------------------------------------------------------------
-- PROCEDIMIENTOS PARA LOGIN Y TOKENS (LISTO)
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE obtener_hashed_password ( -- check +
    IN in_cedula_receptor INT UNSIGNED
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = "Error al retornar contraseña hasheada";
	END;

	SELECT 
		r.Hashed_Password
	FROM PERSONA p
	INNER JOIN RECEPTOR r ON r.Cedula_Identidad = p.Cedula_Identidad
	WHERE p.Cedula_Identidad = in_cedula_receptor
    FOR UPDATE;
END $$
DELIMITER ;
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE registrar_token_de_acceso ( -- check +
    IN in_jti VARCHAR(100),
    IN in_cedula_receptor INT UNSIGNED,
    IN in_creado_en DATETIME,
    IN in_expira_en DATETIME
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = "Error al registrar token de acceso";
	END;
    
    START TRANSACTION;
    
	INSERT INTO TOKEN_ACCESO (
		JTI,
        Cedula_Identidad_Receptor,
        Creado_En,
        Expira_En,
        Revocado)
	VALUES (
		in_jti,
        in_cedula_receptor,
        in_creado_en,
        in_expira_en,
        False);
        
    COMMIT;
END $$
DELIMITER ;
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE revocar_token_de_acceso ( -- check +
    IN in_jti VARCHAR(100)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = "Error al revocar token de acceso";
	END;

    START TRANSACTION;
    
	UPDATE TOKEN_ACCESO 
	SET Revocado = True
	WHERE JTI = in_jti;
    
    COMMIT;
END $$
DELIMITER ;
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE obtener_token_de_acceso_por_jti ( -- check +
    IN in_jti VARCHAR(100)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = "Error al retornar token de acceso";
	END;

	SELECT
		*
	FROM TOKEN_ACCESO ta
	WHERE ta.JTI = in_jti
    FOR UPDATE;
END $$
DELIMITER ;
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE registrar_token_de_refresco ( -- check +
    IN in_jti VARCHAR(100),
    IN in_cedula_receptor INT UNSIGNED,
    IN in_creado_en DATETIME,
    IN in_expira_en DATETIME
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = "Error al registrar token de refresco";
	END;
    
    START TRANSACTION;

	INSERT INTO TOKEN_REFRESCO (
		JTI,
        Cedula_Identidad_Receptor,
        Creado_En,
        Expira_En,
        Revocado)
	VALUES (
		in_jti,
        in_cedula_receptor,
        in_creado_en,
        in_expira_en,
        False);
        
    COMMIT;
END $$
DELIMITER ;
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE revocar_token_de_refresco ( -- check +
    IN in_jti VARCHAR(100)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = "Error al revocar token de refresco";
	END;
    START TRANSACTION;

	UPDATE TOKEN_REFRESCO
	SET Revocado = True
	WHERE JTI = in_jti;
    
    COMMIT;
END $$
DELIMITER ;
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE obtener_token_de_refresco_por_jti ( -- check +
    IN in_jti VARCHAR(100)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = "Error al retornar token de refresco";
	END;
    
	SELECT
		*
	FROM TOKEN_REFRESCO tr
	WHERE tr.JTI = in_jti
    FOR UPDATE;
END $$
DELIMITER ;
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE registrar_token_de_voto ( -- check +
    IN in_jti VARCHAR(100),
    IN in_cedula_receptor INT UNSIGNED,
    IN in_creado_en DATETIME,
    IN in_expira_en DATETIME
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = "Error al registrar token de voto";
	END;
    START TRANSACTION;

	INSERT INTO TOKEN_VOTO (
		JTI,
        Cedula_Identidad_Receptor,
        Creado_En,
        Expira_En,
        Revocado)
	VALUES (
		in_jti,
        in_cedula_receptor,
        in_creado_en,
        in_expira_en,
        False);
    COMMIT;
END $$
DELIMITER ;
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE revocar_token_de_voto ( -- check +
    IN in_jti VARCHAR(100)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = "Error al revocar token de voto";
	END;
    START TRANSACTION;

	UPDATE TOKEN_VOTO
	SET Revocado = True
	WHERE JTI = in_jti;
    COMMIT;
END $$
DELIMITER ;
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE obtener_token_de_voto_por_jti ( -- check +
    IN in_jti VARCHAR(100)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = "Error al retornar token de voto";
	END;
	SELECT
		*
	FROM TOKEN_VOTO tv
	WHERE tv.JTI = in_jti
    FOR UPDATE;
END $$
DELIMITER ;
