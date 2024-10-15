--- ESTADISTICA ---

BEGIN TRAN

SELECT * FROM TipoEstadistica

'SELECT ' + (select STRING_AGG('stat_'+LOWER(REPLACE(Descripcion, ' ','_'))+'_id as Id', ',') from TipoEstadistica) + ' FROM datos';

SELECT 
	partido_id AS Id_Partido,
	jugador_id as Id_Jugador,
	t.*
FROM datos d
INNER JOIN TipoEstadistica as t  ON (1=1)

s
--COMMIT
--ROLLBACK

