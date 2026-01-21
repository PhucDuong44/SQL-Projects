/*
===============================================================================
Quality Checks Gold Layer 
===============================================================================
*/

-- DIM tables
		---dim.person
select
	person_id,
	count(*)
from gold.dim_person
group by person_id
having count(*)>1 or person_id is null

select 
	count(*)
from gold.dim_person
where name is null or trim(name)=''

		--- dim_genre
select
	genre_id,
	count(*)
from gold.dim_genre
group by genre_id
having count(*) >1 or genre_id is null

		--- dim_job
select  
	job_key,
	count(*)
from gold.dim_job
group by job_key
having count(*)>1 or job_key is null

select 
	count(*)
from gold.dim_job 
where job_name!=upper(job_name)

		--- dim_movie
select 
	movie_id,
	count(*)
from gold.dim_movie
group by movie_id
having count(*)>1 or movie_id is null

select 
	count(*)
from gold.dim_movie
where title is null or trim(title)=''

		--- dim_company 
select
	company_id,
	count(*)
from gold.dim_company
group by company_id
having count(*)>1 or company_id is null


-- FACT tables
		---fact_movie
select
	movie_id,
	count(*)
from gold.fact_movie
group by movie_id
having count(*)>1 or movie_id is null

select 
	count(*)
from gold.fact_movie
where release_date > getdate()

select count(*) from gold.fact_movie
where budget <0 or revenue <0 or vote_count <0 or vote_average <0 or popularity <0

select count(*) from gold.fact_movie
where profit != revenue-budget

select 
	count(*)
from gold.fact_movie as fm
left join gold.dim_movie as dm
on fm.movie_id = dm.movie_id
where dm.movie_id is null

		--- fact_movie_casts
select
	movie_id,
	person_id,
	count(*)
from gold.fact_movie_casts
group by movie_id, person_id
having count(*) >1 or movie_id is null or person_id is null

select 
	count(*)
from gold.fact_movie_casts as fmc
left join gold.dim_movie as dm
on fmc.movie_id=dm.movie_id
where dm.movie_id is null	--orphan movie

select 
	count(*)
from gold.fact_movie_casts as fmc
left join gold.dim_person as dp
on fmc.person_id =  dp.person_id
where dp.person_id is null		--orphan cast

		--- fact_movie_crews
select * from gold.fact_movie_crews
select
	movie_id,
	person_id,
	job_key,
	count(*)
from gold.fact_movie_crews
group by movie_id,person_id,job_key
having count(*) >1 or person_id is null or movie_id is null or job_key is null

select 
	count(*)
from gold.fact_movie_crews as fmc
left join gold.dim_movie as dm
on fmc.movie_id = dm.movie_id
where dm.movie_id is null		--orphan movie

select 
	count(*)
from gold.fact_movie_crews as fmc 
left join gold.dim_person as dp
on fmc.person_id = dp.person_id
where dp.person_id is null		--orphan crew

select
	count(*)
from gold.fact_movie_crews as fmc
left join gold.dim_job as dj
on fmc.job_key = dj.job_key
where dj.job_key is null		--orphan job 