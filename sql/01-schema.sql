-- Group 13 coursework: Nkosinathi Mathenjwa, Zane Vincent Botha,
-- and Tsakani Mawelela. Maintained portfolio version of the SQL submission.
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO
CREATE TABLE dbo.Countries (
    CountryID INT IDENTITY PRIMARY KEY,
    CountryName VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE dbo.Cities (
    CityID INT IDENTITY PRIMARY KEY,
    CityName VARCHAR(100) NOT NULL,
    CountryID INT NOT NULL REFERENCES dbo.Countries(CountryID),
    CONSTRAINT UQ_City_Country UNIQUE (CountryID, CityName)
);
CREATE TABLE dbo.Stadiums (
    StadiumID INT IDENTITY PRIMARY KEY,
    StadiumName VARCHAR(100) NOT NULL UNIQUE,
    Capacity INT NOT NULL CHECK (Capacity > 0),
    CityID INT NOT NULL REFERENCES dbo.Cities(CityID)
);
CREATE TABLE dbo.Teams (
    TeamID INT IDENTITY PRIMARY KEY,
    TeamName VARCHAR(100) NOT NULL UNIQUE,
    CountryID INT NOT NULL REFERENCES dbo.Countries(CountryID),
    GroupName CHAR(1) NOT NULL CHECK (GroupName BETWEEN 'A' AND 'F')
);
CREATE TABLE dbo.Players (
    PlayerID INT IDENTITY PRIMARY KEY,
    PlayerName VARCHAR(100) NOT NULL,
    Position VARCHAR(50) NOT NULL,
    TeamID INT NOT NULL REFERENCES dbo.Teams(TeamID)
);
CREATE TABLE dbo.Matches (
    MatchID INT IDENTITY PRIMARY KEY,
    MatchDate DATE NOT NULL,
    MatchTime TIME NOT NULL,
    Stage VARCHAR(50) NOT NULL,
    HomeTeamID INT NOT NULL REFERENCES dbo.Teams(TeamID),
    AwayTeamID INT NOT NULL REFERENCES dbo.Teams(TeamID),
    HomeScore INT NOT NULL DEFAULT 0,
    AwayScore INT NOT NULL DEFAULT 0,
    StadiumID INT NOT NULL REFERENCES dbo.Stadiums(StadiumID),
    TeamPairLow AS (CASE WHEN HomeTeamID < AwayTeamID THEN HomeTeamID ELSE AwayTeamID END) PERSISTED,
    TeamPairHigh AS (CASE WHEN HomeTeamID > AwayTeamID THEN HomeTeamID ELSE AwayTeamID END) PERSISTED,
    CONSTRAINT CK_Match_DifferentTeams CHECK (HomeTeamID <> AwayTeamID),
    CONSTRAINT UQ_Match_Pair_Date UNIQUE (TeamPairLow, TeamPairHigh, MatchDate)
);
CREATE TABLE dbo.Tickets (
    TicketID INT IDENTITY PRIMARY KEY,
    MatchID INT NOT NULL REFERENCES dbo.Matches(MatchID),
    FanName VARCHAR(100) NOT NULL,
    SeatNumber VARCHAR(20) NOT NULL,
    PurchaseDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT UQ_Ticket_Seat UNIQUE (MatchID, SeatNumber)
);
CREATE INDEX IX_Cities_Country ON dbo.Cities(CountryID);
CREATE INDEX IX_Stadiums_City ON dbo.Stadiums(CityID);
CREATE INDEX IX_Teams_Country ON dbo.Teams(CountryID);
CREATE INDEX IX_Players_Team ON dbo.Players(TeamID);
CREATE INDEX IX_Matches_Home ON dbo.Matches(HomeTeamID, MatchDate);
CREATE INDEX IX_Matches_Away ON dbo.Matches(AwayTeamID, MatchDate);
CREATE INDEX IX_Matches_Stadium ON dbo.Matches(StadiumID, MatchDate);
GO
CREATE VIEW dbo.vw_MatchDetails AS
SELECT m.MatchID, ht.TeamName AS HomeTeam, at.TeamName AS AwayTeam,
       m.MatchDate, m.MatchTime, m.Stage, m.HomeScore, m.AwayScore, s.StadiumName
FROM dbo.Matches AS m
JOIN dbo.Teams AS ht ON m.HomeTeamID = ht.TeamID
JOIN dbo.Teams AS at ON m.AwayTeamID = at.TeamID
JOIN dbo.Stadiums AS s ON m.StadiumID = s.StadiumID;
GO
CREATE PROCEDURE dbo.sp_GetMatchesByTeam @TeamID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT MatchID, MatchDate, MatchTime, Stage, HomeTeamID, AwayTeamID,
           HomeScore, AwayScore, StadiumID
    FROM dbo.Matches
    WHERE HomeTeamID = @TeamID OR AwayTeamID = @TeamID
    ORDER BY MatchDate, MatchTime, MatchID;
END;
GO
CREATE FUNCTION dbo.fn_TotalGoals (@MatchID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Total INT;
    SELECT @Total = HomeScore + AwayScore FROM dbo.Matches WHERE MatchID = @MatchID;
    RETURN ISNULL(@Total, 0);
END;
GO
-- Covers multi-row INSERT and UPDATE statements, including changes after seeding.
CREATE TRIGGER dbo.trg_ValidateScores ON dbo.Matches
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM inserted WHERE HomeScore < 0 OR AwayScore < 0)
        THROW 51002, 'Scores cannot be negative.', 1;
END;
GO
