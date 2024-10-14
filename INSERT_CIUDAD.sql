--- CIUDAD ---
BEGIN TRAN

INSERT INTO Ciudad SELECT 
	Id,
	REPLACE(REPLACE(Ciudad, '               ', ''), '	','')
FROM (
	SELECT 
		equipoOP_idCiudad AS Id, 
		equipoOP_ciudad AS Ciudad 
	FROM datos

	UNION

	SELECT 
		equipo_idCiudad AS Id, 
		equipo_ciudad AS Ciudad 
	FROM datos
) AS Ciudades 
ORDER BY Id

--COMMIT
--ROLLBACK