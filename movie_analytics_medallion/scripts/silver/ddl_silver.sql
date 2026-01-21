/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================*/
IF OBJECT_ID('silver.genre', 'U') IS NOT NULL
    DROP TABLE silver.genre;
GO
CREATE TABLE silver.genre (
    genre_id int primary key not null,
    genre_name nvarchar(100)
);
GO


IF OBJECT_ID('silver.movie_genres', 'U') IS NOT NULL
    DROP TABLE silver.movie_genres;
GO
CREATE TABLE silver.movie_genres (
    genre_id int not null,
    movie_id int not null,
    primary key(genre_id,movie_id)
);
GO


IF OBJECT_ID('silver.movie_casts', 'U') IS NOT NULL
    DROP TABLE silver.movie_casts;
GO
CREATE TABLE silver.movie_casts (
    movie_id INT NOT NULL,
    person_id INT NOT NULL,
    name NVARCHAR(200),
    character NVARCHAR(500),
    CONSTRAINT PK_movie_casts PRIMARY KEY (movie_id, person_id)
);


IF OBJECT_ID('silver.movie_crews', 'U') IS NOT NULL
    DROP TABLE silver.movie_crews;
GO
CREATE TABLE silver.movie_crews (
    movie_id int not null,
    person_id int not null,
    name nvarchar(200),
    job nvarchar(200) not null,
    department nvarchar(200),
    primary key (movie_id,person_id,job)
);
GO


IF OBJECT_ID('silver.movie', 'U') IS NOT NULL
    DROP TABLE silver.movie;
GO
CREATE TABLE silver.movie(
    movie_id int primary key not null,
    title nvarchar(500),
    release_date date,
    language nvarchar(10),
    budget decimal(18,2),
    revenue decimal(18,2),
    vote_count int,
    vote_average decimal(10,3),
    popularity decimal(10,3),
    runtime int,
    collection_id int null
);
GO


IF OBJECT_ID('silver.person', 'U') IS NOT NULL
    DROP TABLE silver.person;
GO
CREATE TABLE silver.person (
    person_id int primary key not null,
    name nvarchar(255)
);
GO


IF OBJECT_ID('silver.collection', 'U') IS NOT NULL
    DROP TABLE silver.collection;
GO
CREATE TABLE silver.collection (
    collection_id int primary key not null,
    collection_name nvarchar(200)
);
GO


IF OBJECT_ID('silver.movie_companies', 'U') IS NOT NULL
    DROP TABLE silver.movie_companies;
GO
CREATE TABLE silver.movie_companies (
    movie_id int not null,
    company_id int not null,
    primary key(movie_id,company_id)
);
GO


IF OBJECT_ID('silver.company', 'U') IS NOT NULL
    DROP TABLE silver.company;
GO
CREATE TABLE silver.company (
    company_id int primary key not null,
    company_name nvarchar(500)
);
GO

