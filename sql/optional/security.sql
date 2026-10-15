-- Database-scoped, non-login demonstration. No server account or password is created.
USE FIFA2026;
GO
IF DATABASE_PRINCIPAL_ID(N'FIFAReaderRole') IS NULL CREATE ROLE FIFAReaderRole;
IF DATABASE_PRINCIPAL_ID(N'FIFAReaderDemo') IS NULL CREATE USER FIFAReaderDemo WITHOUT LOGIN;
ALTER ROLE FIFAReaderRole ADD MEMBER FIFAReaderDemo;
GRANT SELECT ON dbo.Teams TO FIFAReaderRole;
GO
EXECUTE AS USER=N'FIFAReaderDemo';
SELECT TeamName,GroupName FROM dbo.Teams ORDER BY TeamName;
SELECT HAS_PERMS_BY_NAME('dbo.Teams','OBJECT','SELECT') AS CanReadTeams,
       HAS_PERMS_BY_NAME('dbo.Tickets','OBJECT','SELECT') AS CanReadTickets;
REVERT;
GO
