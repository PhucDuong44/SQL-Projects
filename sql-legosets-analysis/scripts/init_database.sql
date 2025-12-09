----Create Database and Schema---

USE master;
GO

-- Drop and recreate the 'Legosets' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Legosets')
BEGIN
    ALTER DATABASE Legosets SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Legosets;
END;
GO
-- Create the 'Legosets' database
CREATE DATABASE Legosets;
GO
-- Create Schemas
CREATE SCHEMA lego;
GO

