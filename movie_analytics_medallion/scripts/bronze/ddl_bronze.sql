/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================*/
IF OBJECT_ID('bronze.genres', 'U') IS NOT NULL
    DROP TABLE bronze.genres;
GO
CREATE TABLE bronze.genres (
    genres_id int primary key not null,
    genres_name nvarchar(max)
);
GO


IF OBJECT_ID('bronze.movie_genres', 'U') IS NOT NULL
    DROP TABLE bronze.movie_genres;
GO
CREATE TABLE bronze.movie_genres (
    genres_id int not null,
    movie_id int not null,
    primary key(genres_id,movie_id)
);
GO


IF OBJECT_ID('bronze.movie_casts', 'U') IS NOT NULL
    DROP TABLE bronze.movie_casts;
GO
CREATE TABLE bronze.movie_casts (
    movie_id INT NOT NULL,
    people_id INT NOT NULL,
    name NVARCHAR(200),
    character NVARCHAR(500),
    CONSTRAINT PK_movie_casts PRIMARY KEY (movie_id, people_id, name)
);


IF OBJECT_ID('bronze.movie_casts_stage') IS NOT NULL
    DROP TABLE bronze.movie_casts_stage;
CREATE TABLE bronze.movie_casts_stage (
    movie_id  INT,
    people_id INT,
    name      NVARCHAR(200),
    character NVARCHAR(500)
);


IF OBJECT_ID('bronze.movie_crews', 'U') IS NOT NULL
    DROP TABLE bronze.movie_crews;
GO
CREATE TABLE bronze.movie_crews (
    movie_id int not null,
    people_id int not null,
    name nvarchar(200),
    job nvarchar(200) not null,
    department nvarchar(200),
    primary key (movie_id,people_id,job)
);
GO


IF OBJECT_ID('bronze.movie_crews_stage', 'U') IS NOT NULL
    DROP TABLE bronze.movie_crews_stage;
GO
CREATE TABLE bronze.movie_crews_stage (
    movie_id  INT,
    people_id INT,
    name NVARCHAR(200),
    job NVARCHAR(200),
    department NVARCHAR(200)
);
GO


IF OBJECT_ID('bronze.movie_cleaned_stage', 'U') IS NOT NULL
    DROP TABLE bronze.movie_cleaned_stage;
GO
CREATE TABLE bronze.movie_cleaned_stage (
    movie_id        NVARCHAR(50),
    title           NVARCHAR(500),
    release_date    NVARCHAR(50),
    language        NVARCHAR(10),
    budget          NVARCHAR(50),
    revenue         NVARCHAR(50),
    vote_count      NVARCHAR(50),
    vote_average    NVARCHAR(50),
    popularity      NVARCHAR(50),
    runtime         NVARCHAR(50),
    collection_id   NVARCHAR(50)
);


IF OBJECT_ID('bronze.movie_cleaned', 'U') IS NOT NULL
    DROP TABLE bronze.movie_cleaned;
GO
CREATE TABLE bronze.movie_cleaned (
    movie_id int primary key not null,
    title nvarchar(500),
    release_date date,
    language nvarchar(10),
    budget float,
    revenue float,
    vote_count int,
    vote_average float,
    popularity float,
    runtime float,
    collection_id int null
);
GO


IF OBJECT_ID('bronze.people_stage', 'U') IS NOT NULL
    DROP TABLE bronze.people_stage;
GO
CREATE TABLE bronze.people_stage (
    people_id nvarchar(50),
    name nvarchar(500)
);
GO


IF OBJECT_ID('bronze.people', 'U') IS NOT NULL
    DROP TABLE bronze.people;
GO
CREATE TABLE bronze.people (
    people_id int primary key not null,
    name nvarchar(255)
);
GO


IF OBJECT_ID('bronze.collection', 'U') IS NOT NULL
    DROP TABLE bronze.collection;
GO
CREATE TABLE bronze.collection (
    collection_id int primary key not null,
    collection_name nvarchar(max)
);
GO


IF OBJECT_ID('bronze.movie_companies', 'U') IS NOT NULL
    DROP TABLE bronze.movie_companies;
GO
CREATE TABLE bronze.movie_companies (
    movie_id int not null,
    company_id int not null,
    primary key(movie_id,company_id)
);
GO


IF OBJECT_ID('bronze.company', 'U') IS NOT NULL
    DROP TABLE bronze.company;
GO
CREATE TABLE bronze.company (
    company_name nvarchar(max),
    company_id int primary key not null
);
GO
