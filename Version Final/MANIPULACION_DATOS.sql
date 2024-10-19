--- TABLA TIPO ESTADISTICA ---

BEGIN TRAN

INSERT INTO TipoEstadistica
SELECT 
	Id,
	REPLACE(TRIM(REPLACE(Nombre,'	','')), '  ', ' ') AS Descripcion 
FROM(
	SELECT DISTINCT stat_asistencias_id AS Id,stat_asistencias_nombre AS Nombre FROM datos
	UNION
	SELECT DISTINCT stat_bloqueos_id AS Id,stat_bloqueos_nombre AS Nombre FROM datos
	UNION
	SELECT DISTINCT stat_faltas_id AS Id,stat_faltas_nombre AS Nombre FROM datos
	UNION
	SELECT DISTINCT stat_minutos_id AS Id,stat_minutos_nombre AS Nombre FROM datos
	UNION
	SELECT DISTINCT stat_perdidas_id AS Id,stat_perdidas_nombre AS Nombre FROM datos
	UNION
	SELECT DISTINCT stat_puntos_id AS Id,stat_puntos_nombre AS Nombre FROM datos
	UNION
	SELECT DISTINCT stat_rebotes_defensivos_id AS Id,stat_rebotes_defensivos_nombre AS Nombre FROM datos
	UNION
	SELECT DISTINCT stat_rebotes_ofensivos_id AS Id,stat_rebotes_ofensivos_nombre AS Nombre FROM datos
	UNION
	SELECT DISTINCT stat_robos_id AS Id,stat_robos_nombre AS Nombre FROM datos
	UNION
	SELECT DISTINCT stat_segundos_id AS Id,stat_segundos_nombre AS Nombre FROM datos
	UNION
	SELECT DISTINCT stat_tiros_convertidos_id AS Id,stat_tiros_convertidos_nombre AS Nombre FROM datos
	UNION
	SELECT DISTINCT stat_tiros_intentos_id AS Id,stat_tiros_intentos_nombre AS Nombre FROM datos
	UNION
	SELECT DISTINCT stat_tiros_libres_convertidos_id AS Id,stat_tiros_libres_convertidos_nombre AS Nombre FROM datos
	UNION
	SELECT DISTINCT stat_tiros_libres_intentos_id AS Id,stat_tiros_libres_intentos_nombre AS Nombre FROM datos
	UNION
	SELECT DISTINCT stat_tiros_triples_convertidos_id AS Id,stat_tiros_triples_convertidos_nombre AS Nombre FROM datos
	UNION
	SELECT DISTINCT stat_tiros_triples_intentos_id AS Id,stat_tiros_triples_intentos_nombre AS Nombre FROM datos
)AS TIPOS

SELECT * FROM TipoEstadistica
--COMMIT
--ROLLBACK

---- TABLA PAIS ----
BEGIN TRAN

--1) Insertamos los que si tienen Id
INSERT INTO Pais 
SELECT DISTINCT 
	idPais AS Id, TRIM(REPLACE(REPLACE(pais,'	', ''), '                ', ' ')) AS Nombre 
FROM datos 
WHERE idPais != 0

-- 2)Contamos cuantos son los que no tiene Id
DECLARE @CountPaisSinId INT = (SELECT COUNT(DISTINCT pais) FROM datos WHERE idPais=0);

--3.1) Obtenemos un listados de los Ids que faltan en la tabla Pais
WITH IdsFaltantes AS (
	-- 3.4) Limitamos el resultado para obtener solo la cantidad que queremos
	SELECT TOP (@CountPaisSinId)
		Ids.Id,
		ROW_NUMBER() OVER (ORDER BY (Ids.Id)) AS Indice -- Asignamos un indice a cada fila
	FROM ( 
		-- 3.2) Generamos una lista de Ids basada en el numero de filas de la tabla datos
		SELECT 
			ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS Id
		FROM datos
	) Ids 
	-- 3.3) Filtramos los que no están en la tabla Pais para obtener solo los faltantes
	WHERE Ids.Id NOT IN (
		SELECT p.Id 
		FROM Pais p
	)
),
-- 4) Obtenemos los paises que no tiene Id
PaisesSinId AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY Id) AS Indice, -- 4.1) Asignamos un indice a cada fila
        Id,
        Nombre
    FROM (
        SELECT DISTINCT
            idPais AS Id,
            TRIM(REPLACE(REPLACE(pais, '	', ''),'               ', '')) AS Nombre
        FROM datos 
        WHERE idPais = 0
    ) AS DistinctNames
)

-- 5) Insertamos los paises restantes con su nuevo Id generado
INSERT INTO Pais SELECT 
	f.Id AS Id,
    p.Nombre AS Nombre
FROM 
    PaisesSinId p
INNER JOIN IdsFaltantes f ON (f.Indice = p.Indice);

SELECT * FROM PAIS

--COMMIT
--ROLLBACK

---- TABLA TEMPORADA ----
BEGIN TRAN

INSERT INTO Temporada 
SELECT DISTINCT 
    temporada_id AS Id, 
    temporada_descripcion as Descripcion 
FROM datos;

SELECT * FROM Temporada

--COMMIT
--ROLLBACK

--- TABLA CONFERENCIA ---

BEGIN TRAN

INSERT INTO Conferencia 
SELECT
	CASE 
		WHEN Nombre = 'Este' THEN 1 
		ELSE 2 
	END AS Id,
	Nombre
FROM (
	SELECT DISTINCT REPLACE(equipo_conferencia, '	', '') AS Nombre FROM datos
	UNION
	SELECT DISTINCT REPLACE(equipoOP_conferencia, '	', '') AS Nombre FROM datos
) AS Conferencias

SELECT * FROM Conferencia

--COMMIT
--ROLLBACK

--- TABLA CIUDAD ---
BEGIN TRAN

INSERT INTO Ciudad 
SELECT 
	Id,
	REPLACE(REPLACE(Ciudad, '               ', ''), '	','') AS Nombre
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

SELECT * FROM Ciudad

--COMMIT
--ROLLBACK

---- TABLA JUGADOR ----
BEGIN TRAN

INSERT INTO Jugador
SELECT DISTINCT
	d.jugador_id AS Id, 
	p.Id AS Id_Pais, 
	REPLACE(REPLACE(d.jugador_codigo, ' ', ''), '	', '') AS CodAlfa,
	REPLACE(REPLACE(d.nombre, ' ', ''), '	', '') AS Nombre,
	REPLACE(REPLACE(d.apellido, ' ', ''), '	', '') AS Apellido,
	CASE
		WHEN d.altura LIKE '%-%' THEN 
			CAST((
				-- Extraemos la parte correspondiente a las pulgadas
                CAST(SUBSTRING(REPLACE(d.altura, '	', ''), CHARINDEX('-', REPLACE(d.altura, '	', '')) + 1, LEN(REPLACE(d.altura, '	', ''))) AS INT) +
                -- Extraemos la parte correspondiente a los pies y los pasamos a pulgadas
				CAST(SUBSTRING(REPLACE(d.altura, '	', ''), 1, CHARINDEX('-', REPLACE(d.altura, '	', '')) - 1) AS INT) * 12
			-- Convertimos las pulgas a metros (1" = 0.0254 metros)
			) * 0.0254 AS DECIMAL(5,2))
		ELSE CAST(REPLACE(d.altura, '	', '') AS DECIMAL(5,2))
	END AS Altura,
	CASE
		WHEN d.peso LIKE '%kilogramos%' 
			THEN CAST(REPLACE(REPLACE(REPLACE(d.peso, ' ', ''), '	', ''), 'kilogramos', '') AS DECIMAL(5,2))
		ELSE CAST(CAST(REPLACE(REPLACE(REPLACE(d.peso, ' ', ''), '	', ''), 'libras', '') AS DECIMAL(5,2)) * 0.453592 AS DECIMAL(5,2))
	END AS Peso,
	d.draft_year AS DraftYear,
	REPLACE(d.posicion, '	', '') AS Posicion
FROM datos AS d
INNER JOIN Pais AS p ON (p.Nombre = REPLACE(REPLACE(d.pais,'               ', ''),'	',''))

SELECT * FROM JUGADOR

--COMMIT
--ROLLBACK

---- TABAL DIVISION ----
BEGIN TRAN

INSERT INTO Division 
SELECT 
	ROW_NUMBER() OVER (ORDER BY c.Id) AS Id, 
	c.Id AS Id_Conferencia, 
	REPLACE(Divisiones.Nombre, '	', '') AS Nombre 
FROM(
	SELECT DISTINCT 
		equipo_division AS Nombre,
		equipo_conferencia AS NomConferencia 
	FROM datos

	UNION
	
	SELECT DISTINCT 
		equipoOP_division AS Nombre ,
		equipoOP_conferencia AS NomConferencia 
	FROM datos) AS Divisiones
INNER JOIN Conferencia AS c ON (c.Nombre=REPLACE(NomConferencia, '	', ''))
 
 SELECT * FROM Division
 --COMMIT
 --ROLLBACK

--- TABLA EQUIPO ---
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

--- TABLA PARTIDO ---
BEGIN TRAN

INSERT INTO Partido
SELECT DISTINCT
	partido_id AS Id, 
	temporada_id AS Id_Temporada, 
	fecha as Fecha
FROM datos

SELECT * FROM Partido

--COMMIT
--ROLLBACK

---- TABLA EQUIPO JUGADOR ----
BEGIN TRAN

INSERT INTO EquipoJugador
SELECT DISTINCT
	jugador_id AS Id_Jugador, 
	equipo_id As Id_Equipo, 
	caminseta AS NroDorsal 
FROM datos

SELECT * FROM EquipoJugador

--COMMIT
--ROLLBACK

--- TABLA PARTIDO EQUIPO LOCAL ---
BEGIN TRAN

INSERT INTO PartidoEquipoLocal
SELECT DISTINCT 
	equipo_id AS Id_Equipo, 
	partido_id AS Id_Partido,
	equipo_puntos AS Puntos
FROM datos 
WHERE REPLACE(esLocal, '	', '')  = 'True';

SELECT * FROM PartidoEquipoLocal

--COMMIT
--ROLLBACK

--- TABLA PARTIDO EQUIPO VISITANTE ---
BEGIN TRAN

INSERT INTO PartidoEquipoVisitante
SELECT DISTINCT 
	equipo_id AS Id_Equipo, 
	partido_id AS Id_Partido,
	equipo_puntos AS Puntos
FROM datos 
WHERE REPLACE(esLocal, '	', '')  = 'False';

SELECT * FROM PartidoEquipoVisitante

--COMMIT
--ROLLBACK

--- TABLA ESTADISTICA ---

BEGIN TRAN

INSERT INTO Estadistica
SELECT 
    ROW_NUMBER() OVER (ORDER BY jugador_id, partido_id) AS Id,
    partido_id AS Id_Partido,
    jugador_id AS Id_Jugador,
    stat_id AS Id_Tipo_Estadistica,
    stat_valor AS Valor
FROM (
	SELECT partido_id, jugador_id, stat_asistencias_id as stat_id, stat_asistencias_valor as stat_valor FROM datos
	UNION
	SELECT partido_id, jugador_id, stat_bloqueos_id as stat_id, stat_bloqueos_valor as stat_valor FROM datos
	UNION
	SELECT partido_id, jugador_id, stat_faltas_id as stat_id, stat_faltas_valor as stat_valor FROM datos
	UNION
	SELECT partido_id, jugador_id, stat_minutos_id as stat_id, stat_minutos_valor as stat_valor FROM datos
	UNION
	SELECT partido_id, jugador_id, stat_perdidas_id as stat_id, stat_perdidas_valor as stat_valor FROM datos
	UNION
	SELECT partido_id, jugador_id, stat_puntos_id as stat_id, stat_puntos_valor as stat_valor FROM datos
	UNION
	SELECT partido_id, jugador_id, stat_rebotes_defensivos_id as stat_id, stat_rebotes_defensivos_valor as stat_valor FROM datos
	UNION
	SELECT partido_id, jugador_id, stat_rebotes_ofensivos_id as stat_id, stat_rebotes_ofensivos_valor as stat_valor FROM datos
	UNION
	SELECT partido_id, jugador_id, stat_robos_id as stat_id, stat_robos_valor as stat_valor FROM datos
	UNION
	SELECT partido_id, jugador_id, stat_segundos_id as stat_id, stat_segundos_valor as stat_valor FROM datos
	UNION
	SELECT partido_id, jugador_id, stat_tiros_convertidos_id as stat_id, stat_tiros_convertidos_valor as stat_valor FROM datos
	UNION
	SELECT partido_id, jugador_id, stat_tiros_intentos_id as stat_id, stat_tiros_intentos_valor as stat_valor FROM datos
	UNION
	SELECT partido_id, jugador_id, stat_tiros_libres_convertidos_id as stat_id, stat_tiros_libres_convertidos_valor as stat_valor FROM datos
	UNION
	SELECT partido_id, jugador_id, stat_tiros_libres_intentos_id as stat_id, stat_tiros_libres_intentos_valor as stat_valor FROM datos
	UNION
	SELECT partido_id, jugador_id, stat_tiros_triples_intentos_id as stat_id, stat_tiros_triples_intentos_valor as stat_valor FROM datos
	UNION
	SELECT partido_id, jugador_id, stat_tiros_triples_convertidos_id as stat_id, stat_tiros_triples_convertidos_valor as stat_valor FROM datos
) AS d
WHERE stat_id IS NOT NULL
ORDER BY jugador_id, stat_id;

SELECT * FROM Estadistica

--COMMIT
--ROLLBACK