---- DIVISION ----
BEGIN TRAN
INSERT INTO Division 
SELECT 
	ROW_NUMBER() OVER (ORDER BY c.Id) AS Id, 
	c.Id AS Id_Conferencia, 
	REPLACE(predivision.Nombre, '	', '') 
FROM(
	SELECT DISTINCT 
		equipo_division AS Nombre,
		equipo_conferencia AS NomConferencia 
	FROM datos
UNION
SELECT DISTINCT 
		equipoOP_division AS Nombre ,
		equipoOP_conferencia AS NomConferencia 
	FROM datos) AS  predivision

INNER JOIN Conferencia AS c ON (c.Nombre=REPLACE(NomConferencia, '	', ''))
 
 SELECT * FROM Division
 --COMMIT
 --ROLLBACK
