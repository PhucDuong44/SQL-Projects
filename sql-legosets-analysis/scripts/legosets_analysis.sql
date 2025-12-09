---====================== SQL TASKS ==============================---

--- Task 1 : How many LEGO sets have been released since 1970? Is there a noticable trend?---
select
	year as year_release,
	count(*) as total_sets
from lego.lego_sets_cleansed
where year >=1970
group by year
order by year ---Trending by years

SELECT
    FLOOR(year / 10) * 10 AS decade,
    COUNT(*) AS totals_sets_in_decade
FROM lego.lego_sets_cleansed
WHERE year >= 1970
GROUP BY FLOOR(year / 10) * 10
ORDER BY FLOOR(year / 10) * 10 --Trending by decades

---Task 2 : Is there a relationship between the price of a set and its number of pieces?---
SELECT 
	Floor(Pieces / 100) *100 as Pieces_group,
	Round (Cast(Avg (us_retail_price) as float),2) as Avg_price
FROM lego.lego_sets_cleansed
Where US_retail_price != 0 and Pieces != 0
Group by FLOOR (Pieces / 100) *100
order by FLOOR (Pieces / 100) *100 
;
SELECT 
    (
     SUM(CAST(Pieces AS DECIMAL(18,2)) * CAST(US_retail_price AS DECIMAL(18,2))) 
     - (SUM(CAST(Pieces AS DECIMAL(18,2))) * SUM(CAST(US_retail_price AS DECIMAL(18,2))) / COUNT(*))
    )
    /
    (
     SQRT (
     SUM(CAST(POWER(Pieces,2) AS DECIMAL(18,2))) 
     - POWER(SUM(CAST(Pieces AS DECIMAL(18,2))),2)/COUNT(*)
     )
     *
     SQRT (
     SUM(CAST(POWER(US_retail_price,2) AS DECIMAL(18,2))) 
     - POWER(SUM(CAST(US_retail_price AS DECIMAL(18,2))),2)/COUNT(*)
     )
    ) AS Correlation
FROM lego.lego_sets_cleansed
WHERE US_retail_price > 0 AND Pieces > 0;

---Task 3 : Which has been the most popular theme in each decade?---
With Theme_count As(
Select
    Theme,
    Floor (year/10) *10 as decade,
    count (*) as theme_count
From lego.lego_sets_cleansed
Group by 
    Theme, 
    Floor (year/10) *10
)
    Select
        Decade,
        Theme,
        Theme_count
    From (
        Select 
        *,
        Row_number () Over (Partition by Decade Order by Theme_count desc ) as Ranking  
        from theme_count)t
    Where Ranking = 1 
    Order by Decade

---Task 4 : Are LEGO minifigures most closely tied to licensed sets?---
SELECT 
    Theme_type,
    Count (*) as Totalsets,
    Avg (minifigs) as Avg_figs,
    Sum (minifigs) as Sum_figs
FROM (
    Select
        CASE 
            WHEN Theme IN (
                'Harry Potter',
                'Avatar The Last Airbender',
                'Trolls World Tour',
                'Ghostbusters',
                'Stranger Things',
                'SpongeBob SquarePants',
                'The LEGO Movie 2',
                'The Powerpuff Girls',
                'The LEGO Batman Movie',
                'Disney',
                'The LEGO Ninjago Movie',
                'Minions: The Rise of Gru',
                'Ben 10: Alien Force',
                'Jurassic World',
                'Super Mario',
                'Prince of Persia',
                'Dimensions',
                'The Hobbit',
                'The Lord of the Rings',
                'Scooby-Doo',
                'The Simpsons',
                'DC Comics Super Heroes',
                'Marvel Super Heroes',
                'Pirates of the Caribbean',
                'The LEGO Movie',
                'Star Wars',
                'Batman',
                'The Lone Ranger',
                'Cars',
                'The Angry Birds Movie',
                'Overwatch',
                'Monkie Kid',
                'Mickey Mouse',
                'Spider-Man',
                'Teenage Mutant Ninja Turtles',
                'Minecraft',
                'Avatar',
                'Toy Story',
                'Indiana Jones',
                'DC Super Hero Girls'
            ) THEN 'Licensed'
            ELSE 'Non-Licensed'
        END AS Theme_Type,
        minifigs
    From lego.lego_sets_cleansed )t
Group by Theme_Type ---LEGO minifigures are more closely tied to licensed sets

