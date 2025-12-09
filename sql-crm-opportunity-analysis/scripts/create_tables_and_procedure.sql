/* CREATE AND INSERT DATA INTO TABLES 
   CREATE STORED PROCEDURE*/
---====================================================---
---Create crm tables---
IF OBJECT_ID('crm.account', 'U') IS NOT NULL
    DROP TABLE crm.account;
GO

CREATE table crm.account (
    account nvarchar(100) null,
    sector nvarchar(50) null,
    year_established int null,
    revenue decimal (10,2) null,
    employees int null,
    office_location nvarchar (50) null,
    subsidiary_of nvarchar(50) null
);
GO

IF OBJECT_ID('crm.products', 'U') IS NOT NULL
    DROP TABLE crm.products;
GO

CREATE table crm.products (
    product nvarchar(50) null,
    series nvarchar (50) null,
    sales_price int null
);
GO

IF OBJECT_ID('crm.sales_pipeline', 'U') IS NOT NULL
    DROP TABLE crm.sales_pipeline;
GO

CREATE table crm.sales_pipeline (
    opportunity_id nvarchar(50) primary key not null,
    sales_agent nvarchar(50) null,
    product nvarchar(50) null,
    account nvarchar (50) null,
    deal_stage nvarchar(50) null,
    engage_date date null,
    close_date date null,
    close_value int null
);
GO

IF OBJECT_ID('crm.salesteams', 'U') IS NOT NULL
    DROP TABLE crm.salesteams;
GO

CREATE table crm.salesteams (
    sales_agent nvarchar(50) null,
    manager nvarchar(50) null,
    regional_office nvarchar(50) null
);
GO

---Insert date ino crm tables and Create Stored Procedure---
CREATE OR ALTER PROCEDURE crm.load_crm_tables AS
BEGIN 
    DECLARE @start_time date, @end_time date;
    BEGIN TRY
set @start_time = getdate ();
PRINT '================================';
PRINT 'Truncate table crm.accounts';
TRUNCATE TABLE crm.account
PRINT 'Insert into table crm.accounts';
PRINT '--------------------------------';
BULK INSERT crm.account
FROM 'C:\sql\sql-crm-oppoturnities-project\datasets\accounts.csv'
WITH (
    Firstrow = 2,
    Fieldterminator =',',
    Tablock
);
set @end_time = getdate();
PRINT 'Load duration: ' + cast (datediff (second,@start_time, @end_time) as nvarchar) +' seconds';
PRINT '>>>';

set @start_time = getdate ();
PRINT '================================';
PRINT 'Truncate table crm.products';
TRUNCATE TABLE crm.products
PRINT 'Insert into table crm.accounts';
PRINT '--------------------------------';
BULK INSERT crm.products
FROM 'C:\sql\sql-crm-oppoturnities-project\datasets\products.csv'
WITH (
    Firstrow = 2,
    Fieldterminator =',',
    Tablock
);
set @end_time = getdate();
PRINT 'Load duration: ' + cast (datediff (second,@start_time, @end_time) as nvarchar) +' seconds';
PRINT '>>>';

set @start_time = getdate ();
PRINT '================================';
PRINT 'Truncate table crm.sales_pipeline';
TRUNCATE TABLE crm.sales_pipeline
PRINT 'Insert into table crm.sales_pipeline';
PRINT '--------------------------------';
BULK INSERT crm.sales_pipeline
FROM 'C:\sql\sql-crm-oppoturnities-project\datasets\sales_pipeline.csv'
WITH (
    Firstrow = 2,
    Fieldterminator =',',
    Tablock
);
set @end_time = getdate();
PRINT 'Load duration: ' + cast (datediff (second,@start_time, @end_time) as nvarchar) +' seconds';
PRINT '>>>';

set @start_time = getdate ();
PRINT '================================';
PRINT 'Truncate table crm.salesteams';
TRUNCATE TABLE crm.salesteams
PRINT 'Insert into table crm.salesteams';
PRINT '--------------------------------';
BULK INSERT crm.salesteams
FROM 'C:\sql\sql-crm-oppoturnities-project\datasets\sales_teams.csv'
WITH (
    Firstrow = 2,
    Fieldterminator =',',
    Tablock
);
set @end_time = getdate();
PRINT 'Load duration: ' + cast (datediff (second,@start_time, @end_time) as nvarchar) +' seconds';
PRINT '>>>';
PRINT 'Loading CRM tables is completed';
    END TRY 
    BEGIN CATCH 
        PRINT 'ERROR OCCURED DURING LOADING CRM TABLES';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
    END CATCH 
END
---Use crm.load_crm_tables---
Execute crm.load_crm_tables
