-- ============================================================
-- FIFA WORLD CUP 2026 DATABASE
-- FINAL SUBMISSION SCRIPT

-- ============================================================
-- MEMBERS:
-- Nkosinathi Mathenjwa 604435
-- Zane Vincent Botha 604238
-- Tsakani Mawelela 604879
-- ============================================================

-- ============================================================
-- RESET DATABASE SAFELY
-- ============================================================
USE master;
GO

IF DB_ID('FIFA2026') IS NOT NULL
BEGIN
    ALTER DATABASE FIFA2026 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE FIFA2026;
END
GO

CREATE DATABASE FIFA2026;
GO

USE FIFA2026;
GO

-- ============================================================
-- TABLE CREATION 
-- ============================================================

CREATE TABLE Countries (
    CountryID INT IDENTITY PRIMARY KEY,
    CountryName VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Cities (
    CityID INT IDENTITY PRIMARY KEY,
    CityName VARCHAR(100),
    CountryID INT,
    FOREIGN KEY (CountryID) REFERENCES Countries(CountryID)
);

CREATE TABLE Stadiums (
    StadiumID INT IDENTITY PRIMARY KEY,
    StadiumName VARCHAR(100),
    Capacity INT,
    CityID INT,
    FOREIGN KEY (CityID) REFERENCES Cities(CityID)
);

CREATE TABLE Teams (
    TeamID INT IDENTITY PRIMARY KEY,
    TeamName VARCHAR(100) UNIQUE,
    CountryID INT,
    GroupName CHAR(1),
    FOREIGN KEY (CountryID) REFERENCES Countries(CountryID)
);

CREATE TABLE Players (
    PlayerID INT IDENTITY PRIMARY KEY,
    PlayerName VARCHAR(100),
    Position VARCHAR(50),
    TeamID INT,
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
);

CREATE TABLE Matches (
    MatchID INT IDENTITY PRIMARY KEY,
    MatchDate DATE NOT NULL,
    MatchTime TIME NOT NULL,
    Stage VARCHAR(50),
    HomeTeamID INT,
    AwayTeamID INT,
    HomeScore INT DEFAULT 0,
    AwayScore INT DEFAULT 0,
    StadiumID INT,
    FOREIGN KEY (HomeTeamID) REFERENCES Teams(TeamID),
    FOREIGN KEY (AwayTeamID) REFERENCES Teams(TeamID),
    FOREIGN KEY (StadiumID) REFERENCES Stadiums(StadiumID)
);

CREATE TABLE Tickets (
    TicketID INT IDENTITY PRIMARY KEY,
    MatchID INT,
    FanName VARCHAR(100),
    SeatNumber VARCHAR(20),
    PurchaseDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (MatchID) REFERENCES Matches(MatchID)
);
GO

-- ============================================================
-- DATA
-- ============================================================

INSERT INTO Countries (CountryName) VALUES 
('USA'), 
('Canada'), 
('Mexico'),
('France'),
('Argentina'),
('Spain'),
('England'),
('Portugal'),
('Netherlands'),
('Italy'),
('Belgium'),
('Uruguay'),
('Croatia');

INSERT INTO Cities (CityName, CountryID) VALUES 
('New York/New Jersey', 1),
('Toronto', 2),
('Mexico City', 3),
('Los Angeles', 1),
('Dallas', 1),
('Vancouver', 2),
('Monterrey', 3),
('Miami', 1),
('Atlanta', 1),
('Guadalajara', 3),
('Seattle', 1),
('Houston', 1),
('Philadelphia', 1);

INSERT INTO Stadiums (StadiumName, Capacity, CityID) VALUES
('MetLife Stadium', 82500, 1),
('BMO Field', 30000, 2),
('Estadio Azteca', 87000, 3),
('SoFi Stadium', 70000, 4),
('AT&T Stadium', 80000, 5),
('BC Place', 54000, 6),
('Estadio BBVA', 53000, 7),
('Hard Rock Stadium', 65000, 8),
('Mercedes-Benz Stadium', 71000, 9),
('Estadio Akron', 48000, 10),
('Lumen Field', 69000, 11),
('NRG Stadium', 72000, 12),
('Lincoln Financial Field', 69000, 13);

INSERT INTO Teams (TeamName, CountryID, GroupName) VALUES
('Brazil', 1, 'A'),
('Germany', 2, 'A'),
('France', 4, 'B'),
('Argentina', 5, 'B'),
('Spain', 6, 'C'),
('England', 7, 'C'),
('Portugal', 8, 'D'),
('Netherlands', 9, 'D'),
('Italy', 10, 'E'),
('Belgium', 11, 'E'),
('Uruguay', 12, 'F'),
('Croatia', 13, 'F');

INSERT INTO Players (PlayerName, Position, TeamID) VALUES
('Player One', 'Forward', 1),
('Player Two', 'Midfielder', 2),
('Kylian Mbappe', 'Forward', 3),
('Antoine Griezmann', 'Forward', 3),
('Lionel Messi', 'Forward', 4),
('Angel Di Maria', 'Midfielder', 4),
('Pedri', 'Midfielder', 5),
('Alvaro Morata', 'Forward', 5),
('Harry Kane', 'Forward', 6),
('Jude Bellingham', 'Midfielder', 6),
('Cristiano Ronaldo', 'Forward', 7),
('Bruno Fernandes', 'Midfielder', 7),
('Virgil van Dijk', 'Defender', 8),
('Frenkie de Jong', 'Midfielder', 8),
('Nicolo Barella', 'Midfielder', 9),
('Ciro Immobile', 'Forward', 9),
('Kevin De Bruyne', 'Midfielder', 10),
('Romelu Lukaku', 'Forward', 10),
('Luis Suarez', 'Forward', 11),
('Federico Valverde', 'Midfielder', 11),
('Luka Modric', 'Midfielder', 12),
('Ivan Perisic', 'Forward', 12);

-- CLEAN MATCHES + Tickets FIRST
DELETE FROM Tickets;
DBCC CHECKIDENT ('Tickets', RESEED, 1);

DELETE FROM Matches;
DBCC CHECKIDENT ('Matches', RESEED, 1);

SET IDENTITY_INSERT Matches OFF;

INSERT INTO Matches (MatchDate, MatchTime, Stage, HomeTeamID, AwayTeamID, StadiumID)
VALUES
('2026-06-10', '18:00', 'Group Stage', 1, 2, 1),
('2026-06-12', '20:00', 'Group Stage', 3, 4, 2),
('2026-06-13', '18:00', 'Group Stage', 5, 6, 3),
('2026-06-14', '21:00', 'Group Stage', 7, 2, 4),
('2026-06-15', '16:00', 'Group Stage', 1, 5, 5),
('2026-06-16', '19:00', 'Group Stage', 6, 7, 6),
('2026-06-17', '18:00', 'Group Stage', 8, 9, 7),
('2026-06-18', '20:00', 'Group Stage', 10, 11, 8),
('2026-06-19', '16:00', 'Group Stage', 11, 12, 9),
('2026-06-20', '19:00', 'Group Stage', 3, 8, 10),
('2026-06-21', '21:00', 'Group Stage', 4, 9, 11);


UPDATE Matches SET HomeScore = 2, AwayScore = 1 WHERE MatchID = 2;
UPDATE Matches SET HomeScore = 0, AwayScore = 0 WHERE MatchID = 3;
UPDATE Matches SET HomeScore = 3, AwayScore = 2 WHERE MatchID = 4;
UPDATE Matches SET HomeScore = 1, AwayScore = 1 WHERE MatchID = 5;
UPDATE Matches SET HomeScore = 4, AwayScore = 2 WHERE MatchID = 6;
UPDATE Matches SET HomeScore = 2, AwayScore = 2 WHERE MatchID = 7;
UPDATE Matches SET HomeScore = 1, AwayScore = 0 WHERE MatchID = 8;
UPDATE Matches SET HomeScore = 3, AwayScore = 1 WHERE MatchID = 9;
UPDATE Matches SET HomeScore = 0, AwayScore = 2 WHERE MatchID = 10;
UPDATE Matches SET HomeScore = 1, AwayScore = 3 WHERE MatchID = 11;


INSERT INTO Tickets (MatchID, FanName, SeatNumber)
VALUES
(1, 'Test Fan', 'A1'),
(2, 'John Doe', 'B12'),
(3, 'Michael Brown', 'C10'),
(4, 'Sarah Johnson', 'D5'),
(5, 'David Lee', 'E7'),
(6, 'Chris Evans', 'F9'),
(7, 'Daniel Craig', 'G11'),
(8, 'Emma Watson', 'H22'),
(9, 'Tom Holland', 'J15');
GO

-- ============================================================
-- VIEW
-- ============================================================
CREATE VIEW vw_MatchDetails AS
SELECT 
    m.MatchID,
    ht.TeamName AS HomeTeam,
    at.TeamName AS AwayTeam,
    m.MatchDate,
    m.HomeScore,
    m.AwayScore,
    s.StadiumName
FROM Matches m
JOIN Teams ht ON m.HomeTeamID = ht.TeamID
JOIN Teams at ON m.AwayTeamID = at.TeamID
JOIN Stadiums s ON m.StadiumID = s.StadiumID;
GO

-- ============================================================
-- STORED PROCEDURE
-- ============================================================
CREATE PROCEDURE sp_GetMatchesByTeam
    @TeamID INT
AS
BEGIN
    SELECT *
    FROM Matches
    WHERE HomeTeamID = @TeamID OR AwayTeamID = @TeamID;
END;
GO

-- ============================================================
-- FUNCTION
-- ============================================================
CREATE FUNCTION fn_TotalGoals (@MatchID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Total INT;

    SELECT @Total = ISNULL(HomeScore,0) + ISNULL(AwayScore,0)
    FROM Matches
    WHERE MatchID = @MatchID;

    RETURN ISNULL(@Total,0);
END;
GO

-- ============================================================
-- TRIGGERS
-- ============================================================

GO
CREATE TRIGGER trg_ValidateScores
ON Matches
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM inserted 
        WHERE HomeScore < 0 OR AwayScore < 0
    )
    BEGIN
        RAISERROR ('Scores cannot be negative.',16,1);
        RETURN;
    END

    INSERT INTO Matches (
        MatchDate, MatchTime, Stage,
        HomeTeamID, AwayTeamID,
        HomeScore, AwayScore, StadiumID
    )
    SELECT 
        MatchDate, MatchTime, Stage,
        HomeTeamID, AwayTeamID,
        HomeScore, AwayScore, StadiumID
    FROM inserted;
END;
GO

-- Prevent duplicate matches
CREATE TRIGGER trg_PreventDuplicateMatch
ON Matches
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Matches m
        JOIN inserted i
        ON m.HomeTeamID = i.HomeTeamID
        AND m.AwayTeamID = i.AwayTeamID
        AND m.MatchDate = i.MatchDate
        AND m.MatchID <> i.MatchID
    )
    BEGIN
        RAISERROR('Duplicate match detected.',16,1);
        ROLLBACK;
    END
END;
GO
-- ============================================================
-- CURSOR
-- ============================================================

DECLARE @Name VARCHAR(100);

DECLARE TeamCursor CURSOR FOR
SELECT TeamName FROM Teams;

OPEN TeamCursor;
FETCH NEXT FROM TeamCursor INTO @Name;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Team: ' + @Name;
    FETCH NEXT FROM TeamCursor INTO @Name;
END;

CLOSE TeamCursor;
DEALLOCATE TeamCursor;
GO

-- ============================================================
-- TRANSACTION 
-- ============================================================

BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE Teams
    SET TeamName = 'Brazil Updated'
    WHERE TeamID = 1;

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
END CATCH;
GO

-- ============================================================
-- SECURITY
-- ============================================================
-- Remove old login/user if it exists
IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'FIFAUser')
    DROP LOGIN FIFAUser;
GO

-- Remove user in current database if exists
USE FIFA2026;
GO

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'FIFAUser')
    DROP USER FIFAUser;
GO
CREATE LOGIN FIFAUser WITH PASSWORD = 'StrongPass123!';
GO

CREATE USER FIFAUser FOR LOGIN FIFAUser;
GO

GRANT SELECT ON Teams TO FIFAUser;
GO

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'StrongPass123!';
CREATE SYMMETRIC KEY FanKey
WITH ALGORITHM = AES_256
ENCRYPTION BY PASSWORD = 'StrongPass123!';
GO

-- ============================================================
-- BACKUP
-- ============================================================

BACKUP DATABASE FIFA2026
TO DISK = 'C:\Temp\FIFA2026.bak'
WITH 
    FORMAT,
    INIT,
    NAME = 'FIFA2026 Full Backup',
    STATS = 10;
GO




-- ============================================================
-- DATA QUERIES 
-- ============================================================

-- ============================================================
-- JOIN QUERY
-- ============================================================
-- Retrieve match details with teams and stadium
SELECT 
    m.MatchID,
    ht.TeamName AS HomeTeam,
    at.TeamName AS AwayTeam,
    s.StadiumName
FROM Matches m
JOIN Teams ht ON m.HomeTeamID = ht.TeamID
JOIN Teams at ON m.AwayTeamID = at.TeamID
JOIN Stadiums s ON m.StadiumID = s.StadiumID;
GO


--Total Goals Per Team(Ordered)
SELECT 
    t.TeamName,
    SUM(
        CASE 
            WHEN t.TeamID = m.HomeTeamID THEN m.HomeScore
            WHEN t.TeamID = m.AwayTeamID THEN m.AwayScore
        END
    ) AS TotalGoals
FROM Teams t
JOIN Matches m 
    ON t.TeamID = m.HomeTeamID 
    OR t.TeamID = m.AwayTeamID
GROUP BY t.TeamName
ORDER BY TotalGoals DESC;
GO

-- ============================================================
-- SUBQUERY
-- ============================================================
-- Teams that have played matches
SELECT TeamName
FROM Teams
WHERE TeamID IN (
    SELECT HomeTeamID FROM Matches
    UNION
    SELECT AwayTeamID FROM Matches
);
GO

--Teams with above average goals
SELECT t.TeamName
FROM Teams t
JOIN Matches m 
    ON t.TeamID = m.HomeTeamID OR t.TeamID = m.AwayTeamID
GROUP BY t.TeamName
HAVING SUM(
    CASE 
        WHEN t.TeamID = m.HomeTeamID THEN m.HomeScore
        ELSE m.AwayScore
    END
) > (
    SELECT AVG(HomeScore + AwayScore) FROM Matches
);
GO
-- ============================================================
-- CTE
-- ============================================================
WITH MatchGoals AS (
    SELECT 
        MatchID,
        HomeScore + AwayScore AS TotalGoals
    FROM Matches
)
SELECT * 
FROM MatchGoals
WHERE TotalGoals > 2;
GO

-- Ranks teams
WITH TeamGoals AS (
    SELECT 
        t.TeamName,
        SUM(
            CASE 
                WHEN t.TeamID = m.HomeTeamID THEN m.HomeScore
                WHEN t.TeamID = m.AwayTeamID THEN m.AwayScore
            END
        ) AS Goals
    FROM Teams t
    JOIN Matches m 
        ON t.TeamID = m.HomeTeamID 
        OR t.TeamID = m.AwayTeamID
    GROUP BY t.TeamName
)
SELECT 
    TeamName,
    Goals,
    RANK() OVER (ORDER BY Goals DESC) AS Ranking
FROM TeamGoals;
GO

-- ============================================================
-- CASE STATEMENT
-- ============================================================
SELECT 
    MatchID,
    HomeScore,
    AwayScore,
    CASE 
        WHEN HomeScore > AwayScore THEN 'Home Win'
        WHEN HomeScore < AwayScore THEN 'Away Win'
        ELSE 'Draw'
    END AS Result
FROM Matches;
GO

-- Classify matches by goals
SELECT 
    MatchID,
    HomeScore + AwayScore AS TotalGoals,
    CASE 
        WHEN HomeScore + AwayScore >= 5 THEN 'High Scoring Match'
        WHEN HomeScore + AwayScore BETWEEN 2 AND 4 THEN 'Medium Scoring Match'
        ELSE 'Low Scoring Match'
    END AS MatchType
FROM Matches;
GO
-- ============================================================
-- END OF SCRIPT
-- ============================================================
