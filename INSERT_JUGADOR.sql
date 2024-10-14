---- JUGADOR ----
BEGIN TRAN

INSERT INTO JugadoR SELECT DISTINCT
	d.jugador_id, 
	p.Id, 
	REPLACE(REPLACE(d.jugador_codigo, ' ', ''), '	', ''),
	REPLACE(REPLACE(d.nombre, ' ', ''), '	', ''),
	REPLACE(REPLACE(d.apellido, ' ', ''), '	', ''),
	CASE
		WHEN d.altura LIKE '%-%' 
			THEN CAST(
                (
                    CAST(SUBSTRING(REPLACE(d.altura, '	', ''), 1, CHARINDEX('-', REPLACE(d.altura, '	', '')) - 1) AS INT) * 12 +
                    CAST(SUBSTRING(REPLACE(d.altura, '	', ''), CHARINDEX('-', REPLACE(d.altura, '	', '')) + 1, LEN(REPLACE(d.altura, '	', ''))) AS INT)
                ) * 0.0254 
            AS DECIMAL(5,2))
		ELSE CAST(REPLACE(d.altura, '	', '') AS DECIMAL(5,2))
	END, 
	CASE
		WHEN d.peso LIKE '%kilogramos%' 
			THEN CAST(REPLACE(REPLACE(REPLACE(d.peso, ' ', ''), '	', ''), 'kilogramos', '') AS DECIMAL(5,2))
		ELSE CAST(REPLACE(REPLACE(REPLACE(d.peso, ' ', ''), '	', ''), 'libras', '') AS DECIMAL(5,2))
	END,
	d.draft_year,
	REPLACE(d.posicion, '	', '')
FROM datos AS d
INNER JOIN Pais AS p ON (p.Nombre = REPLACE(REPLACE(d.pais,'               ', ''),'	',''))

SELECT * FROM JUGADOR
--COMMIT
--ROLLBACK