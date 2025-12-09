---===================================================================---
---QUALITY CHECK---
---check if PK is null or Duplicate---
select 
	set_id,
	count (*) as flag_flat
from lego.lego_sets
group by set_id
having set_id is null and count (*) >1
----check for unwanted spaces---
select name from lego.lego_sets where name != trim(name )
select theme from lego.lego_sets where name != trim(theme )
select subtheme from lego.lego_sets where name != trim(subtheme )
select themeGroup from lego.lego_sets where name != trim(themeGroup )
select category from lego.lego_sets where name != trim(category )
select bricksetURL from lego.lego_sets where name != trim(bricksetURL )
select Thumbnail_URL from lego.lego_sets where name != trim(Thumbnail_URL )
select Image_URL from lego.lego_sets where name != trim(Image_URL )
---check for invalid date---
select year from lego.lego_sets
where year > year(getdate () )
---===================================================================---

---Creating and inserting data into lego_sets table---
---Creating lego_sets_cleansed table---
IF OBJECT_ID('lego.lego_sets_cleansed', 'U') IS NOT NULL
    DROP TABLE lego.lego_sets_cleansed;
GO

CREATE TABLE lego.lego_sets_cleansed (
    Set_ID nvarchar(50) Primary key not null ,
	Set_name nvarchar(200),
	Year int ,
	Theme nvarchar(50),
	Sub_theme nvarchar(50),
	Theme_Group nvarchar(50),
	Category nvarchar(50),
	Pieces int,
	Minifigs int,
	Age_range_min int ,
	US_retail_price decimal (10,2),
	Brick_set_URL nvarchar(max),
	Thumbnail_URL nvarchar(max),
	Image_URL nvarchar(max)
);
GO
---Cleansing and inserting Data into cleansed table---
truncate table lego.lego_sets_cleansed
insert into lego.lego_sets_cleansed(
	Set_ID,
	Set_name,
	Year,
	Theme,
	Sub_theme,
	Theme_Group,
	Category,
	Pieces,
	Minifigs,
	Age_range_min,
	US_retail_price,
	Brick_set_URL,
	Thumbnail_URL,
	Image_URL
)
select 
	set_id as Set_ID,
	name as Set_name,
	year as Year,
	TRIM(theme) as Theme,
	Case 
		When TRIM(subtheme) is null then 'Others'
		Else TRIM(subtheme)
	End as Sub_theme,
	Isnull (TRIM(themegroup),'Others') as Theme_Group,
	TRIM(category) as Category,
	Coalesce (pieces,0) as Pieces,
	Coalesce (minifigs,0) as Minifigs,
	Coalesce (agerange_min,3) as Age_range_min,
	Case 
		When ISNUMERIC(us_retailprice) =1 then Cast (us_retailprice as decimal (10,2))
		Else 0 
	End as US_retail_price,
	TRIM(ISnull (bricksetURL,'N\A')) as Brick_set_URL,
	TRIM(Isnull(thumbnailURL,'N\A')) as Thumbnail_URL,
	TRIM(Isnull(imageURL,'N\A')) as Image_URL
from lego.lego_sets
;
