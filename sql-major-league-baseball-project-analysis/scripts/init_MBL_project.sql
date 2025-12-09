USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'MLBProject')
BEGIN
    ALTER DATABASE MLBProject SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE MLBProject;
END;
GO

-- Create the 'MLBProject' database
CREATE DATABASE MLBProject;
GO

USE MLBProject;
GO
