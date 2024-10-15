---- TEMPORADA ----
BEGIN TRAN

INSERT INTO Temporada 
SELECT DISTINCT 
    temporada_id AS Id, 
    temporada_descripcion as Descripcion 
FROM datos;

select * from Temporada
--COMMIT
--ROLLBACK