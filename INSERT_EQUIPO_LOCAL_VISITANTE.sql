--- PARTIDO EQUIPO LOCAL Y VISITANTE ---

BEGIN TRAN

INSERT INTO PartidoEquipoLocal
SELECT DISTINCT 
	equipo_id AS Id_Equipo, 
	partido_id AS Id_Partido,
	equipo_puntos AS Puntos
FROM datos 
WHERE REPLACE(esLocal, '	', '')  = 'True';

INSERT INTO PartidoEquipoVisitante
SELECT DISTINCT 
	equipo_id AS Id_Equipo, 
	partido_id AS Id_Partido,
	equipo_puntos AS Puntos
FROM datos 
WHERE REPLACE(esLocal, '	', '')  = 'False';


SELECT * FROM PartidoEquipoLocal
SELECT * FROM PartidoEquipoVisitante

--COMMIT
--ROLLBACK