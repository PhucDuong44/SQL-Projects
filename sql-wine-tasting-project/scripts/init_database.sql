use master
go
-- Drop and recreate the 'WineTasting' database
IF exists (Select 1 From sys.databases Where name = 'WineTasting')
Begin Alter DATABASE WineTasting SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	Drop Database WineTasting
End;
GO
---Create Database--
CREATE Database WineTasting;
GO

Use Database WineTasting;
GO

-- Create Schemas
CREATE SCHEMA wine;
GO
