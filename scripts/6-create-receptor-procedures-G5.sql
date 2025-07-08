USE AM_Grupo5;

SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- --------------------------------------------------------------------------------------------------------------------------
-- PROCEDIMIENTOS PARA QUE EL RECEPTOR PUEDA TRABAJAR EN SU CIRCUITO
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE obtener_codigo_de_eleccion_hoy () -- check +
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al retornar elección';
	END;
    
    SELECT
		e.Codigo AS Codigo_Eleccion
	FROM ELECCION e
    WHERE e.Fecha_Votacion = CURDATE() -- Las elecciones se hacen en distintos días.
    FOR UPDATE;
END $$
DELIMITER ;
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE obtener_codigo_de_circuito_de_receptor ( -- check +
	IN in_cedula_receptor INT UNSIGNED,
	IN in_codigo_eleccion TINYINT UNSIGNED
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al retornar código de circuito';
	END;
    
    SELECT
		s.Codigo_Circuito AS Codigo_Circuito -- El circuito que le toca supervisar en la elección.
	FROM SUPERVISION s
    INNER JOIN CIRCUITO c ON c.Codigo = s.Codigo_Circuito
    INNER JOIN ELECCION e ON e.Codigo = c.Codigo_Eleccion
    WHERE s.Cedula_Identidad_Receptor = in_cedula_receptor AND
    e.Codigo = in_codigo_eleccion
    FOR UPDATE;
END $$
DELIMITER ;
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE obtener_circuito ( -- check +
	IN in_codigo_circuito MEDIUMINT UNSIGNED
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al retornar circuito';
	END;
    
    SELECT
		c.Codigo AS Codigo,
        c.Numero AS Numero,
        c.Serie_Civica AS Serie_Civica,
		c.Numero_Desde AS Numero_Desde,
		c.Numero_Hasta AS Numero_Hasta,
		c.Esta_Cerrado AS Esta_Cerrado,
		tc.Nombre AS Tipo,
		e.Fecha_Votacion AS Fecha_Votacion,
        e.Hora_Inicio_Votacion AS Hora_Inicio_Votacion,
        e.Hora_Fin_Votacion AS Hora_Fin_Votacion
	FROM CIRCUITO c
    INNER JOIN TIPO_DE_CIRCUITO tc ON c.Codigo_Tipo_Circuito = tc.Codigo
    INNER JOIN ELECCION e ON c.Codigo_Eleccion = e.Codigo
    WHERE c.Codigo = in_codigo_circuito
    FOR UPDATE;
END $$
DELIMITER ;
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE abrir_circuito ( -- check +
	IN in_codigo_circuito MEDIUMINT UNSIGNED
)
BEGIN
	DECLARE v_codigo_eleccion TINYINT UNSIGNED;
    DECLARE v_fecha_votacion DATE;
    DECLARE v_hora_inicio_votacion TIME;
    DECLARE v_hora_fin_votacion TIME;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al abrir circuito';
	END;
    
    START TRANSACTION;
    
    -- Obtener elección.
    SELECT c.Codigo_Eleccion
    INTO v_codigo_eleccion
    FROM CIRCUITO c
    WHERE c.Codigo = in_codigo_circuito
    FOR UPDATE;
    
    -- Obtener fecha y horas de votación.
    SELECT Fecha_Votacion, Hora_Inicio_Votacion, Hora_Fin_Votacion
    INTO v_fecha_votacion, v_hora_inicio_votacion, v_hora_fin_votacion
    FROM ELECCION e
    WHERE e.Codigo = v_codigo_eleccion
    FOR UPDATE;

    -- Abrir circuito.
    IF v_fecha_votacion = CURDATE() AND v_hora_fin_votacion > CURTIME() AND v_hora_inicio_votacion <= CURTIME() THEN
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
	DECLARE v_codigo_eleccion TINYINT UNSIGNED;
    DECLARE v_fecha_votacion DATE;
    DECLARE v_hora_inicio_votacion TIME;
    DECLARE v_hora_fin_votacion TIME;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al cerrar circuito';
	END;

    START TRANSACTION;
    
    -- Obtener elección.
    SELECT c.Codigo_Eleccion
    INTO v_codigo_eleccion
    FROM CIRCUITO c
    WHERE c.Codigo = in_codigo_circuito
    FOR UPDATE;
    
    -- Obtener fecha y horas de votación.
    SELECT Fecha_Votacion, Hora_Fin_Votacion
    INTO v_fecha_votacion, v_hora_fin_votacion
    FROM ELECCION e
    WHERE e.Codigo = v_codigo_eleccion
    FOR UPDATE;

    -- Cerrar circuito.
    IF v_fecha_votacion = CURDATE() AND v_hora_fin_votacion <= CURTIME() THEN
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
CREATE PROCEDURE registrar_constancia_de_voto ( -- check +
	IN in_codigo_circuito MEDIUMINT UNSIGNED,
    IN in_votante_cedula INT UNSIGNED,
	IN in_codigo_tipo_observacion TINYINT UNSIGNED,
	IN in_comentarios_observacion TEXT(200)
)
BEGIN
	DECLARE v_ultimo_numero_ordinal SMALLINT UNSIGNED;
    DECLARE v_nuevo_numero_ordinal SMALLINT UNSIGNED;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al registrar la constancia de voto';
	END;
    
    START TRANSACTION;
    
    -- Obtener número ordinal de votante.
    SELECT COALESCE(MAX(cv.Numero_Ordinal_Votante), 0) INTO v_ultimo_numero_ordinal
	FROM CONSTANCIA_DE_VOTO cv
	WHERE cv.Codigo_Circuito = in_codigo_circuito
	FOR UPDATE;

	SET v_nuevo_numero_ordinal = v_ultimo_numero_ordinal + 1;
	
    -- Registrar constancia de voto.
	INSERT INTO CONSTANCIA_DE_VOTO(
	 Numero_Ordinal_Votante,
	 Hora_Votacion,
	 Cedula_Identidad_Votante,
	 Codigo_Tipo_Observacion,
	 Comentarios_Observacion,
	 Codigo_Circuito)
	VALUES
		(v_nuevo_numero_ordinal,
		CURTIME(),
		in_votante_cedula,
		in_codigo_tipo_observacion,
		in_comentarios_observacion,
		in_codigo_circuito);
    COMMIT;
END $$
DELIMITER ;
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE obtener_elector_por_cedula ( -- check +
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
CREATE PROCEDURE obtener_elector_por_credencial ( -- check +
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
CREATE PROCEDURE verificar_que_elector_no_voto ( -- check +
    IN in_elector_cedula INT UNSIGNED,
    IN in_codigo_circuito MEDIUMINT UNSIGNED
)
BEGIN
	DECLARE v_codigo_eleccion TINYINT UNSIGNED;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error al retornar verificación';
    END;

    -- Obtener la elección del circuito
    SELECT c.Codigo_Eleccion
    INTO v_codigo_eleccion
    FROM CIRCUITO c
    WHERE c.Codigo = in_codigo_circuito
    FOR UPDATE;

    -- Verificar si el elector NO votó en ningún circuito de esa elección
    IF NOT EXISTS (
        SELECT 1
        FROM CONSTANCIA_DE_VOTO cv
        INNER JOIN CIRCUITO c ON c.Codigo = cv.Codigo_Circuito
        WHERE c.Codigo_Eleccion = v_codigo_eleccion
          AND cv.Cedula_Identidad_Votante = in_elector_cedula
        FOR UPDATE
    ) THEN
        SELECT 1 AS No_Voto; -- TRUE: no votó
    ELSE
        SELECT 0 AS No_Voto; -- FALSE: sí votó
    END IF;
END $$
DELIMITER ;