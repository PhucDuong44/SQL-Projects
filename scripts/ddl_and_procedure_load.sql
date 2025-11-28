/*
===============================================================================
Stored Procedure: Load Restaurant Orders
===============================================================================
Script Purpose:
    This script creates tables in the 'ro' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'ro' Tables
===============================================================================
*/
---Create Tables---
IF OBJECT_ID('ro.menu_items', 'U') IS NOT NULL
    DROP TABLE ro.menu_items;
GO
CREATE TABLE ro.menu_items (
    menu_item_id nvarchar(50) primary key not null ,
    item_name nvarchar(50),
    category nvarchar(50),
    price decimal(5,2)
);
GO

IF OBJECT_ID('ro.order_details', 'U') IS NOT NULL
    DROP TABLE ro.order_details;
GO
CREATE TABLE ro.order_details (
   order_details_id int primary key not null ,
   order_id int not null ,
   order_date date,
   order_time time ,
   item_id nvarchar(50)
);
GO
---=========================================================---
---Insert Data into Tables and Create Store Procedure---
Create or Alter Procedure ro.load_restaurant_orders as
Begin 
    Declare @Start_time datetime , @End_time datetime;
    Begin try
set @Start_time = getdate ();
Print '------------------------';
Print 'Truncating table: ro.menu_items';
Truncate table ro.menu_items;
Print 'Insert into table: ro.menu_items';
BULK INSERT ro.menu_items 
FROM 'C:\sql\sql restaurant orders project\datasets\menu_items.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
); 
set @End_time= getdate ();
Print 'Load duration:' + cast (datediff (second,@end_time,@start_time) as nvarchar)+ ' seconds';
Print '>>>>>';

set @Start_time= getdate ();
Print '------------------------';
Print 'Truncating table: ro.order_details';
Truncate table ro.order_details;
Print 'Insert into table: ro.order_details';
BULK INSERT ro.order_details 
FROM 'C:\sql\sql restaurant orders project\datasets\order_details.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
set @End_time= getdate ();
Print 'Load duration:' + cast (datediff (second,@end_time,@start_time) as nvarchar)+ ' seconds';
Print '>>>>>';
End try
Begin catch
   Print '============================';
   PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
	PRINT 'Error Message' + ERROR_MESSAGE();
	PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
	PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
    Print '============================';
End catch
End
---Use procedure---
Execute ro.load_restaurant_orders;