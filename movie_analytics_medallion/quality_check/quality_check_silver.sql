/*
===============================================================================
Quality Checks Silver Layer 
===============================================================================
*/

-- Table silver.collection
select 
	collection_id,
	count(*)
from silver.collection
group by collection_id 
having count(*) >1 or collection_id is null;

-- Table silver.company
select 
	company_id,
	count(*)
from silver.company
group by company_id 
having count(*) >1 or company_id is null;

-- Table silver.movie_casts
select 
	movie_id,
	person_id,
	count(*)
from silver.movie_casts
group by movie_id, person_id
having count(*) >1 or person_id is null or movie_id is null;

select
	count(*) as orphan_person
from silver.movie_casts as c 
left join silver.person as p
on c.person_id = p.person_id
where p.person_id is null; -- tất cả casts đều có trong bảng person

select
	count(*) as orphan_movie
from silver.movie_casts as c 
left join silver.movie as m 
on c.movie_id = m.movie_id
where m.movie_id is null; --có 4324 cast không có phim ở bảng movie

SELECT 
    COUNT(*) * 1.0 / (SELECT COUNT(*) FROM silver.movie_casts)
FROM silver.movie_casts c
LEFT JOIN silver.movie m ON c.movie_id = m.movie_id
WHERE m.movie_id IS NULL; -- orphan_movie/total_movie ~ 0.77% ;

select 
	count(*) as empty_character
from silver.movie_casts
where character is null or LTRIM(RTRIM(character))='';

-- Table silver.movie_companies
select 
	movie_id,
	company_id,
	count(*)
from silver.movie_companies
group by movie_id, company_id
having count(*)>1 or movie_id is null or company_id is null;

-- Table silver.movie_crews
select 
	count(*)
from silver.movie_crews
where movie_id is null or person_id is null or job is null;

select 
	movie_id,person_id,job
from silver.movie_crews 
group by movie_id,person_id, job
having count(*) >1;

select COUNT(*) 
from silver.movie_crews
where job = '' OR department = '';

select
	count(*)
from silver.movie_crews as c
left join silver.person as p
on c.person_id = p.person_id 
where p.person_id is null	--tất cả crews đều có trong bảng person

select 
	count(*)
from silver.movie_crews as c
left join silver.movie as m
on c.movie_id=m.movie_id
where m.movie_id is null -- có 2909 crews không có phim ở bảng movie 

select distinct job from silver.movie_crews
select distinct department from silver.movie_crews
-- Table silver.movie_genres
select 
	count(*)
from silver.movie_genres
where genre_id is null or movie_id is null

select
	movie_id,
	genre_id,
	count(*)
from silver.movie_genres
group by movie_id,genre_id
having count(*) >1

--Table silver.person
select
	count(*)
from silver.person
where name !=TRIM(name)

select
	person_id,
	count(*)
from silver.person
group by person_id
having count(*) >1 or person_id is null

-- Table silver.movie
select * from silver.movie

select
	count(*)
from silver.movie
where budget<0 or revenue<0 or vote_count<0 or vote_average<0 or popularity<0

select
	movie_id,
	count(*)
from silver.movie
group by movie_id
having count(*)>1

select
	count(*)
from silver.movie
where release_date > getdate()

/*
QC Notes:
- Orphan movie references in movie_casts (~0.77%) and movie_crews are expected
  due to broader credit universe than movie dimension.
- NULL character and NULL department are acceptable by business definition.
- Silver layer enforces structural integrity, not full referential completeness.
*/