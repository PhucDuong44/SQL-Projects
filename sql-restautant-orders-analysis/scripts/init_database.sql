/*====Create Database and Schemas==========
Script Purpose:
    This script creates a new database named 'RestaurantOrders' after checking if it already exists. 
    If the database exists, it is dropped and recreated.*/

USE master;
GO

-- Drop and recreate the 'RestaurantOrders' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'RestaurantOrders')
BEGIN
    ALTER DATABASE RestaurantOrders SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE RestaurantOrders;
END;
GO
-- Create the 'RestaurantOrders' database
CREATE DATABASE RestaurantOrders;
GO

USE RestaurantOrders;
GO

-- Create Schemas
CREATE SCHEMA ro;
GO
