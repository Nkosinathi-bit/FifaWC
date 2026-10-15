USE FIFA2026;
GO
SET XACT_ABORT ON;
-- Demonstrate a transaction without leaving renamed seed data behind.
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE dbo.Teams SET TeamName='Brazil (transaction demo)' WHERE TeamID=1;
    SELECT TeamID,TeamName FROM dbo.Teams WHERE TeamID=1;
    ROLLBACK TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE()<>0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
DECLARE @Name VARCHAR(100);
DECLARE TeamCursor CURSOR LOCAL FAST_FORWARD FOR SELECT TeamName FROM dbo.Teams ORDER BY TeamName;
OPEN TeamCursor;
FETCH NEXT FROM TeamCursor INTO @Name;
WHILE @@FETCH_STATUS=0
BEGIN
    PRINT 'Team: '+@Name;
    FETCH NEXT FROM TeamCursor INTO @Name;
END;
CLOSE TeamCursor;
DEALLOCATE TeamCursor;
GO
