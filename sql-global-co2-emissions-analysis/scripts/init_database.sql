/*
=============================================================
Create Database and Schemas
=============================================================
*/
Use master
GO

If Exists (Select 1 From sys.databases Where name = 'CO2_Emissions')
Begin 
	Alter database CO2_Emissions Set Single_user With Rollback Immediate;
	Drop database CO2_Emissions 
End;
GO

Create Database CO2_Emissions;
GO
Create Schema GCE;
GO