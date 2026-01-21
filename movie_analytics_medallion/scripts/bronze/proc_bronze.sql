/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, 
			@end_time DATETIME, 
			@batch_start_time DATETIME,		
			@batch_end_time DATETIME; 
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '================================================';


		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.genres';
		TRUNCATE TABLE bronze.genres;
		PRINT '>> Inserting Data Into: bronze.genres';
		BULK INSERT bronze.genres
		FROM 'C:\SQLDATA\movie\genres.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = '|',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',      
			DATAFILETYPE = 'char',  
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';


        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.movie_genres';
		TRUNCATE TABLE bronze.movie_genres;
		PRINT '>> Inserting Data Into: bronze.movie_genres';
		BULK INSERT bronze.movie_genres
		FROM 'C:\SQLDATA\movie\movie_genres.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = '|',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',      
			DATAFILETYPE = 'char',  
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';


        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.movie_casts_stage';
		TRUNCATE TABLE bronze.movie_casts_stage;
		PRINT '>> Inserting Data Into: bronze.movie_casts_stage';
		BULK INSERT bronze.movie_casts_stage
		FROM 'C:\SQLDATA\movie\movie_casts.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = '|',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Stage Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR);
		PRINT '>> -------------';


		SET @start_time = GETDATE();
        PRINT '>> Loading bronze.movie_casts';
        BEGIN TRY
            BEGIN TRAN;
            TRUNCATE TABLE bronze.movie_casts;
            INSERT INTO bronze.movie_casts (movie_id, people_id, name, character)
            SELECT
                movie_id,
                people_id,
                name,
                MAX(character) AS character
            FROM bronze.movie_casts_stage
            WHERE movie_id IS NOT NULL
              AND people_id IS NOT NULL
              AND name IS NOT NULL
              AND LTRIM(RTRIM(name)) <> ''
            GROUP BY movie_id, people_id, name;
            COMMIT;
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0 ROLLBACK;
            PRINT 'ERROR in bronze.movie_casts';
            THROW;
        END CATCH;
        SET @end_time = GETDATE();
        PRINT '>> Final Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR);
        PRINT '>> -------------';


		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.movie_crews_stage';
		TRUNCATE TABLE bronze.movie_crews_stage;
		PRINT '>> Inserting Data Into: bronze.movie_crews_stage';
		BULK INSERT bronze.movie_crews_stage
		FROM 'C:\SQLDATA\movie\movie_crews.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = '|',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Stage Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR);
		PRINT '>> -------------';

	
		SET @start_time = GETDATE();
        PRINT '>> Loading bronze.movie_crews';
        BEGIN TRY
            BEGIN TRAN;
            TRUNCATE TABLE bronze.movie_crews;
            INSERT INTO bronze.movie_crews (movie_id, people_id, name, job, department)
            SELECT
                movie_id,
                people_id,
                MAX(name) AS name,
                job,
                MAX(department) AS department
            FROM bronze.movie_crews_stage
            GROUP BY movie_id, people_id, job;
            COMMIT;
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0 ROLLBACK;
            PRINT 'ERROR in bronze.movie_crews';
            THROW;
        END CATCH;
        SET @end_time = GETDATE();
        PRINT '>> Final Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR);
        PRINT '>> -------------';


		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.movie_cleaned_stage';
		TRUNCATE TABLE bronze.movie_cleaned_stage;
		PRINT '>> Inserting Data Into: bronze.movie_cleaned_stage';
		BULK INSERT bronze.movie_cleaned_stage
		FROM 'C:\SQLDATA\movie\movie_cleaned.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = '|',
			ROWTERMINATOR = '0x0a',
			FIELDQUOTE = '"',
			CODEPAGE = '65001',
			DATAFILETYPE = 'char',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Stage Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR);
		PRINT '>> -------------';


		SET @start_time = GETDATE();
        PRINT '>> Loading bronze.movie_cleaned';
		BEGIN TRY
			BEGIN TRAN;
			TRUNCATE TABLE bronze.movie_cleaned;
			INSERT INTO bronze.movie_cleaned (
				movie_id, title, release_date, language,
				budget, revenue, vote_count, vote_average,
				popularity, runtime, collection_id
			)
			SELECT
				x.movie_id,
				s.title,
				x.release_date,
				s.language,
				x.budget,
				x.revenue,
				x.vote_count,
				x.vote_average,
				x.popularity,
				x.runtime,
				x.collection_id
			FROM bronze.movie_cleaned_stage s
			CROSS APPLY (
				SELECT
					TRY_CAST(s.movie_id AS INT)               AS movie_id,
					TRY_CAST(NULLIF(s.release_date,'') AS DATE) AS release_date,
					TRY_CONVERT(FLOAT, s.budget)              AS budget,
					TRY_CONVERT(FLOAT, s.revenue)             AS revenue,
					TRY_CAST(REPLACE(s.vote_count, ',', '') AS INT) AS vote_count,
					TRY_CONVERT(FLOAT, s.vote_average)        AS vote_average,
					TRY_CONVERT(FLOAT, s.popularity)          AS popularity,
					TRY_CONVERT(FLOAT, s.runtime)             AS runtime,
					TRY_CAST(NULLIF(s.collection_id,'') AS INT) AS collection_id
			) x
			WHERE x.movie_id IS NOT NULL;
			COMMIT;
		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0 ROLLBACK;
			THROW;
		END CATCH;
        SET @end_time = GETDATE();
        PRINT '>> Final Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR);
        PRINT '>> -------------';


		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.people_stage';
		TRUNCATE TABLE bronze.people_stage;
		PRINT '>> Inserting Data Into: bronze.people_stage';
		BULK INSERT bronze.people_stage
		FROM 'C:\SQLDATA\movie\people.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = '|',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',     
			DATAFILETYPE = 'char', 
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';


		SET @start_time = GETDATE();
        PRINT '>> Loading bronze.people';
        BEGIN TRY
            BEGIN TRAN;
            TRUNCATE TABLE bronze.people;
            INSERT INTO bronze.people (
				people_id,
				name
			)
            SELECT
                p_id,
                MAX(name) AS name
            FROM ( 
				SELECT
					TRY_CAST(people_id as INT) as p_id,
					name
				FROM bronze.people_stage)a
			WHERE p_id is not null
            GROUP BY p_id;
            COMMIT;
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0 ROLLBACK;
            PRINT 'ERROR in bronze.movie_crews';
            THROW;
        END CATCH;
        SET @end_time = GETDATE();
        PRINT '>> Final Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR);
        PRINT '>> -------------';


		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.collection';
		TRUNCATE TABLE bronze.collection;
		PRINT '>> Inserting Data Into: bronze.collection';
		BULK INSERT bronze.collection
		FROM 'C:\SQLDATA\movie\collection.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = '|',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',   
			DATAFILETYPE = 'char', 
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';


		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.movie_companies';
		TRUNCATE TABLE bronze.movie_companies;
		PRINT '>> Inserting Data Into: bronze.movie_companies';
		BULK INSERT bronze.movie_companies
		FROM 'C:\SQLDATA\movie\movie_companies.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = '|',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',      
			DATAFILETYPE = 'char',  
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

				SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.company';
		TRUNCATE TABLE bronze.company;
		PRINT '>> Inserting Data Into: bronze.company';
		BULK INSERT bronze.company
		FROM 'C:\SQLDATA\movie\company.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = '|',
			ROWTERMINATOR = '0x0a',
			CODEPAGE = '65001',      
			DATAFILETYPE = 'char',  
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';


		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message:' + ERROR_MESSAGE();
		PRINT 'Error Message:' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message:' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END

--exec bronze.load_bronze