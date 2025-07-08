USE AM_Grupo5;

SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- --------------------------------------------------------------------------------------------------------------------------
-- RESULTADOS DE LA ELECCION (no importa si los circuitos están abiertos o cerrados)
-- --------------------------------------------------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE obtener_codigo_de_eleccion_utlima () -- check +
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
    ORDER BY e.Fecha_Votacion DESC, e.Hora_Inicio_Votacion DESC
	LIMIT 1
    FOR UPDATE;
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE cantidad_total_de_personas_habilitadas () --
BEGIN
    SELECT COUNT(*) AS Cantidad
    FROM ELECTOR;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE cantidad_y_porcentaje_de_votos_emitidos (IN in_codigo_eleccion TINYINT UNSIGNED) --
BEGIN
    SELECT 
        COUNT(*) AS Cantidad,
        ROUND(COUNT(*) / (SELECT COUNT(*) FROM ELECTOR) * 100, 2) AS Porcentaje
    FROM CONSTANCIA_DE_VOTO cv
    INNER JOIN CIRCUITO c ON c.Codigo = cv.Codigo_Circuito
    WHERE c.Codigo_Eleccion = in_codigo_eleccion;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE cantidad_y_porcentaje_de_votos_validos (IN in_codigo_eleccion TINYINT UNSIGNED)
BEGIN
    SELECT 
        COUNT(*) AS Cantidad,
        ROUND(
            COUNT(*) / 
            (SELECT COUNT(*) FROM VOTO WHERE Codigo_Circuito IN (
                SELECT Codigo FROM CIRCUITO WHERE Codigo_Eleccion = in_codigo_eleccion
            )) * 100, 2
        ) AS Porcentaje
    FROM VOTO v
    INNER JOIN CIRCUITO c ON v.Codigo_Circuito = c.Codigo
    LEFT JOIN TIPO_DE_VOTO tv ON v.Codigo_Tipo_Voto = tv.Codigo
    WHERE (v.Codigo_Tipo_Voto IS NULL OR tv.Nombre = "EN BLANCO") -- a hoja o en blanco
      AND c.Codigo_Eleccion = in_codigo_eleccion;
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE cantidad_y_porcentaje_de_votos_en_blanco (IN in_codigo_eleccion TINYINT UNSIGNED)
BEGIN
    SELECT 
        COUNT(*) AS Cantidad,
        ROUND(COUNT(*) / (SELECT COUNT(*) FROM VOTO WHERE Codigo_Circuito IN (
            SELECT Codigo FROM CIRCUITO WHERE Codigo_Eleccion = in_codigo_eleccion
        )) * 100, 2) AS Porcentaje
    FROM VOTO v
    INNER JOIN CIRCUITO c ON v.Codigo_Circuito = c.Codigo
    INNER JOIN TIPO_DE_VOTO tv ON v.Codigo_Tipo_Voto = tv.Codigo
    WHERE tv.Nombre = "EN BLANCO"
      AND c.Codigo_Eleccion = in_codigo_eleccion;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE cantidad_y_porcentaje_de_votos_anulados (IN in_codigo_eleccion TINYINT UNSIGNED)
BEGIN
    SELECT 
        COUNT(*) AS Cantidad,
        ROUND(COUNT(*) / (SELECT COUNT(*) FROM VOTO WHERE Codigo_Circuito IN (
            SELECT Codigo FROM CIRCUITO WHERE Codigo_Eleccion = in_codigo_eleccion
        )) * 100, 2) AS Porcentaje
    FROM VOTO v
    INNER JOIN CIRCUITO c ON v.Codigo_Circuito = c.Codigo
    INNER JOIN TIPO_DE_VOTO tv ON v.Codigo_Tipo_Voto = tv.Codigo
    WHERE tv.Nombre = "ANULADO"
      AND c.Codigo_Eleccion = in_codigo_eleccion;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE cantidad_y_porcentaje_de_votos_a_cada_formula (IN in_codigo_eleccion TINYINT UNSIGNED)
BEGIN
    SELECT 
        f.Codigo AS Codigo_Formula,
        p.Lema AS Partido,
        COUNT(v.Codigo) AS Cantidad,
        ROUND(COUNT(v.Codigo) / (SELECT COUNT(*) FROM VOTO WHERE Codigo_Circuito IN (
            SELECT Codigo FROM CIRCUITO WHERE Codigo_Eleccion = in_codigo_eleccion
        )) * 100, 2) AS Porcentaje
    FROM FORMULA_PRESIDENCIAL f
    INNER JOIN PARTIDO_POLITICO p ON p.Codigo = f.Codigo_Partido
    INNER JOIN HOJA_DE_VOTACION h ON f.Codigo = h.Codigo_Formula_Presidencial
    INNER JOIN VOTO v ON v.Codigo_Hoja_Votacion = h.Codigo
    INNER JOIN CIRCUITO c ON v.Codigo_Circuito = c.Codigo
    WHERE c.Codigo_Eleccion = in_codigo_eleccion
    GROUP BY f.Codigo;
END $$
DELIMITER ;