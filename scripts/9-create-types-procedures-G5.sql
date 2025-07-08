USE AM_Grupo5;

SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- --------------------------------------------------------------------------------------------------------------------------
-- PROCEDIMIENTOS PARA OBTENER TIPOS FÁCILMENTE
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE obtener_tipos_de_observacion () -- check +
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = "Error al retornar tipos de observación";
	END;
    SELECT Codigo, Nombre
	FROM TIPO_DE_OBSERVACION
    FOR UPDATE;
END $$
DELIMITER ;
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE obtener_tipos_de_voto () -- check +
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = "Error al retornar tipos de voto";
	END;
    SELECT Codigo, Nombre
	FROM TIPO_DE_VOTO
    FOR UPDATE;
END $$
DELIMITER ;
