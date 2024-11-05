--1. Cantidad de equipos que jugaron el 1 de diciembre de 2022.
SELECT COUNT(e.Id) AS CantidadEquipos FROM (
	SELECT e.Id FROM Equipo AS e
	INNER JOIN PartidoEquipoLocal AS pel ON (pel.Id_Equipo = e.Id)
	INNER JOIN Partido AS p ON (p.Id = pel.Id_Partido)
	WHERE YEAR(p.Fecha) = 2022 AND MONTH(p.Fecha) = 12 AND DAY(p.Fecha) = 1
	
	UNION
	
	SELECT e.Id FROM Equipo AS e
	INNER JOIN PartidoEquipoVisitante AS pel ON (pel.Id_Equipo = e.Id)
	INNER JOIN Partido AS p ON (p.Id = pel.Id_Partido)
	WHERE YEAR(p.Fecha) = 2022 AND MONTH(p.Fecha) = 12 AND DAY(p.Fecha) = 1
) e

--2. Cantidad de partidos jugados en el mes de marzo.
SELECT COUNT(Id) AS CantidadPartidos FROM Partido WHERE MONTH(Fecha) = 3

--3. Cantidad de jugadores que jugaron partidos en diciembre de 2022.
SELECT COUNT(DISTINCT j.Id) AS CantidadJugadores FROM Jugador j
INNER JOIN Estadistica AS e ON (e.Id_Jugador = j.Id)
INNER JOIN Partido AS p ON (p.Id = e.Id_Partido)
WHERE YEAR(p.Fecha) = 2022 AND MONTH(p.Fecha) = 12 

--4. Listado de partidos que se jugaron en diciembre, indicando fecha, equipo local, puntos
--realizados, equipo visitante y puntos realizados.
SELECT
	p.Fecha, 
	el.Nombre AS EquipoLocal,
	pel.Puntos AS PuntosLocal,
	ev.Nombre AS EquipoVisitante,
	pev.Puntos AS PuntosVisitante
FROM Partido p
INNER JOIN PartidoEquipoLocal AS pel ON (pel.Id_Partido = p.Id)
INNER JOIN Equipo AS el ON (el.Id = pel.Id_Equipo)
INNER JOIN PartidoEquipoVisitante AS pev ON (pev.Id_Partido = p.Id)
INNER JOIN Equipo AS ev ON (ev.Id = pev.Id_Equipo)
WHERE MONTH(p.Fecha) = 12
ORDER BY P.Fecha

--5. Cantidad de partidos que perdieron los Bucks.
SELECT
	COUNT(p.Id) AS CantidadPartidosPerdidos 
FROM Partido AS p
INNER JOIN PartidoEquipoLocal AS pel ON (pel.Id_Partido = p.Id)
INNER JOIN Equipo AS el ON (el.Id = pel.Id_Equipo)
INNER JOIN PartidoEquipoVisitante AS pev ON (pev.Id_Partido = p.Id)
INNER JOIN Equipo AS ev ON (ev.Id = pev.Id_Equipo)
WHERE (
	el.Nombre = 'Bucks' AND pel.Puntos < pev.Puntos
	OR ev.Nombre = 'Bucks' AND pev.Puntos < pel.Puntos 
)

--6. Mostrar nombre, apellido, camiseta y nombre de su equipo, del jugador con mayor
--promedio de robos por partido.
SELECT TOP(1)
	j.Nombre, 
    j.Apellido, 
    ej.NroDorsal AS Camiseta, 
    eq.Nombre AS Equipo,
    CAST (CAST(SUM(e.Valor) AS DECIMAL(5,2)) / (COUNT(DISTINCT e.Id_Partido)) AS DECIMAL (5,2)) AS PromedioRobos
FROM Jugador AS j
INNER JOIN Estadistica AS e ON (e.Id_Jugador = j.Id)
INNER JOIN TipoEstadistica AS te ON (te.Id = e.Id_Tipo_Estadistica AND te.Descripcion = 'Robos')
INNER JOIN EquipoJugador AS ej ON (ej.Id_Jugador = j.Id)
INNER JOIN Equipo AS eq ON (eq.Id = ej.Id_Equipo)
GROUP BY j.Nombre, j.Apellido, ej.NroDorsal, eq.Nombre
ORDER BY PromedioRobos DESC;

--7. Listar los 5 equipos con mayor promedio de puntos por partido.
SELECT TOP(5)
	p.Equipo,
	(CAST(CAST(SUM(p.Puntos) AS FLOAT) / (COUNT(p.PartidoId)) AS DECIMAL(5,2))) AS PromedioPuntos
FROM (
	SELECT 
		p.Id AS PartidoId, 
		e.Id AS EquipoId,
		pel.Puntos, 
		e.Nombre AS Equipo
	FROM Partido AS p
	INNER JOIN PartidoEquipoLocal AS pel ON (pel.Id_Partido = p.Id)
	INNER JOIN Equipo AS e ON (e.Id = pel.Id_Equipo)

	UNION

	SELECT 
		p.Id AS PartidoId, 
		e.Id AS EquipoId,
		pev.Puntos, 
		e.Nombre AS Equipo
	FROM Partido AS p
	INNER JOIN PartidoEquipoVisitante AS pev ON (pev.Id_Partido = p.Id)
	INNER JOIN Equipo AS e ON (e.Id = pev.Id_Equipo)
) AS p
GROUP BY p.EquipoId, P.Equipo
ORDER BY PromedioPuntos DESC

--8. Cantidad de partidos perdidos por el equipo de Boston habiendo superado los 100 puntos.
SELECT
	--cev.Nombre, 
	--ev.Nombre,
	--pev.Puntos,
	--cel.Nombre, 
	--el.Nombre,
	--pel.Puntos
	COUNT(p.Id) AS CantidadPartidosPerdidos 
FROM Partido AS p
INNER JOIN PartidoEquipoLocal AS pel ON (pel.Id_Partido = p.Id)
INNER JOIN Equipo AS el ON el.Id = (pel.Id_Equipo)
INNER JOIN Ciudad AS cel ON cel.Id = (el.Id_Ciudad)
INNER JOIN PartidoEquipoVisitante AS pev ON (pev.Id_Partido = p.Id)
INNER JOIN Equipo AS ev ON (ev.Id = pev.Id_Equipo)
INNER JOIN Ciudad AS cev ON (cev.Id = ev.Id_Ciudad)
WHERE (
	cev.Nombre = 'Boston' AND pel.Puntos > pev.Puntos AND pev.Puntos > 100
	OR cel.Nombre = 'Boston' AND pev.Puntos > pel.Puntos AND pel.Puntos > 100
)

--9. Promedio de puntos por partido de los equipos agrupados por división.
SELECT pe.Division, 
	CAST(SUM(pe.PromedioPuntos)AS FLOAT) / (COUNT(pe.Equipo)) AS PromedioPuntos
FROM (SELECT
	p.Equipo,
	(CAST(CAST(SUM(p.Puntos) AS FLOAT) / (COUNT(p.PartidoId)) AS DECIMAL(5,2))) AS PromedioPuntos,
	p.Division
FROM (
	SELECT 
		p.Id AS PartidoId, 
		e.Id AS EquipoId,
		pel.Puntos, 
		e.Nombre AS Equipo,
		d.Nombre AS Division,
		d.Id AS DivisionId
	FROM Partido AS p
	INNER JOIN PartidoEquipoLocal AS pel ON (pel.Id_Partido = p.Id)
	INNER JOIN Equipo AS e ON (e.Id = pel.Id_Equipo)
	INNER JOIN Division AS d ON (d.Id = e.Id_Division)

	UNION

	SELECT 
		p.Id AS PartidoId, 
		e.Id AS EquipoId,
		pev.Puntos, 
		e.Nombre AS Equipo,
		d.Nombre AS Division,
		d.Id AS DivisionId
	FROM Partido AS p
	INNER JOIN PartidoEquipoVisitante AS pev ON (pev.Id_Partido = p.Id)
	INNER JOIN Equipo AS e ON (e.Id = pev.Id_Equipo)
	INNER JOIN Division AS d ON (d.Id = e.Id_Division)
) AS p
GROUP BY p.Division,P.Equipo
) AS pe GROUP BY pe.Division

--10. Indicar nombre del país y cantidad de jugadores, del país con más jugadores en el torneo.
SELECT TOP 1 
	p.Nombre,
	COUNT(j.id) AS CantJugadores 
FROM Pais as p
	INNER JOIN Jugador AS j ON (p.Id = j.Id_Pais) 
GROUP BY p.Nombre
ORDER BY CantJugadores DESC

--11. Cantidad de puntos, rebotes totales y asistencias realizados por Kawhi Leonard contra
--equipos de la otra conferencia.
SELECT DISTINCT 
	CASE 
		WHEN te.Descripcion LIKE 'Rebotes%' THEN 'Rebotes Totales'
		ELSE te.Descripcion
	END AS Tipo_Estadistica,
	SUM(EquiposContrarios.Valor) AS TOTAL
FROM(
	SELECT 
	(CASE WHEN pel.Id_Equipo != e.Id THEN pel.Id_Equipo ELSE pev.Id_Equipo END) AS idContrarios,
	es.Id_Tipo_Estadistica,
	es.Valor
	FROM Jugador AS j
		INNER JOIN EquipoJugador AS ej ON (j.Id = ej.Id_Jugador AND CONCAT(j.Nombre,' ',j.Apellido)='Kawhi Leonard')
		INNER JOIN Equipo AS e ON (ej.Id_Equipo = e.Id)
		INNER JOIN Estadistica AS es ON (j.Id = es.Id_Jugador)
		INNER JOIN Partido p ON (es.Id_Partido = p.Id)
		INNER JOIN PartidoEquipoLocal pel ON (p.Id = pel.Id_Partido) 
		INNER JOIN PartidoEquipoVisitante pev ON (p.Id = pev.Id_Partido)) AS EquiposContrarios 
	INNER JOIN Equipo eq ON(EquiposContrarios.idContrarios = eq.Id)
	INNER JOIN Division AS d ON (eq.Id_Division = d.Id)
	INNER JOIN Conferencia AS c ON (d.Id_Conferencia = c.Id AND c.Nombre != 'Oeste')
	INNER JOIN TipoEstadistica AS te ON (EquiposContrarios.Id_Tipo_Estadistica = te.Id 
		AND (te.Descripcion LIKE 'Rebotes%' OR te.Descripcion='Puntos' OR te.Descripcion='Asistencias'))
	GROUP BY CASE WHEN te.Descripcion LIKE 'Rebotes%' THEN 'Rebotes Totales' ELSE te.Descripcion END
	ORDER BY Tipo_Estadistica

--12. Cantidad de jugadores con más de 15 años de carrera.
SELECT 
    COUNT(Id) AS CantidadJugadores
FROM Jugador
WHERE YEAR((SELECT TOP 1 Fecha FROM Partido ORDER BY Partido.Fecha DESC))- DraftYear > 15

--13. Listado de jugadores que jugaron en más de un equipo durante la temporada '2022-2023',
--indicando su nombre completo, equipo y número de camiseta.

SELECT 
	CONCAT(Subquery.Nombre,' ',Subquery.Apellido) AS NombreCompleto,
	e.Nombre AS NombreEquipo,
	ej.NroDorsal AS NroCamiseta
FROM (
	SELECT 
		j.Id AS IdJugador,
		j.Nombre,
		j.Apellido,
		COUNT(ej.Id_Equipo) AS EquiposPaso 
	FROM Jugador AS j
	INNER JOIN EquipoJugador AS ej ON (j.Id = ej.Id_Jugador) 
	GROUP BY j.Id,j.Nombre,j.Apellido
)AS Subquery
INNER JOIN EquipoJugador AS ej ON (Subquery.IdJugador = ej.Id_Jugador) 
INNER JOIN Equipo AS e ON (ej.Id_Equipo=e.Id)
WHERE EquiposPaso > 1

--14. Cantidad de partidos en que los que al menos un jugador de los Celtics obtuvo más de 25
--puntos.

SELECT 
	COUNT(idPartidos.Id_Partido) AS CantidadPartidos 
FROM (
	SELECT DISTINCT Estadistica.Id_Partido FROM Jugador
    INNER JOIN EquipoJugador ON (Jugador.Id = EquipoJugador.Id_Jugador)
    INNER JOIN Equipo ON (EquipoJugador.Id_Equipo = Equipo.Id AND Equipo.Nombre = 'Celtics')
    INNER JOIN Estadistica ON (Jugador.Id = Estadistica.Id_Jugador)
    INNER JOIN TipoEstadistica ON (Estadistica.Id_Tipo_Estadistica = TipoEstadistica.Id AND TipoEstadistica.Descripcion = 'Puntos')
    WHERE Estadistica.Valor > 25
) AS idPartidos

--15. Indicar ID de partido, fecha, sigla y puntos realizados del equipo local y visitante, del
--partido en que el equipo de Kawhi Leonard ganó por mayor diferencia de puntos en la
--temporada

SELECT 
	Subquery.IdPartido, 
	Subquery.Fecha,
	Subquery.SiglasLocal,
	Subquery.PuntosLocal,
	e.Siglas AS SiglasVisitante, 
	Subquery.PuntosVisitante,
	Subquery.Diferencia 
FROM(
	SELECT TOP 1
		p.Id AS IdPartido,
		p.Fecha,
		e.Siglas AS SiglasLocal,
		pel.Puntos AS PuntosLocal,
		pev.Id_Equipo AS EquipoVisitante,
		pev.Puntos AS PuntosVisitante,
		(((CASE WHEN pel.Id_Equipo = e.Id then pel.Puntos else pev.Puntos END) - (CASE WHEN pel.Id_Equipo = e.Id then pev.Puntos else pel.Puntos END))) AS Diferencia 
	FROM Partido AS p
		INNER JOIN PartidoEquipoLocal pel ON p.Id = pel.Id_Partido
		INNER JOIN PartidoEquipoVisitante pev ON p.Id = pev.Id_Partido
		INNER JOIN Equipo e ON (pel.Id_Equipo = e.Id OR pev.Id_Equipo = e.Id)
		INNER JOIN EquipoJugador AS ej ON (e.Id = ej.Id_Equipo)
		INNER JOIN Jugador AS j ON (ej.Id_Jugador = j.Id AND CONCAT(j.Nombre,' ',j.Apellido)='Kawhi Leonard')
	WHERE ((CASE WHEN pel.Id_Equipo = e.Id then pel.Puntos else pev.Puntos END) > (CASE WHEN pel.Id_Equipo = e.Id then pev.Puntos else pel.Puntos END))
	GROUP BY p.Id,p.Fecha,e.Siglas,pel.Id_Equipo,pel.Puntos,pev.Id_Equipo,pev.Puntos,e.Id
	ORDER BY Diferencia DESC
) AS Subquery
INNER JOIN Equipo e ON (Subquery.EquipoVisitante = e.Id)