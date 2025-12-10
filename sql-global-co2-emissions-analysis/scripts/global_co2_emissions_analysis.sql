---=========Global CO2 Emissions Analysis========---

--1.How have global emissions of carbon dioxide (CO2) changed over time?
--View GCE.global_co2_data table
Select * From GCE.global_co2_data
;
With CTE as 
	(Select 
		Year,
		SUM(co2) as TotalCO2
	From GCE.global_co2_data
	Group by Year)
Select 
	*,
	TotalCO2 - Lag(TotalCo2) Over(Order by year) as TotalCO2_change_over_year
From CTE;

--2.Who emits the most CO2 each year? 
With CTE as (
Select 
	Year,
	Country,
	co2,
	Row_number () Over (partition by year Order by co2 desc) as rn
From GCE.global_co2_data
Where co2 is not null and len(iso_code) =3
Group by year,country,co2)
Select 
	year,country,co2
From CTE
Where rn=1 --most CO2 emissions by country
;
With CTE1 as (
	Select 
		Year,
		Country,
		co2,
		Row_number () Over (partition by year Order by co2 desc) as rn
	From GCE.global_co2_data
	WHERE 
		(LEN(iso_code) <> 3
		Or iso_code IS NULL
		Or iso_code LIKE 'OWID_%'
		)
		And country not in ('World','High-income countries') 
	Group by year,country,co2
	)
Select 
	year,country,co2
From CTE1
Where rn=1 --most co2 emissions by region

--3.Where in the world does the average person emit the most carbon dioxide (CO2) each year?
WITH co2percapita AS (
    SELECT *
    FROM GCE.global_co2_data
    WHERE LEN(iso_code) = 3   --country only
)
SELECT 
    year,
    country,
    co2_per_capita
FROM (
    SELECT 
        year,
        country,
        co2_per_capita,
        ROW_NUMBER() OVER (PARTITION BY year ORDER BY co2_per_capita DESC) AS rn
    FROM co2percapita
    WHERE co2_per_capita IS NOT NULL
) t
WHERE rn = 1
ORDER BY year
;
WITH CTE AS (
    SELECT 
        year,
        country,
        co2_per_capita,
        ROW_NUMBER() OVER (PARTITION BY year ORDER BY co2_per_capita DESC) AS rn
    FROM GCE.global_co2_data
    WHERE LEN(iso_code) = 3 AND co2_per_capita IS NOT NULL
)
SELECT *
FROM CTE
WHERE rn <= 10; --Top 10 by every year

--4.How have global emissions of carbon dioxide (CO2) from fossil fuels and land use changed over time?
SELECT
    year,
    co2 AS fossil_fuel_co2,
    co2 - LAG(co2) OVER (ORDER BY year) AS fossil_change,
    co2_including_luc AS total_co2_with_land_use,
    co2_including_luc - LAG(co2_including_luc) OVER (ORDER BY year) AS total_change
FROM GCE.global_co2_data
WHERE country = 'World'
ORDER BY year;