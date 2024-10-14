---- TEMPORADA ----
BEGIN TRAN

select * from Temporada

select distinct temporada_descripcion, temporada_id from datos

INSERT INTO Temporada 
SELECT DISTINCT 
    temporada_id AS Id, 
    temporada_descripcion as Descripcion 
FROM datos;

--COMMIT
--ROLLBACK