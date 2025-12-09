USE MASTER
GO

IF EXISTS (SELECT 1 FROM SYS.DATABASES WHERE NAME = 'CRM_Oppoturnities')
BEGIN ALTER DATABASE CRM_Oppoturnities SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE CRM_Oppoturnities;
END;
GO
---Create Database--- 
CREATE DATABASE CRM_Oppoturnities;
GO

USE CRM_Oppoturnities;
GO
---Create Schemas---
CREATE SCHEMA crm;
GO

