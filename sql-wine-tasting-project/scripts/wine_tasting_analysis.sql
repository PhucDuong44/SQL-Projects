--===============Wine tasting analysis===================--
	--1.Which province has the highest average price? How about of those with at least 10 wines? --
--View the winemag_data table --
Select * From wine.winemag_data;
;
Select TOP 1 --- province has the highest avarage price 
	province,
	AVG(price) as AVG_price
From wine.Winemag_data
Where province is not null
Group by  province
Order by AVG(price) desc
;
With cte as (
	Select
		province,
		COUNT(title) as Totalwines,
		AVG(price) as AVG_price
	From wine.Winemag_data
	Where province is not null
	Group by province)
Select TOP 1 province,AVG_price From cte Where totalwines >= 10 --- province has the highest avg price (with at least 10 wines)

	--2.Does the number of points predict the price of the wine? If so, how strong is the correlation? --
SELECT
    ROUND((SUM(CAST(points AS FLOAT) * CAST(price AS FLOAT)) 
     - (SUM(CAST(points AS FLOAT)) * SUM(CAST(price AS FLOAT)) / COUNT(*)))
    / SQRT(
        (SUM(POWER(CAST(points AS FLOAT), 2)) - POWER(SUM(CAST(points AS FLOAT)), 2)/COUNT(*))
        *
        (SUM(POWER(CAST(price AS FLOAT), 2)) - POWER(SUM(CAST(price AS FLOAT)), 2)/COUNT(*))
    ),4) AS correlation_points_price ---Moderate correlation: 0.4126 indicates a moderate strength of association—not very weak, but not strong either.
FROM wine.Winemag_data
WHERE points IS NOT NULL AND price IS NOT NULL;

	--3.Dig into reviewer-level trends. Do reviewers tend to specialize in one or two provinces? Do they specialize in certain varieties? --
Select 
	taster_name,
	Count(*) as totalreviews,
	Count(distinct province) as totalprovince,
	Count(distinct variety) as totalvariety,
	Min(points) as Minpoints,
	Max(points) as Maxpoints,
	Avg(points) as AVG_points
From wine.winemag_data
Where taster_name is not null
Group by taster_name
;
Select 
	taster_name,
	province,
	variety,
	Count(*) as totalreviews_in_province,
	Count(*) *1.0 / SUM(Count(*)) Over (partition by taster_name) as percent_reviews
From wine.winemag_data
Where taster_name is not null and province is not null and variety is not null
Group by taster_name,province,variety
Order by province,Count(*) desc
;

	--4.Dig into the 'description' column. What are some of the most common terms used in positive reviews? Negative reviews? --
Select 
	SUM(CASE When description like '%fruity%' and Points <= 82 Then 1 Else 0 End) as negative_fruity,
	SUM(CASE When description like '%fruity%' and Points >=90 Then 1 Else 0 End) as positive_fruity,
	SUM(CASE When description like '%oak%' and Points <=82 Then 1 Else 0 End) as negative_oak,
	SUM(CASE When description like '%oak%' and Points >=90 Then 1 Else 0 End) as positive_oak,
	SUM(CASE When description like '%sweet%' and Points <=82 Then 1 Else 0 End) as negative_sweet,
	SUM(CASE When description like '%sweet%' and Points >=90 Then 1 Else 0 End) as positive_sweet,
	SUM(CASE When description like '%acid%' and Points <=82 Then 1 Else 0 End) as negative_acid,
	SUM(CASE When description like '%acid%' and Points >=90 Then 1 Else 0 End) as positive_acid,
	SUM(CASE When description like '%spice%' and Points <=82 Then 1 Else 0 End) as negative_spice,
	SUM(CASE When description like '%spice%' and Points >=90 Then 1 Else 0 End) as positive_spice,
	SUM(CASE When description like '%floral%' and Points <=82 Then 1 Else 0 End) as negative_floral,
	SUM(CASE When description like '%floral%' and Points >=90 Then 1 Else 0 End) as positive_floral,
	SUM(CASE WHEN description LIKE '%bitter%' AND Points <= 82 THEN 1 ELSE 0 END) AS negative_bitter,
    SUM(CASE WHEN description LIKE '%bitter%' AND Points >= 90 THEN 1 ELSE 0 END) AS positive_bitter,
    SUM(CASE WHEN description LIKE '%harsh%' AND Points <= 82 THEN 1 ELSE 0 END) AS negative_harsh,
    SUM(CASE WHEN description LIKE '%harsh%' AND Points >= 90 THEN 1 ELSE 0 END) AS positive_harsh
From wine.winemag_data
Where taster_name is not null
