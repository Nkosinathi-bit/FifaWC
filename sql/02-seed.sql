-- Fictional, reduced coursework dataset. This is not the official 2026 draw,
-- tournament schedule, current player selection, or match results.
SET NOCOUNT ON;
INSERT INTO dbo.Countries (CountryName) VALUES
('USA'),('Canada'),('Mexico'),('France'),('Argentina'),('Spain'),('England'),
('Portugal'),('Netherlands'),('Italy'),('Belgium'),('Uruguay'),('Croatia'),
('Brazil'),('Germany');

INSERT INTO dbo.Cities (CityName, CountryID) VALUES
('New York/New Jersey',1),('Toronto',2),('Mexico City',3),('Los Angeles',1),
('Dallas',1),('Vancouver',2),('Monterrey',3),('Miami',1),('Atlanta',1),
('Guadalajara',3),('Seattle',1),('Houston',1),('Philadelphia',1);

INSERT INTO dbo.Stadiums (StadiumName, Capacity, CityID) VALUES
('MetLife Stadium',82500,1),('BMO Field',30000,2),('Estadio Azteca',87000,3),
('SoFi Stadium',70000,4),('AT&T Stadium',80000,5),('BC Place',54000,6),
('Estadio BBVA',53000,7),('Hard Rock Stadium',65000,8),
('Mercedes-Benz Stadium',71000,9),('Estadio Akron',48000,10),
('Lumen Field',69000,11),('NRG Stadium',72000,12),('Lincoln Financial Field',69000,13);

INSERT INTO dbo.Teams (TeamName, CountryID, GroupName) VALUES
('Brazil',14,'A'),('Germany',15,'A'),('France',4,'B'),('Argentina',5,'B'),
('Spain',6,'C'),('England',7,'C'),('Portugal',8,'D'),('Netherlands',9,'D'),
('Italy',10,'E'),('Belgium',11,'E'),('Uruguay',12,'F'),('Croatia',13,'F');

INSERT INTO dbo.Players (PlayerName, Position, TeamID) VALUES
('Player One','Forward',1),('Player Two','Midfielder',2),
('Kylian Mbappe','Forward',3),('Antoine Griezmann','Forward',3),
('Lionel Messi','Forward',4),('Angel Di Maria','Midfielder',4),
('Pedri','Midfielder',5),('Alvaro Morata','Forward',5),
('Harry Kane','Forward',6),('Jude Bellingham','Midfielder',6),
('Cristiano Ronaldo','Forward',7),('Bruno Fernandes','Midfielder',7),
('Virgil van Dijk','Defender',8),('Frenkie de Jong','Midfielder',8),
('Nicolo Barella','Midfielder',9),('Ciro Immobile','Forward',9),
('Kevin De Bruyne','Midfielder',10),('Romelu Lukaku','Forward',10),
('Luis Suarez','Forward',11),('Federico Valverde','Midfielder',11),
('Luka Modric','Midfielder',12),('Ivan Perisic','Forward',12);

INSERT INTO dbo.Matches
(MatchDate,MatchTime,Stage,HomeTeamID,AwayTeamID,HomeScore,AwayScore,StadiumID) VALUES
('2026-06-10','18:00','Group Stage',1,2,0,0,1),
('2026-06-12','20:00','Group Stage',3,4,2,1,2),
('2026-06-13','18:00','Group Stage',5,6,0,0,3),
('2026-06-14','21:00','Group Stage',7,2,3,2,4),
('2026-06-15','16:00','Group Stage',1,5,1,1,5),
('2026-06-16','19:00','Group Stage',6,7,4,2,6),
('2026-06-17','18:00','Group Stage',8,9,2,2,7),
('2026-06-18','20:00','Group Stage',10,11,1,0,8),
('2026-06-19','16:00','Group Stage',11,12,3,1,9),
('2026-06-20','19:00','Group Stage',3,8,0,2,10),
('2026-06-21','21:00','Group Stage',4,9,1,3,11);

INSERT INTO dbo.Tickets (MatchID,FanName,SeatNumber) VALUES
(1,'Demo Fan 01','A1'),(2,'Demo Fan 02','B12'),(3,'Demo Fan 03','C10'),
(4,'Demo Fan 04','D5'),(5,'Demo Fan 05','E7'),(6,'Demo Fan 06','F9'),
(7,'Demo Fan 07','G11'),(8,'Demo Fan 08','H22'),(9,'Demo Fan 09','J15');
GO
