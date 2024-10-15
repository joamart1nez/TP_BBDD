---- JUGADOR EQUIPO ----
BEGIN TRAN

INSERT INTO EquipoJugador
SELECT DISTINCT
	jugador_id AS Id_Jugador, 
	equipo_id As Id_Equipo, 
	caminseta AS NroDorsal 
FROM datos

--COMMIT
--ROLLBACK