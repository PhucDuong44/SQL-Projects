USE master;
GO

-- Drop and recreate the 'Movie' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Movie')
BEGIN
    ALTER DATABASE Movie SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Movie;
END;
GO

-- Create the 'Movie' database
CREATE DATABASE Movie;
GO

USE Movie;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

