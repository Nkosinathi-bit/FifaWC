:On Error exit
-- Supply BackupPath as a SQLCMD variable. The SQL Server service must be able
-- to write to the directory. This creates a copy-only backup and does not
-- format or initialise an existing backup file.
USE master;
GO
BACKUP DATABASE FIFA2026 TO DISK=N'$(BackupPath)'
WITH COPY_ONLY,CHECKSUM,STATS=10;
GO
