BEGIN TRAN

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
	Id_Equipo_Ganador INTEGER,
	Fechas DATE,
	CONSTRAINT FK_Temporada FOREIGN KEY (Id_Temporada) REFERENCES Temporada(Id),
	CONSTRAINT FK_Equipo_Ganador FOREIGN KEY (Id_Equipo_Ganador) REFERENCES Equipo(Id)
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
	FechaDesde DATE,
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