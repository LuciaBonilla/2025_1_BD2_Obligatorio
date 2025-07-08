USE AM_Grupo5;

SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- --------------------------------------------------------------------------------------------------------------------------
-- PROCEDIMIENTOS QUE USA EL ELECTOR PARA VOTAR
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE obtener_hojas_de_votacion ( -- check +
	IN in_codigo_circuito MEDIUMINT UNSIGNED
)
BEGIN
	DECLARE v_codigo_departamento TINYINT UNSIGNED;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error al retornar hojas de votación';
	END;
    
    SELECT d.Codigo
    INTO v_codigo_departamento
	FROM CIRCUITO c
	INNER JOIN ESTABLECIMIENTO e ON c.Codigo_Establecimiento = e.Codigo
	INNER JOIN LOCALIDAD l ON e.Codigo_Localidad = l.Codigo
	INNER JOIN DEPARTAMENTO d ON l.Codigo_Departamento = d.Codigo
	WHERE c.Codigo = in_codigo_circuito;

	SELECT 
		hv.Codigo AS Codigo_Hoja,
		hv.Numero AS Numero,                          
		dep.Nombre AS Departamento,
		pp.Lema AS Partido_Politico,
		p.Nombre AS Nombre_Candidato,
		p.Apellido AS Apellido_Candidato,
		cp.Nombre AS Cargo_Politico
	FROM HOJA_DE_VOTACION hv
	INNER JOIN DEPARTAMENTO dep ON dep.Codigo = hv.Codigo_Departamento
	INNER JOIN FORMULA_PRESIDENCIAL fp ON fp.Codigo = hv.Codigo_Formula_Presidencial
	INNER JOIN PARTIDO_POLITICO pp ON pp.Codigo = fp.Codigo_Partido
	INNER JOIN CANDIDATURA cra ON cra.Codigo_Formula_Presidencial = fp.Codigo
	INNER JOIN CANDIDATO cto ON cto.Cedula_Identidad = cra.Cedula_Identidad_Candidato
	INNER JOIN PERSONA p ON p.Cedula_Identidad = cto.Cedula_Identidad
	INNER JOIN CARGO_POLITICO cp ON cp.Codigo = cra.Codigo_Cargo_Politico
    WHERE d.Codigo = v_codigo_departamento
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
		SET MESSAGE_TEXT = 'Error al registrar voto';
	END;
    
    START TRANSACTION;

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