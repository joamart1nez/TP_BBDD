--- TIPO DE ESTADISTICA ---

BEGIN TRAN

INSERT INTO TipoEstadistica
SELECT 
	Id,
	TRIM(REPLACE(Nombre,'	','')) AS Descripcion 
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
