/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
=============================================================================== 
*/
CREATE OR ALTER PROCEDURE silver.load_silver as
BEGIN 
SET NOCOUNT ON; 
	BEGIN TRY
		PRINT '================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '================================================';
	BEGIN TRAN;

	print 'Truncating table: silver.genre';
	TRUNCATE TABLE silver.genre ;
	print 'Insert into table: silver.genre';
	INSERT INTO silver.genre (
		genre_id,
		genre_name
	)
	SELECT 
		TRY_CAST(genres_id as int),
		genres_name
	FROM bronze.genres
;

	print 'Truncating table: silver.movie_genres';
	TRUNCATE TABLE silver.movie_genres;
	print 'Insert into table: silver.movie_genres';
	INSERT INTO silver.movie_genres (
		genre_id,
		movie_id
	)
	SELECT 
		TRY_CAST(genres_id as int),
		TRY_CAST(movie_id as int)
	FROM bronze.movie_genres
;

	print 'Truncating table: silver.movie_casts';
	TRUNCATE TABLE silver.movie_casts;
	print 'Insert into table: silver.movie_casts';
	INSERT INTO silver.movie_casts (
		movie_id,
		person_id,
		name,
		character
	)
	SELECT 
		movie_id,
		person_id,
		name,
		character
	FROM (
		SELECT
			TRY_CAST(movie_id as int) as movie_id,
			TRY_CAST(people_id as int) as person_id,
			TRIM(name) as name,	
			TRIM(character) as character,
			ROW_NUMBER () OVER (PARTITION BY movie_id,people_id ORDER BY name,character) rn
		FROM bronze.movie_casts )t
	WHERE rn=1 and movie_id is not null and person_id is not null
;

	print 'Truncating table: silver.movie_crews';
	TRUNCATE TABLE silver.movie_crews;
	print 'Insert into table: silver.movie_crews';
	INSERT INTO silver.movie_crews (
		movie_id,
		person_id,
		name,
		job,
		department
	)
	SELECT 
		TRY_CAST( movie_id as int),
		TRY_CAST( people_id as int),
		name,
		UPPER(TRIM(job)) as job,
		UPPER(TRIM(department)) as department
	FROM bronze.movie_crews
;

	print 'Truncating table: silver.person';
	TRUNCATE TABLE silver.person;
	print 'Insert into table: silver.person';
	INSERT INTO silver.person (
		person_id,
		name
	)
	SELECT
		TRY_CAST(people_id as int),
		name
	FROM bronze.people
;

	print 'Truncating table: silver.collection';
	TRUNCATE TABLE silver.collection;
	print 'Insert into table: silver.collection';
	INSERT INTO silver.collection (
		collection_id,
		collection_name
	)
	SELECT
	 TRY_CAST(collection_id as int),
	 collection_name
	FROM bronze.collection
;

	print 'Truncating table: silver.movie_companies';
	TRUNCATE TABLE silver.movie_companies;
	print 'Insert into table: silver.movie_companies';
	INSERT INTO silver.movie_companies (
		movie_id,
		company_id
	)
	SELECT
	 TRY_CAST(movie_id as int),
	 TRY_CAST(company_id as int)
	FROM bronze.movie_companies
;

	print 'Truncating table: silver.company';
	TRUNCATE TABLE silver.company;
	print 'Insert into table: silver.company';
	INSERT INTO silver.company (
		company_id,
		company_name
	)
	SELECT
	 TRY_CAST(company_id as int),
	 company_name
	FROM bronze.company
;


	print 'Truncating table: silver.movie';
	TRUNCATE TABLE silver.movie;
	print 'Insert into table: silver.movie';
	INSERT INTO silver.movie (
		movie_id,
		title,
		release_date,
		language,
		budget,
		revenue,
		vote_count,
		vote_average,
		popularity,
		runtime,
		collection_id
	)
	SELECT
		TRY_CAST(movie_id as int),
		title,
		TRY_CAST(NULLIF(release_date,'') as date),
		UPPER(language) as language,
		TRY_CONVERT(decimal(18,2),budget),
		TRY_CONVERT(decimal(18,2),revenue),
		TRY_CAST(vote_count as int),
		TRY_CONVERT(decimal(10,3),vote_average),
		TRY_CONVERT(decimal(10,3),popularity),
		TRY_CONVERT(int,runtime),
		TRY_CAST(collection_id as int)
	FROM bronze.movie_cleaned
	COMMIT;
	print 'Silver layer loaded successful';
	END TRY 

	BEGIN CATCH 
		IF @@TRANCOUNT>0
			ROLLBACK;
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER'
		PRINT 'Error Message:' + ERROR_MESSAGE();
		PRINT 'Error Message:' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message:' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '==========================================';
		THROW;
	END CATCH
END ;
--exec silver.load_silver