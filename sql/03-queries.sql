SET NOCOUNT ON;
-- JOIN: teams, fixtures and stadiums through the reusable view.
SELECT * FROM dbo.vw_MatchDetails ORDER BY MatchDate, MatchTime;

-- Aggregate and rank every team, including teams with no fixtures.
WITH TeamGoals AS (
    SELECT t.TeamID, t.TeamName,
           COALESCE(SUM(CASE WHEN t.TeamID=m.HomeTeamID THEN m.HomeScore ELSE m.AwayScore END),0) AS Goals
    FROM dbo.Teams AS t
    LEFT JOIN dbo.Matches AS m ON t.TeamID=m.HomeTeamID OR t.TeamID=m.AwayTeamID
    GROUP BY t.TeamID,t.TeamName
)
SELECT TeamName,Goals,RANK() OVER (ORDER BY Goals DESC) AS Ranking
FROM TeamGoals ORDER BY Ranking,TeamName;

-- Compare a team's total against average TEAM totals (not goals per match).
WITH TeamGoals AS (
    SELECT t.TeamID,t.TeamName,
           COALESCE(SUM(CASE WHEN t.TeamID=m.HomeTeamID THEN m.HomeScore ELSE m.AwayScore END),0) AS Goals
    FROM dbo.Teams AS t
    LEFT JOIN dbo.Matches AS m ON t.TeamID=m.HomeTeamID OR t.TeamID=m.AwayTeamID
    GROUP BY t.TeamID,t.TeamName
)
SELECT TeamName,Goals FROM TeamGoals
WHERE Goals > (SELECT AVG(CAST(Goals AS DECIMAL(10,2))) FROM TeamGoals)
ORDER BY Goals DESC,TeamName;

-- SUBQUERY: teams that occur in either match role.
SELECT TeamName FROM dbo.Teams
WHERE TeamID IN (SELECT HomeTeamID FROM dbo.Matches UNION SELECT AwayTeamID FROM dbo.Matches)
ORDER BY TeamName;

-- CTE and CASE: classify the sample fixtures.
WITH MatchGoals AS (
    SELECT MatchID,HomeScore,AwayScore,HomeScore+AwayScore AS TotalGoals FROM dbo.Matches
)
SELECT *,CASE WHEN HomeScore>AwayScore THEN 'Home win'
              WHEN HomeScore<AwayScore THEN 'Away win' ELSE 'Draw' END AS Result,
       CASE WHEN TotalGoals>=5 THEN 'High scoring'
            WHEN TotalGoals>=2 THEN 'Medium scoring' ELSE 'Low scoring' END AS MatchType
FROM MatchGoals ORDER BY MatchID;

EXEC dbo.sp_GetMatchesByTeam @TeamID=1;
SELECT dbo.fn_TotalGoals(2) AS MatchTwoGoals;
GO
