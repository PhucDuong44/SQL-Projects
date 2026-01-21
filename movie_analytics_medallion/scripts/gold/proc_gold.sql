/*
===============================================================================
Stored Procedure: Load Gold Layer (Silver->Gold)
=============================================================================== */
CREATE OR ALTER PROCEDURE gold.load_gold as 
BEGIN
SET NOCOUNT ON;
	BEGIN TRY
	BEGIN TRAN;
	print'====================';
	print 'Loading Gold layer';
	print'====================';

--- Dim tables
	print'Truncating table: gold.dim_person';
	TRUNCATE TABLE gold.dim_person;
	print'Insert into table: gold.dim_person';
	INSERT INTO gold.dim_person (
		person_id,
		name)
	SELECT
		person_id,
		name
	FROM silver.person
;


	print 'Truncating table: gold.dim_job';
	TRUNCATE TABLE gold.dim_job;
	print 'Insert into table: gold.dim_job';
	INSERT INTO gold.dim_job(
		job_name)
	SELECT DISTINCT
		UPPER(TRIM(job))
	FROM silver.movie_crews
	WHERE job is not null
;

	
	print 'Truncating table: gold.dim_movie';
	TRUNCATE TABLE gold.dim_movie;
	print 'Insert into table: gold.dim_movie';
	INSERT INTO gold.dim_movie(
		movie_id,
		title,
		language,
		collection_name)
	SELECT 
		m.movie_id,
		m.title,
		m.language,
		c.collection_name
	FROM silver.movie as m
	left join silver.collection as c
	ON m.collection_id=c.collection_id
;


	print 'Truncating table: gold.dim_genre';
	TRUNCATE TABLE gold.dim_genre;
	print 'Insert into table: gold.dim_genre';
	INSERT INTO gold.dim_genre(
		genre_id,
		genre_name)
	SELECT 
		genre_id,
		genre_name
	FROM silver.genre
;


	print 'Truncating table: gold.dim_company';
	TRUNCATE TABLE gold.dim_company;
	print 'Insert into table: gold.dim_company';
	INSERT INTO gold.dim_company(
		company_id,
		company_name)
	SELECT
		company_id,
		company_name
	FROM silver.company
;


	
--- Fact tables	
	print 'Truncating table: gold.fact_movie';
	TRUNCATE TABLE gold.fact_movie;
	print 'Insert into table: gold.fact_movie';
	INSERT INTO gold.fact_movie(
		movie_id,
		release_date,
		budget,
		revenue,
		profit,
		vote_count,
		vote_average,
		popularity,
		runtime)
	SELECT
		movie_id,
		release_date,
		budget,
		revenue,
		COALESCE(revenue,0)-COALESCE(budget,0),
		vote_count,
		vote_average,
		popularity,
		runtime
	FROM silver.movie
;


	print 'Truncating table: gold.fact_movie_casts';
	TRUNCATE TABLE gold.fact_movie_casts;
	print 'Insert into table: gold.fact_movie_casts';
	INSERT INTO gold.fact_movie_casts(
		movie_id,
		person_id)
	SELECT 
		movie_id,
		person_id 
	FROM silver.movie_casts
	WHERE movie_id is not null and person_id is not null
;


	print 'Truncating table: gold.fact_movie_crews';
	TRUNCATE TABLE gold.fact_movie_crews;
	print 'Insert into table: gold.fact_movie_crews';
	INSERT INTO gold.fact_movie_crews (
		movie_id,
		person_id,
		job_key)
	SELECT
		c.movie_id,
		c.person_id,
		j.job_key
	FROM silver.movie_crews as c
	inner join gold.dim_job as j
	on j.job_name=c.job	
	WHERE c.movie_id is not null and c.person_id is not null
	COMMIT;
	print 'Gold layer loaded successful';
	END TRY 

	BEGIN CATCH 
		IF @@TRANCOUNT>0
		ROLLBACK;
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING GOLD LAYER'
		PRINT 'Error Message:' + ERROR_MESSAGE();
		PRINT 'Error Message:' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message:' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '==========================================';
		THROW;
	END CATCH
END ;

--- exec gold.load_gold