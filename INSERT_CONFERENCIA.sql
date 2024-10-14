--- CONFERENCIA ---

BEGIN TRAN

INSERT INTO Conferencia SELECT
	CASE WHEN Nombre = 'Este' THEN 1 ELSE 2 END AS Id,
	Nombre
FROM (
	SELECT DISTINCT REPLACE(equipo_conferencia, '	', '') AS Nombre FROM datos
	UNION
	SELECT DISTINCT REPLACE(equipoOP_conferencia, '	', '') AS Nombre FROM datos
) AS Conferencias

--COMMIT
--ROLLBACK