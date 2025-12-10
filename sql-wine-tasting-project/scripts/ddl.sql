--Create and Insert Data into table--

IF Object_ID ('wine.winemag_data','U') is not null
	Drop table wine.winemag_data

Create Table wine.winemag_data
	(id nvarchar(max) not null,
	country nvarchar(50) null,
	description nvarchar(max) null,
	designation nvarchar(max) null,
	points nvarchar(max) null,
	price nvarchar(max) null,
	province nvarchar(max) null,
	region_1 nvarchar(max) null,
	region_2 nvarchar(max) null,
	taster_name nvarchar(max) null,
	taster_twitter_handle nvarchar(max) null,
	title nvarchar(max) null,
	variety nvarchar(max) null,
	winery nvarchar(max) null);
 GO

Truncate table wine.winemag_data
Bulk insert wine.winemag_data
From 'C:\Users\Phuc\SQL-Projects\sql-wine-tasting-project undone\winemag_data.csv'
With
(
	Firstrow = 2,
	Format ='csv',
	FieldTerminator = ',',
	Rowterminator = '0x0a',
	CODEPAGE = '65001',
	Fieldquote = '"',
	Tablock
);
--Use Table wine.m=winemag_data--
Select * From wine.winemag_data