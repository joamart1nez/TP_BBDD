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
SELECT
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
GROUP BY p.DivisionId,p.Division,P.Equipo
ORDER BY p.DivisionId 
--SELECT
--    e.Nombre AS Equipo,
--    AVG(CASE WHEN pel.Id_Equipo = e.Id THEN pel.Puntos ELSE pev.Puntos END) AS PromedioPuntos,
--    d.Nombre AS Division
--FROM Partido p
--INNER JOIN PartidoEquipoLocal pel ON p.Id = pel.Id_Partido
--INNER JOIN PartidoEquipoVisitante pev ON p.Id = pev.Id_Partido
--INNER JOIN Equipo e ON (pel.Id_Equipo = e.Id OR pev.Id_Equipo = e.Id)
--INNER JOIN Division d ON e.Id_Division = d.Id
--GROUP BY e.Nombre, d.Nombre,d.Id
--ORDER BY d.Id

--10. Indicar nombre del país y cantidad de jugadores, del país con más jugadores en el torneo.

--11. Cantidad de puntos, rebotes totales y asistencias realizados por Kawhi Leonard contra
--equipos de la otra conferencia.

--12. Cantidad de jugadores con más de 15 años de carrera.

--13. Listado de jugadores que jugaron en más de un equipo durante la temporada '2022-2023',
--indicando su nombre completo, equipo y número de camiseta.

--14. Cantidad de partidos en que los que al menos un jugador de los Celtics obtuvo más de 25
--puntos.

--15. Indicar ID de partido, fecha, sigla y puntos realizados del equipo local y visitante, del
--partido en que el equipo de Kawhi Leonard ganó por mayor diferencia de puntos en la
--temporada