:On Error exit
-- Run with sqlcmd from the repository root, or in SSMS SQLCMD mode.
-- This setup creates a new coursework database; it never replaces one.
USE master;
GO
IF DB_ID(N'FIFA2026') IS NOT NULL
    THROW 51000, 'FIFA2026 already exists. Setup stopped without changing it. Use a fresh development instance.', 1;
GO
CREATE DATABASE FIFA2026;
GO
USE FIFA2026;
GO
:r sql/01-schema.sql
:r sql/02-seed.sql
:r sql/03-queries.sql
