/*
===============================================================================
Create Views for reports: 
	_ movie_genres 
	_ movie_casts
	_ movie_crews
	_ movie_performance
=============================================================================== */

--gold.view_movie_genres
IF OBJECT_ID ('gold.view_movie_genres','V')	IS NOT NULL
	DROP VIEW gold.view_movie_genres;
GO
CREATE OR ALTER VIEW gold.view_movie_genres AS
SELECT 
	fm.movie_id,
	dm.title,
	fm.release_date,
	mg.genre_id,
	dg.genre_name,
	fm.budget,
	fm.revenue,
	fm.profit,
	fm.vote_average,
	fm.popularity
FROM gold.fact_movie as fm
JOIN gold.dim_movie as dm
ON fm.movie_id=dm.movie_id
JOIN silver.movie_genres as mg
ON fm.movie_id=mg.movie_id
JOIN gold.dim_genre as dg
ON mg.genre_id = dg.genre_id

			---TASK--- 
	--View gold.view_movie_genres
	select * from gold.view_movie_genres
	--Top 5 average revenue
	select TOP 5
		genre_id,
		genre_name,
		ROUND(CAST(AVG(revenue) as float),2) as avg_revenue
	from gold.view_movie_genres
	group by genre_id,genre_name
	order by avg_revenue DESC
	--Top 5 highest rating
	select TOP 5
		genre_id,
		genre_name,
		ROUND(CAST(AVG(vote_average) as float),2) as avg_rating
	from gold.view_movie_genres
	group by genre_id, genre_name


--gold.view_movie_crews
IF OBJECT_ID ('gold.view_movie_crews','V') IS NOT NULL
	DROP VIEW gold.view_movie_crews;
GO
CREATE OR ALTER VIEW gold.view_movie_crews AS
SELECT 
	fmc.movie_id,
	dm.title,
	fm.release_date,
	fmc.person_id,
	dp.name,
	fmc.job_key,
	dj.job_name as job_name,
	fm.revenue,
	fm.profit,
	fm.vote_average,
	fm.popularity
FROM gold.fact_movie_crews as fmc
JOIN gold.dim_movie as dm
ON fmc.movie_id=dm.movie_id
JOIN gold.fact_movie as fm
ON fmc.movie_id=fm.movie_id
JOIN gold.dim_job as dj
ON fmc.job_key = dj.job_key
JOIN gold.dim_person as dp
ON fmc.person_id = dp.person_id

			---TASK---
		--View gold.view_movie_crews
		select * from gold.view_movie_crews
		--Top 10 Director with highest avg revenue
		select TOP 10
			person_id,
			name,
			ROUND(CAST(AVG(revenue) as float),2) as avg_revenue,
			ROUND(CAST(AVG(profit) as float),2) as avg_prdfit
		from gold.view_movie_crews
		where job_name='DIRECTOR'
		group by person_id,name
		having count(distinct movie_id) >=3
		order by avg_revenue DESC
		--
			select TOP 10
				job_key,
				job_name,
				AVG(vote_average) as avg_rating
			from gold.view_movie_crews
			group by job_key,job_name
			order by avg_rating DESC


--gold.view_movie_casts
IF OBJECT_ID ('gold.view_movie_casts','V') IS NOT NULL
	DROP VIEW gold.view_movie_casts;
GO
CREATE OR ALTER VIEW gold.view_movie_casts AS
SELECT
	mc.movie_id,
	dm.title,
	fm.release_date,
	mc.person_id,
	dp.name,
	fm.revenue,
	fm.profit,
	fm.vote_average,
	fm.popularity
FROM gold.fact_movie_casts as mc 
JOIN gold.dim_movie as dm
ON mc.movie_id = dm.movie_id
JOIN gold.fact_movie as fm
ON mc.movie_id = fm.movie_id
JOIN gold.dim_person as dp
ON mc.person_id = dp.person_id

			---TASK---
			--View gold.view_movie_casts
			select * from gold.view_movie_casts
			--
			select TOP 10
				person_id,
				name,
				count(distinct movie_id) as total_movies
			from gold.view_movie_casts
			group by person_id,name
			order by total_movies desc
			--
			select 
				person_id,
				name,
				count (distinct movie_id) as total_movies,
				ROUND(CAST(AVG(vote_average) as float),2) as avg_rating
			from gold.view_movie_casts
			group by person_id,name
			having count (distinct movie_id) >=5
			order by avg_rating desc


-- gold.view_movie_performance
IF OBJECT_ID ('gold.view_movie_performance','V') IS NOT NULL
	DROP VIEW gold.view_movie_performance;
GO
CREATE OR ALTER VIEW gold.view_movie_performance AS
SELECT 
	fm.movie_id,
	dm.title,
	fm.release_date,
	FLOOR(year(release_date)/10)*10 as release_decade,
	dm.language,
	dm.collection_name,
	fm.budget,
	fm.revenue,
	fm.profit,
	fm.vote_average,
	fm.vote_count,
	fm.popularity,
	fm.runtime
FROM gold.fact_movie as fm
LEFT JOIN gold.dim_movie as dm
ON fm.movie_id = dm.movie_id

			---TASK---
			--View gold.view_movie_performance
			select * from gold.view_movie_performance	
			--Revenue by decade
			select 
				release_decade as decade,
				SUM(revenue) as total_revenue
			from gold.view_movie_performance
			where release_decade is not null
			group by release_decade
			order by release_decade 
			--Revenue+Profit by Franchise 
			select
				collection_name,
				SUM(revenue) as total_revenue,
				SUM(profit) as total_profit,
				ROUND(CAST(AVG(profit/budget) as float),2) as avg_ROI
			from gold.view_movie_performance
			where collection_name is not null and budget !=0
			group by collection_name
			order by total_revenue desc , total_profit desc

