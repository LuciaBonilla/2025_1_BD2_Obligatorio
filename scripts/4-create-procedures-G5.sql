USE AM_Grupo5;

SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- --------------------------------------------------------------------------------------------------------------------------
-- DE LOGIN Y TOKENS (LISTO)
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE obtener_hashed_password_de_receptor ( -- check
    IN in_cedula_receptor INT UNSIGNED
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al retornar contraseña hash';
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
CREATE PROCEDURE registrar_token_acceso ( -- check
    IN in_jti VARCHAR(100),
    IN in_cedula_receptor INT UNSIGNED,
    IN in_creado_en DATETIME,
    IN in_expira_en DATETIME
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al registrar token de acceso';
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
CREATE PROCEDURE revocar_token_acceso ( -- check
    IN in_jti VARCHAR(100)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al revocar token de acceso';
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
CREATE PROCEDURE obtener_token_acceso_por_jti ( -- check
    IN in_jti VARCHAR(100)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al retornar token de acceso';
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
CREATE PROCEDURE registrar_token_refresco ( -- check
    IN in_jti VARCHAR(100),
    IN in_cedula_receptor INT UNSIGNED,
    IN in_creado_en DATETIME,
    IN in_expira_en DATETIME
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al registrar token de refresco';
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
CREATE PROCEDURE revocar_token_refresco ( -- check
    IN in_jti VARCHAR(100)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al revocar token de refresco';
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
CREATE PROCEDURE obtener_token_refresco_por_jti ( -- check
    IN in_jti VARCHAR(100)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al retornar token de refresco';
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
CREATE PROCEDURE registrar_token_voto ( -- check
    IN in_jti VARCHAR(100),
    IN in_cedula_receptor INT UNSIGNED,
    IN in_creado_en DATETIME,
    IN in_expira_en DATETIME
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al registrar token de voto';
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
CREATE PROCEDURE revocar_token_voto ( -- check
    IN in_jti VARCHAR(100)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al revocar token de voto';
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
CREATE PROCEDURE obtener_token_voto_por_jti ( -- check
    IN in_jti VARCHAR(100)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al retornar token de voto';
	END;
	SELECT
		*
	FROM TOKEN_VOTO tv
	WHERE tv.JTI = in_jti
    FOR UPDATE;
END $$
DELIMITER ;


-- --------------------------------------------------------------------------------------------------------------------------
-- PARA QUE EL RECEPTOR PUEDA TRABAJAR EN SU CIRCUITO
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE obtener_eleccion () -- check
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al retornar eleccion';
	END;
    SELECT
		*
	FROM ELECCION e
    WHERE e.Fecha_Votacion = CURDATE()
    FOR UPDATE;
END $$
DELIMITER ;
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE obtener_circuito_de_receptor ( -- check
	IN in_cedula_receptor INT UNSIGNED,
	IN in_codigo_eleccion TINYINT UNSIGNED
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al retornar circuito';
	END;
    SELECT
		c.Codigo AS Codigo_Circuito,
        c.Serie_Civica AS Serie_Civica,
		c.Numero_Desde AS Numero_Desde,
		c.Numero_Hasta AS Numero_Hasta,
		c.Esta_Cerrado AS Esta_Cerrado,
		tc.Nombre AS Tipo_Circuito,
		e.Codigo AS Codigo_Eleccion
	FROM CIRCUITO c
    INNER JOIN ELECCION e ON c.Codigo_Eleccion = e.Codigo
    INNER JOIN SUPERVISION s ON s.Cedula_Identidad_Receptor = in_cedula_receptor
    INNER JOIN TIPO_DE_CIRCUITO tc ON c.Codigo_Tipo_Circuito = tc.Codigo
    INNER JOIN ROL_DE_COMISION_RECEPTORA rcr ON rcr.Codigo = s.Codigo_Rol_Comision
    WHERE rcr.Nombre = "PRESIDENTE" -- presidente
    FOR UPDATE;
END $$
DELIMITER ;
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE abrir_circuito (
	IN in_codigo_circuito MEDIUMINT UNSIGNED
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al abrir el circuito';
	END;
    START TRANSACTION;
    
    -- Obtener elección.
    SELECT c.Codigo_Eleccion
    INTO @codigo_eleccion
    FROM CIRCUITO c
    WHERE c.Codigo = in_codigo_circuito
    FOR UPDATE;
    
    -- Obtener fecha y horas de votación.
    SELECT Fecha_Votacion, Hora_Inicio_Votacion, Hora_Fin_Votacion
    INTO @fecha_votacion, @hora_inicio_votacion, @hora_fin_votacion
    FROM ELECCION e
    WHERE e.Codigo = @codigo_eleccion
    FOR UPDATE;

    -- Abrir circuito.
    IF @fecha_votacion = CURDATE() AND @hora_fin_votacion > CURTIME() AND @hora_inicio_votacion <= CURTIME() THEN
		UPDATE CIRCUITO c
		SET c.Esta_Cerrado = FALSE
		WHERE c.Codigo = in_codigo_circuito;
	ELSE
		ROLLBACK;
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'No se puede abrir el circuito fuera de la hora oficial.';
	END IF;
    COMMIT;
END $$
DELIMITER ;
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE cerrar_circuito (
	IN in_codigo_circuito MEDIUMINT UNSIGNED
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al cerrar el circuito';
	END;
    START TRANSACTION;
    
    -- Obtener elección.
    SELECT c.Codigo_Eleccion
    INTO @codigo_eleccion
    FROM CIRCUITO c
    WHERE c.Codigo = in_codigo_circuito
    FOR UPDATE;
    
    -- Obtener fecha y horas de votación.
    SELECT Fecha_Votacion, Hora_Fin_Votacion
    INTO @fecha_votacion, @hora_fin_votacion
    FROM ELECCION e
    WHERE e.Codigo = @codigo_eleccion
    FOR UPDATE;

    -- Cerrar circuito.
    IF @fecha_votacion = CURDATE() AND @hora_fin_votacion <= CURTIME() THEN
		UPDATE CIRCUITO c
		SET c.Esta_Cerrado = TRUE
		WHERE c.Codigo = in_codigo_circuito;
	ELSE
		ROLLBACK;
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'No se puede cerrar el circuito antes de la hora de cierre oficial.';
	END IF;
    COMMIT;
END $$
DELIMITER ;
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE registrar_constancia_de_voto (
	IN in_codigo_circuito MEDIUMINT UNSIGNED,
    IN in_votante_cedula INT UNSIGNED,
    IN in_codigo_tipo_observacion TINYINT UNSIGNED,
    IN in_comentarios TEXT(200)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al registrar la constancia de voto';
	END;
    START TRANSACTION;
    
    -- Obtener número ordinal de votante.
    SELECT COALESCE(MAX(cv.Numero_Ordinal_Votante), 0) INTO @ultimo_numero_ordinal
	FROM CONSTANCIA_DE_VOTO cv
	WHERE cv.Codigo_Circuito = in_codigo_circuito
	FOR UPDATE;

	SET @nuevo_numero_ordinal = @ultimo_numero_ordinal + 1;
	
    -- Registrar constancia de voto.
	INSERT INTO CONSTANCIA_DE_VOTO(
	 Numero_Ordinal_Votante,
	 Hora_Votacion,
	 Cedula_Identidad_Votante,
	 Codigo_Tipo_Observacion,
	 Comentarios_Observacion,
	 Codigo_Circuito)
	VALUES
		(@nuevo_numero_ordinal,
		CURTIME(),
		in_votante_cedula,
		in_codigo_tipo_observacion,
		in_comentarios,
		in_codigo_circuito);
    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE obtener_tipos_de_observacion () -- check
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al retornar los tipos de observación';
	END;
    SELECT *
	FROM TIPO_DE_OBSERVACION tdo
    FOR UPDATE;
END $$
DELIMITER ;
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE obtener_elector_por_cedula ( -- check
    IN in_cedula_elector INT UNSIGNED
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al retornar elector';
	END;

	SELECT 
		p.Cedula_Identidad AS Cedula_Identidad,
        p.Nombre AS Nombre,
        p.Apellido AS Apellido,
        p.Fecha_Nacimiento AS Fecha_Nacimiento,
        p.Serie_Credencial_Civica AS Serie_Credencial_Civica,
        p.Numero_Credencial_Civica AS Numero_Credencial_Civica
	FROM PERSONA p
	INNER JOIN ELECTOR e ON e.Cedula_Identidad = p.Cedula_Identidad
	WHERE p.Cedula_Identidad = in_cedula_elector
    FOR UPDATE;
END $$
DELIMITER ;
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE obtener_elector_por_credencial ( -- check
    IN in_serie_cc CHAR(3),
    IN in_numero_cc MEDIUMINT UNSIGNED
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al retornar elector';
	END;

	SELECT 
		p.Cedula_Identidad AS Cedula_Identidad,
        p.Nombre AS Nombre,
        p.Apellido AS Apellido,
        p.Fecha_Nacimiento AS Fecha_Nacimiento,
        p.Serie_Credencial_Civica AS Serie_Credencial_Civica,
        p.Numero_Credencial_Civica AS Numero_Credencial_Civica
	FROM PERSONA p
	INNER JOIN ELECTOR e ON e.Cedula_Identidad = p.Cedula_Identidad
	WHERE p.Serie_Credencial_Civica = in_serie_cc AND p.Numero_Credencial_Civica = in_numero_cc
    FOR UPDATE;
END $$
DELIMITER ;
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE verificar_elector_no_voto (
    IN in_elector_cedula INT UNSIGNED,
    IN in_codigo_circuito MEDIUMINT UNSIGNED
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error al retornar verificación';
    END;

    -- Obtener la elección del circuito
    SELECT c.Codigo_Eleccion
    INTO @codigo_eleccion
    FROM CIRCUITO c
    WHERE c.Codigo = in_codigo_circuito
    FOR UPDATE;

    -- Verificar si el elector NO votó en ningún circuito de esa elección
    IF NOT EXISTS (
        SELECT 1
        FROM CONSTANCIA_DE_VOTO cv
        INNER JOIN CIRCUITO c ON c.Codigo = cv.Codigo_Circuito
        WHERE c.Codigo_Eleccion = @codigo_eleccion
          AND cv.Cedula_Identidad_Votante = in_elector_cedula
        FOR UPDATE
    ) THEN
        SELECT 1 AS No_Voto; -- TRUE: no votó
    ELSE
        SELECT 0 AS No_Voto; -- FALSE: sí votó
    END IF;
END $$
DELIMITER ;
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE obtener_hojas_de_votacion ( -- check
	IN in_codigo_circuito MEDIUMINT UNSIGNED
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al retornar hojas de votación';
	END;
    
    SELECT d.Nombre INTO @nombre_departamento
	FROM CIRCUITO c
	INNER JOIN ESTABLECIMIENTO e ON c.Codigo_Establecimiento = e.Codigo
	INNER JOIN LOCALIDAD l ON e.Codigo_Localidad = l.Codigo
	INNER JOIN DEPARTAMENTO d ON l.Codigo_Departamento = d.Codigo
	WHERE c.Codigo = in_codigo_circuito
    FOR UPDATE;

	SELECT 
		hv.Numero AS Numero,                          -- Datos de la hoja de votación
		d.Nombre AS Departamento,
		pp.Lema AS Partido,
		p.Nombre AS Nombre_Candidato,
		p.Apellido AS Apellido_Candidato,
		cp.Nombre AS Cargo
	FROM HOJA_DE_VOTACION hv
	INNER JOIN DEPARTAMENTO d ON hv.Codigo_Departamento = d.Codigo
	INNER JOIN FORMULA_PRESIDENCIAL fp ON hv.Codigo_Formula_Presidencial = fp.Codigo
	INNER JOIN PARTIDO_POLITICO pp ON fp.Codigo_Partido = pp.Codigo
	INNER JOIN CANDIDATURA cra ON cra.Codigo_Formula_Presidencial = fp.Codigo
	INNER JOIN CANDIDATO cto ON cto.Cedula_Identidad = cra.Cedula_Identidad_Candidato
	INNER JOIN PERSONA p ON p.Cedula_Identidad = cto.Cedula_Identidad
	INNER JOIN CARGO_POLITICO cp ON cp.Codigo = cra.Codigo_Cargo_Politico
	FOR UPDATE;

END $$
DELIMITER ;
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE votar (
	IN in_codigo_tipo_voto TINYINT UNSIGNED,
    IN in_codigo_hoja_votacion TINYINT UNSIGNED,
	IN in_codigo_circuito MEDIUMINT UNSIGNED
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al registrar constancia de voto';
	END;
    START TRANSACTION;
    -- Registrar voto.
	INSERT INTO VOTO(
	 Codigo_Tipo_Voto,
	 Codigo_Hoja_Votacion,
	 Codigo_Circuito)
	VALUES
		(in_codigo_tipo_voto,
        in_codigo_hoja_votacion,
        in_codigo_circuito);
    COMMIT;
END $$
DELIMITER ;

-- --------------------------------------------------------------------------------------------------------------------------
-- RESULTADOS DE LA ELECCION
-- --------------------------------------------------------------------------------------------------------------------------
/*
DELIMITER $$
CREATE PROCEDURE obtener_cantidad_votos_observados ( -- check
	IN in_codigo_eleccion TINYINT UNSIGNED
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al retornar votos';
	END;
	
    SELECT
    e.Codigo AS Codigo_Eleccion,
    COUNT(cv.Codigo) AS Total_Votos,
    SUM(CASE WHEN cv.Codigo_Tipo_Observacion IS NOT NULL THEN 1 ELSE 0 END) AS Votos_Observados,
    ROUND(
        100.0 * SUM(CASE WHEN cv.Codigo_Tipo_Observacion IS NOT NULL THEN 1 ELSE 0 END) / COUNT(cv.Codigo),
        2
    ) AS Porcentaje_Observado
	FROM CONSTANCIA_DE_VOTO cv
	JOIN CIRCUITO c ON cv.Codigo_Circuito = c.Codigo
	JOIN ELECCION e ON c.Codigo_Eleccion = e.Codigo
	WHERE e.Codigo = in_codigo_eleccion
	GROUP BY e.Codigo
    FOR UPDATE;

END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE obtener_cantidad_votos_blancos ( -- check
	IN in_codigo_eleccion TINYINT UNSIGNED
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al retornar votos';
	END;
	
    SELECT
    e.Codigo AS Codigo_Eleccion,
    COUNT(cv.Codigo) AS Total_Votos,
    SUM(CASE WHEN cv.Codigo_Tipo_Observacion IS NOT NULL THEN 1 ELSE 0 END) AS Votos_Observados,
    ROUND(
        100.0 * SUM(CASE WHEN cv.Codigo_Tipo_Observacion IS NOT NULL THEN 1 ELSE 0 END) / COUNT(cv.Codigo),
        2
    ) AS Porcentaje_Observado
	FROM CONSTANCIA_DE_VOTO cv
	JOIN CIRCUITO c ON cv.Codigo_Circuito = c.Codigo
	JOIN ELECCION e ON c.Codigo_Eleccion = e.Codigo
	WHERE e.Codigo = in_codigo_eleccion
	GROUP BY e.Codigo
    FOR UPDATE;

END $$
DELIMITER ;

Cantidad y porcentaje de votos anulados.: count a la tabla de votos, recibe codigo eleccion, tipo blanco
SELECT
    e.Codigo AS Codigo_Eleccion,
    COUNT(v.Codigo) AS Total_Votos,
    SUM(CASE WHEN tv.Nombre = 'ANULADO' THEN 1 ELSE 0 END) AS Votos_Anulados,
    ROUND(
        100.0 * SUM(CASE WHEN tv.Nombre = 'ANULADO' THEN 1 ELSE 0 END) / COUNT(v.Codigo),
        2
    ) AS Porcentaje_Anulados
FROM VOTO v
JOIN CIRCUITO c ON v.Codigo_Circuito = c.Codigo
JOIN ELECCION e ON c.Codigo_Eleccion = e.Codigo
LEFT JOIN TIPO_DE_VOTO tv ON v.Codigo_Tipo_Voto = tv.Codigo
WHERE e.Codigo = ? -- Reemplazar con el código de elección
GROUP BY e.Codigo;


Cantidad y porcentaje de votos a cada partido, lo cual se traduce a cantidad de votos a cada fórmula presidencial: recibe codigo eleccion, group by y count a la tabla de votos
SELECT
    pp.Lema AS Partido,
    COUNT(v.Codigo) AS Cantidad_Votos,
    ROUND(
        100.0 * COUNT(v.Codigo) / (
            SELECT COUNT(*) 
            FROM VOTO v2
            JOIN CIRCUITO c2 ON v2.Codigo_Circuito = c2.Codigo
            WHERE c2.Codigo_Eleccion = ?
        ),
        2
    ) AS Porcentaje
FROM VOTO v
JOIN HOJA_DE_VOTACION hv ON v.Codigo_Hoja_Votacion = hv.Codigo
JOIN FORMULA_PRESIDENCIAL fp ON hv.Codigo_Formula_Presidencial = fp.Codigo
JOIN PARTIDO_POLITICO pp ON fp.Codigo_Partido = pp.Codigo
JOIN CIRCUITO c ON v.Codigo_Circuito = c.Codigo
WHERE c.Codigo_Eleccion = ?
GROUP BY pp.Lema
ORDER BY Cantidad_Votos DESC;

Cantidad y porcentaje de votos a cada hoja de votación: recibe codigo eleccion, group by y count a la tabla de votos
SELECT
    hv.Numero AS Numero_Hoja,
    COUNT(v.Codigo) AS Cantidad_Votos,
    ROUND(
        100.0 * COUNT(v.Codigo) / (
            SELECT COUNT(*) 
            FROM VOTO v2
            JOIN CIRCUITO c2 ON v2.Codigo_Circuito = c2.Codigo
            WHERE c2.Codigo_Eleccion = ?
        ),
        2
    ) AS Porcentaje
FROM VOTO v
JOIN HOJA_DE_VOTACION hv ON v.Codigo_Hoja_Votacion = hv.Codigo
JOIN CIRCUITO c ON v.Codigo_Circuito = c.Codigo
WHERE c.Codigo_Eleccion = ?
GROUP BY hv.Numero
ORDER BY Cantidad_Votos DESC;
*/
