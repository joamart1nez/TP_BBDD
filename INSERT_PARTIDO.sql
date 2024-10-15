--- PARTIDO ---

BEGIN TRAN

INSERT INTO Partido
SELECT DISTINCT
	partido_id AS Id, 
	temporada_id AS Id_Temporada, 
	CASE 
		WHEN resultado LIKE '%Won%' THEN equipo_id
		ELSE equipoOP_id
	END as Id_Equipo_Ganador,
	fecha as Fecha
FROM datos

SELECT * FROM Partido

--COMMIT
--ROLLBACK