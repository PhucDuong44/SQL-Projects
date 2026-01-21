/*
===============================================================================
DDL Script: Create Gold Tables
=============================================================================== */
        --- Create Dimension Tables
IF OBJECT_ID('gold.dim_person', 'U') IS NOT NULL
    DROP TABLE gold.dim_person;
GO
CREATE TABLE gold.dim_person (
    person_id int primary key not null,
    name nvarchar(255));
GO


IF OBJECT_ID('gold.dim_genre', 'U') IS NOT NULL
    DROP TABLE gold.dim_genre;
GO
CREATE TABLE gold.dim_genre (
    genre_id int primary key not null,
    genre_name nvarchar(100));
GO


IF OBJECT_ID('gold.dim_job', 'U') IS NOT NULL
    DROP TABLE gold.dim_job;
GO
CREATE TABLE gold.dim_job (
    job_key int primary key identity(1,1) not null,
    job_name nvarchar(100) unique);
GO


IF OBJECT_ID('gold.dim_movie', 'U') IS NOT NULL
    DROP TABLE gold.dim_movie;
GO
CREATE TABLE gold.dim_movie (
    movie_id int primary key not null,
    title nvarchar(500),
    language nvarchar(10),
    collection_name nvarchar(200));
GO  


IF OBJECT_ID('gold.dim_company', 'U') IS NOT NULL
    DROP TABLE gold.dim_company;
GO
CREATE TABLE gold.dim_company (
    company_id int primary key not null,
    company_name nvarchar(500));
GO  


        --- Create Fact tables
IF OBJECT_ID('gold.fact_movie', 'U') IS NOT NULL
    DROP TABLE gold.fact_movie;
GO
CREATE TABLE gold.fact_movie (
    movie_id int primary key not null,
    release_date date,
    budget decimal(18,2),
    revenue decimal(18,2),
    profit decimal(18,2),
    vote_count int,
    vote_average decimal(10,3),
    popularity decimal(10,3),
    runtime int);
GO



IF OBJECT_ID('gold.fact_movie_casts', 'U') IS NOT NULL
    DROP TABLE gold.fact_movie_casts;
GO
CREATE TABLE gold.fact_movie_casts (
    movie_id int not null,
    person_id int not null,
    primary key (movie_id, person_id));
GO


IF OBJECT_ID('gold.fact_movie_crews', 'U') IS NOT NULL
    DROP TABLE gold.fact_movie_crews;
GO
CREATE TABLE gold.fact_movie_crews (
    movie_id int not null,
    person_id int not null,
    job_key int not null,
    primary key (movie_id, person_id, job_key));
GO