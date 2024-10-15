--- EQUIPO ---

BEGIN TRAN
INSERT INTO Equipo
SELECT DISTINCT
	e.Id AS Id, 
	c.Id AS Id_Ciudad, 
	d.Id AS Id_Division, 
	REPLACE(REPLACE(e.Nombre, '	', ''),'               ','') AS Nombre, 
	TRIM(REPLACE(e.CodAlfa, '	', '')) AS CodAlfa, 
	TRIM(REPLACE(e.Sigla, '	', '')) AS Siglas
FROM (
	SELECT DISTINCT 
		equipoOP_id AS Id,
		equipoOP_nombre AS Nombre,
		equipoOP_sigla AS Sigla, 
		equipoOP_codigo AS CodAlfa, 
		equipoOP_idCiudad AS IdCiudad, 
		equipoOP_division AS Division
	FROM datos
	
	UNION

	SELECT DISTINCT 
		equipo_id AS Id,
		equipo_nombre AS Nombre,
		equipo_sigla AS Sigla,
		equipo_codigo AS CodAlfa,
		equipo_idCiudad AS IdCiudad, 
		equipo_division AS Division
	FROM datos
) AS e
INNER JOIN Ciudad c ON (c.Id = e.IdCiudad)
INNER JOIN Division d ON (d.Nombre = TRIM(REPLACE(e.Division, '	', '')))
SELECT * FROM Equipo;

--COMMIT
--ROLLBACK