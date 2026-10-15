:On Error exit
:r sql/00-session-options.sql
USE FIFA2026;
GO
SET NOCOUNT ON;
IF (SELECT COUNT(*) FROM dbo.Countries)<>15 THROW 52000,'Expected 15 countries.',1;
IF (SELECT COUNT(*) FROM dbo.Teams)<>12 THROW 52000,'Expected 12 teams.',1;
IF (SELECT COUNT(*) FROM dbo.Players)<>22 THROW 52000,'Expected 22 players.',1;
IF (SELECT COUNT(*) FROM dbo.Matches)<>11 THROW 52000,'Expected 11 matches.',1;
IF (SELECT COUNT(*) FROM dbo.Tickets)<>9 THROW 52000,'Expected 9 tickets.',1;
IF EXISTS (SELECT 1 FROM dbo.Teams t JOIN dbo.Countries c ON c.CountryID=t.CountryID WHERE t.TeamName IN ('Brazil','Germany') AND t.TeamName<>c.CountryName)
    THROW 52000,'Incorrect team/country mapping.',1;
IF (SELECT COUNT(*) FROM dbo.vw_MatchDetails)<>11 THROW 52000,'Incomplete match view.',1;
IF dbo.fn_TotalGoals(2)<>3 OR dbo.fn_TotalGoals(-1)<>0 THROW 52000,'Goal function failed.',1;
GO
BEGIN TRY
    INSERT dbo.Matches(MatchDate,MatchTime,Stage,HomeTeamID,AwayTeamID,HomeScore,AwayScore,StadiumID)
    VALUES('2030-01-01','12:00','Test',1,12,-1,0,1);
    THROW 52001,'Negative insert was accepted.',1;
END TRY
BEGIN CATCH
    IF ERROR_NUMBER()<>51002 THROW;
END CATCH;
BEGIN TRY
    UPDATE dbo.Matches SET AwayScore=-1 WHERE MatchID=1;
    THROW 52001,'Negative update was accepted.',1;
END TRY
BEGIN CATCH
    IF ERROR_NUMBER()<>51002 THROW;
END CATCH;
BEGIN TRY
    INSERT dbo.Matches(MatchDate,MatchTime,Stage,HomeTeamID,AwayTeamID,StadiumID)
    VALUES('2026-06-10','19:00','Test',2,1,1);
    THROW 52001,'Reversed duplicate fixture was accepted.',1;
END TRY
BEGIN CATCH
    IF ERROR_NUMBER() NOT IN (2601,2627) THROW;
END CATCH;
BEGIN TRY
    INSERT dbo.Matches(MatchDate,MatchTime,Stage,HomeTeamID,AwayTeamID,StadiumID)
    VALUES('2030-01-01','12:00','Test',1,1,1);
    THROW 52001,'A team was allowed to play itself.',1;
END TRY
BEGIN CATCH
    IF ERROR_NUMBER()<>547 THROW;
END CATCH;
BEGIN TRY
    INSERT dbo.Tickets(MatchID,FanName,SeatNumber) VALUES(1,'Demo duplicate','A1');
    THROW 52001,'Duplicate seat was accepted.',1;
END TRY
BEGIN CATCH
    IF ERROR_NUMBER() NOT IN (2601,2627) THROW;
END CATCH;
IF (SELECT COUNT(*) FROM dbo.Matches)<>11 OR EXISTS(SELECT 1 FROM dbo.Matches WHERE HomeScore<0 OR AwayScore<0)
    THROW 52000,'Validation changed the fixture data.',1;
IF (SELECT TeamName FROM dbo.Teams WHERE TeamID=1)<>'Brazil' THROW 52000,'Transaction demo was not rolled back.',1;
PRINT 'PASS: schema, seed mappings, views, functions, negative inserts/updates, duplicate fixtures and seats, and transaction rollback.';
GO
