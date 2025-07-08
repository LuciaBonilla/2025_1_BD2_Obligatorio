USE AM_Grupo5;

SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- --------------------------------------------------------------------------------------------------------------------------
-- PROCEDIMIENTOS QUE USA EL ELECTOR PARA VOTAR
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE obtener_hojas_de_votacion ()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = "Error al retornar hojas de votación";
	END;

	SELECT 
		hv.Codigo AS Codigo_Hoja,
		hv.Numero AS Numero,                          
		pp.Lema AS Partido_Politico
	FROM HOJA_DE_VOTACION hv
	INNER JOIN FORMULA_PRESIDENCIAL fp ON fp.Codigo = hv.Codigo_Formula_Presidencial
	INNER JOIN PARTIDO_POLITICO pp ON pp.Codigo = fp.Codigo_Partido
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
	DECLARE v_esta_cerrado BOOLEAN;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = "Error al registrar voto";
	END;

	START TRANSACTION;

    -- Validar si el circuito está abierto
    SELECT Esta_Cerrado
    INTO v_esta_cerrado
    FROM CIRCUITO
    WHERE Codigo = in_codigo_circuito
    FOR UPDATE;

    IF v_esta_cerrado = TRUE THEN
        ROLLBACK;
        SIGNAL SQLSTATE "45000"
        SET MESSAGE_TEXT = "No se puede votar: el circuito está cerrado";
    END IF;

	-- Registrar voto
	INSERT INTO VOTO (
		Codigo_Tipo_Voto,
		Codigo_Hoja_Votacion,
		Codigo_Circuito
	)
	VALUES (
		in_codigo_tipo_voto,
		in_codigo_hoja_votacion,
		in_codigo_circuito
	);

	COMMIT;
END $$
DELIMITER ;
