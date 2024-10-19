BEGIN TRAN

CREATE TABLE datos(
equipoOP_ciudad VARCHAR(100),
equipoOP_codigo VARCHAR(30),
equipoOP_sigla VARCHAR(5),
equipoOP_conferencia VARCHAR(50),
equipoOP_division VARCHAR(50),
equipoOP_id INT,
equipoOP_nombre VARCHAR(100),
stat_asistencias_id INT,
stat_asistencias_nombre VARCHAR(50),
stat_asistencias_valor INT,
stat_bloqueos_id INT,
stat_bloqueos_nombre VARCHAR(50),
stat_bloqueos_valor INT,
equipo_ciudad VARCHAR(100),
jugador_codigo VARCHAR(40),
pais VARCHAR(200),
stat_rebotes_defensivos_id INT,
stat_rebotes_defensivos_nombre VARCHAR(50),
stat_rebotes_defensivos_valor INT,
equipo_sigla VARCHAR(5),
equipo_conferencia VARCHAR(20),
nombre_completo VARCHAR(100),
equipo_division VARCHAR(50),
draft_year INT,
fecha date,
stat_tiros_intentos_id INT,
stat_tiros_intentos_nombre VARCHAR(50),
stat_tiros_intentos_valor INT,
stat_tiros_convertidos_id INT,
stat_tiros_convertidos_nombre VARCHAR(50),
stat_tiros_convertidos_valor INT,
tiros_porcentaje decimal(5,2),
nombre VARCHAR(100),
stat_faltas_id INT,
stat_faltas_nombre VARCHAR(50),
stat_faltas_valor INT,
stat_tiros_libres_intentos_id INT,
stat_tiros_libres_intentos_nombre VARCHAR(50),
stat_tiros_libres_intentos_valor INT,
stat_tiros_libres_convertidos_id INT,
stat_tiros_libres_convertidos_nombre VARCHAR(50),
stat_tiros_libres_convertidos_valor INT,
tiros_libres_porcentaje decimal(5,2),
partido_id INT,
altura VARCHAR(20),
esLocal VARCHAR(20),
caminseta INT,
apellido VARCHAR(100),
stat_minutos_id INT,
stat_minutos_nombre VARCHAR(50),
stat_minutos_valor INT,
equipo_nombre VARCHAR(100),
stat_rebotes_ofensivos_id INT,
stat_rebotes_ofensivos_nombre VARCHAR(50),
stat_rebotes_ofensivos_valor INT,
equipoOP_puntos INT,
jugador_id INT,
stat_puntos_id INT,
stat_puntos_nombre VARCHAR(50),
stat_puntos_valor INT,
posicion VARCHAR(5),
rebotes INT,
temporada_id INT,
stat_segundos_id INT,
stat_segundos_nombre VARCHAR(50),
stat_segundos_valor INT,
stat_robos_id INT,
stat_robos_nombre VARCHAR(50),
stat_robos_valor INT,
equipo_codigo VARCHAR(30),
equipo_puntos INT,
equipo_id INT,
stat_tiros_triples_intentos_id INT,
stat_tiros_triples_intentos_nombre VARCHAR(50),
stat_tiros_triples_intentos_valor INT,
stat_tiros_triples_convertidos_id INT,
stat_tiros_triples_convertidos_nombre VARCHAR(50),
stat_tiros_triples_convertidos_valor INT,
tiros_triples_porcentaje decimal(5,2),
stat_perdidas_id INT,
stat_perdidas_nombre VARCHAR(50),
stat_perdidas_valor INT,
peso VARCHAR(100),
resultado VARCHAR(10),
temporada_descripcion VARCHAR(50),
idPais INT,
equipo_idCiudad INT,
equipoOP_idCiudad INT
);

CREATE TABLE Temporada (
	Id INTEGER PRIMARY KEY,
	Descripcion VARCHAR(20)
);

GO

CREATE TABLE Ciudad(
	Id INTEGER PRIMARY KEY,
	Nombre VARCHAR(30)
);

GO

CREATE TABLE Conferencia(
	Id INTEGER PRIMARY KEY,
	Nombre VARCHAR(20)
);

GO

CREATE TABLE Pais(
	Id INTEGER PRIMARY KEY,
	Nombre VARCHAR(50)
);

GO

CREATE TABLE TipoEstadistica(
	Id INTEGER PRIMARY KEY,
	Descripcion VARCHAR(30)
);

GO

CREATE TABLE Division(
	Id INTEGER PRIMARY KEY,
	Id_Conferencia INTEGER,
	Nombre VARCHAR(20),
	CONSTRAINT FK_Conferencia FOREIGN KEY (Id_Conferencia) REFERENCES Conferencia(Id)
);

GO 

CREATE TABLE Equipo(
	Id INTEGER PRIMARY KEY,
	Id_Ciudad INTEGER,
	Id_Division INTEGER,
	Nombre VARCHAR(30),
	CodAlfa VARCHAR(30),
	Siglas VARCHAR(3),
	CONSTRAINT FK_Ciudad FOREIGN KEY (Id_Ciudad) REFERENCES Ciudad(Id),
	CONSTRAINT FK_Division FOREIGN KEY (Id_Division) REFERENCES Division(Id)
);

GO

CREATE TABLE Partido(
	Id INTEGER PRIMARY KEY,
	Id_Temporada INTEGER,
	Fecha DATE,
	CONSTRAINT FK_Temporada FOREIGN KEY (Id_Temporada) REFERENCES Temporada(Id),
);

GO 

CREATE TABLE PartidoEquipoLocal(
	Id_Equipo INTEGER,
	Id_Partido INTEGER,
	Puntos INTEGER,
	CONSTRAINT [PK_PEL] PRIMARY KEY CLUSTERED (Id_Equipo, Id_Partido),
	CONSTRAINT FK_Equipo_Local FOREIGN KEY (Id_Equipo) REFERENCES Equipo(Id),
	CONSTRAINT FK_Partido_Local FOREIGN KEY (Id_Partido) REFERENCES Partido(Id),
);

GO 

CREATE TABLE PartidoEquipoVisitante(
	Id_Equipo INTEGER,
	Id_Partido INTEGER,
	Puntos INTEGER,
	CONSTRAINT [PK_PEV] PRIMARY KEY CLUSTERED (Id_Equipo, Id_Partido),
	CONSTRAINT FK_Equipo_Visitante FOREIGN KEY (Id_Equipo) REFERENCES Equipo(Id),
	CONSTRAINT FK_Partido_Vistante FOREIGN KEY (Id_Partido) REFERENCES Partido(Id),
);

GO 

CREATE TABLE Jugador(
	Id INTEGER PRIMARY KEY,
	Id_Pais INTEGER,
	CodAlfa VARCHAR(30),
	Nombre VARCHAR(30),
	Apellido VARCHAR(30),
	Altura DECIMAL(5,2),
	Peso DECIMAL(5,2),
	DraftYear INT,
	Posicion VARCHAR(3),
	CONSTRAINT FK_Pais FOREIGN KEY (Id_Pais) REFERENCES Pais(Id),
);

GO 

CREATE TABLE EquipoJugador(
	Id_Jugador INTEGER,
	Id_Equipo INTEGER,
	NroDorsal INTEGER,
	CONSTRAINT [PK_EJ] PRIMARY KEY CLUSTERED (Id_Jugador, Id_Equipo),
	CONSTRAINT FK_Jugador_EJ FOREIGN KEY (Id_Jugador) REFERENCES Jugador(Id),
	CONSTRAINT FK_Equipo FOREIGN KEY (Id_Equipo) REFERENCES Equipo(Id)
);

GO

CREATE TABLE Estadistica(
	Id INTEGER PRIMARY KEY,
	Id_Partido INTEGER,
	Id_Jugador INTEGER,
	Id_Tipo_Estadistica INTEGER,
	Valor INTEGER,
	CONSTRAINT FK_Partido FOREIGN KEY (Id_Partido) REFERENCES Partido(Id),
	CONSTRAINT FK_Jugador_E FOREIGN KEY (Id_Jugador) REFERENCES Jugador(Id),
	CONSTRAINT FK_Tipo_Estadistica FOREIGN KEY (Id_Tipo_Estadistica) REFERENCES TipoEstadistica(Id)
);

--COMMIT
--ROLLBACK
