:On Error exit
:r sql/00-session-options.sql
USE FIFA2026;
GO
SET NOCOUNT ON;
PRINT 'FIFA WORLD CUP DATABASE / COURSEWORK SAMPLE';
PRINT 'Fictional fixtures and scores - not official tournament results.';
PRINT '';
SELECT CAST(HomeTeam AS VARCHAR(14)) AS HomeTeam,
       CAST(AwayTeam AS VARCHAR(14)) AS AwayTeam,
       CONVERT(CHAR(10),MatchDate,23) AS MatchDate,
       CAST(CONCAT(HomeScore,' - ',AwayScore) AS VARCHAR(7)) AS Score
FROM dbo.vw_MatchDetails ORDER BY MatchDate;
PRINT '';
PRINT 'Corrected country mapping';
SELECT CAST(t.TeamName AS VARCHAR(14)) AS Team,CAST(c.CountryName AS VARCHAR(14)) AS Country
FROM dbo.Teams t JOIN dbo.Countries c ON c.CountryID=t.CountryID
WHERE t.TeamName IN ('Brazil','Germany') ORDER BY t.TeamName;
GO
