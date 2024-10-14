
---- PAIS ----
BEGIN TRAN

-- Insertamos los que si tienen Id
INSERT INTO Pais SELECT DISTINCT idPais AS Id, REPLACE(REPLACE(pais,'               ', ''),'	','') AS Nombre 
FROM datos 
WHERE idPais != 0

-- Luego insertamos los que no tienen Id
DECLARE @CountPaisSinId INT = (SELECT COUNT(DISTINCT pais) FROM datos WHERE idPais=0);

WITH Faltantes AS (
    SELECT TOP (@CountPaisSinId)
       ROW_NUMBER() OVER (ORDER BY Id) AS indice,
	   fila AS nuevo_id
    FROM (
        SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS fila
        FROM datos
    ) numeros
    LEFT JOIN pais p ON numeros.fila = p.Id
    WHERE p.Id IS NULL
),

DatosDistinct AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY Id) AS indice,
        Id,
        Nombre
    FROM (
        SELECT DISTINCT
            idPais AS Id,
            REPLACE(REPLACE(pais,'               ', ''),'	','') AS Nombre
        FROM datos 
        WHERE idPais = 0
    ) AS DistinctNames
)

INSERT INTO Pais SELECT 
	f.nuevo_id AS Id,
    d.Nombre AS Nombre
FROM 
    DatosDistinct d
INNER JOIN Faltantes f ON (f.indice = d.indice);

SELECT * FROM PAIS

--COMMIT
--ROLLBACK



