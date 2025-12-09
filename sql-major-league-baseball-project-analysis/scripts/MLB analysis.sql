-- PART I: SCHOOL ANALYSIS
-- 1. View the schools and school details tables
select * from dbo.schools;

-- 2. In each decade, how many schools were there that produced players?
select 
	Floor((yearID/10)*10) as Decade,
	Count(schoolID) as Totalschool
from dbo.schools
group by schoolID,Floor((yearID/10)*10)
having count(playerid) > 0
order by Floor((yearID/10)*10) asc;

-- 3. What are the names of the top 5 schools that produced the most players?
select top 5
	schoolID,
	count(playerid) as totalplayer
from dbo.schools
group by schoolID
order by count(playerid) desc;

-- 4. For each decade, what were the names of the top 3 schools that produced the most players?
With cte1 as 
	(select 
		Floor((yearID/10)*10) as Decade,
		SchoolID,
		Count(playerID) as Totalplayers
	from dbo.schools
	group by Floor((yearID/10)*10),schoolid
	),
	cte2 as 
		(Select *,
			row_number () over (partition by decade order by totalplayers desc) as School_ranking
		From cte1 )
Select * from cte2 where School_ranking in (1,2,3) order by decade;

-- PART II: SALARY ANALYSIS
-- 1. View the salaries table
select * from dbo.salaries;

-- 2. Return the top 20% of teams in terms of average annual spending
With 
cte1 as 
		(select 
			yearid,
			teamid,
			avg(salary) as anual_salary
		from dbo.salaries
		group by yearid,teamid)
,cte2 as 
		(select
			yearid,
			teamid,
			anual_salary,
			percent_rank () over (partition by yearid order by anual_salary desc) as Topsalary 
		from cte1)
Select
	yearid,
	teamid,
	anual_salary 
from cte2 
where Topsalary >= 0.8
order by yearid

-- 3. For each team, show the cumulative sum of spending over the years
With cte1 as 
	(Select 
		yearid,
		teamID,
		Sum(salary) as totalspend
	From dbo.salaries
	Group by yearID,teamid)
Select
		*,
		Sum(totalspend) Over (Partition by teamid Order by yearid asc Rows between unbounded preceding and current row) as Cumulation_over_years 
From cte1;

-- 4. Return the first year that each team's cumulative spending surpassed 1 billion
With cte1 as 
	(Select 
		yearid,
		teamID,
		Sum(salary) as totalspend
	From dbo.salaries
	Group by yearID,teamid)
	,cte2 as
	(Select
		*,
		Sum(totalspend) Over (Partition by teamid Order by yearid asc Rows between unbounded preceding and current row) as Cumulation_over_years 
	from cte1)
	,cte3 as 
	(Select
		*,
		Row_number () over (partition by teamid order by yearid,Cumulation_over_years desc) as rn
	From cte2 
	Where Cumulation_over_years >= 1000000000)
Select
	yearid,teamid,Cumulation_over_years
From cte3 
Where rn =1
Order by yearid

-- PART III: PLAYER CAREER ANALYSIS
-- 1. View the players table and find the number of players in the table
SELECT COUNT(playerID) FROM dbo.players;
SELECT COUNT(DISTINCT playerID) FROM dbo.players;

-- 2. For each player, calculate their age at their first game, their last game, and their career length (all in years). Sort from longest career to shortest career.
WITH T1 AS (SELECT playerID, birthYear, birthMonth, birthDay, nameGiven, debut, finalGame,
				CAST(DATEFROMPARTS(birthYear, birthMonth, birthDay)AS DATE) AS birth_day
			FROM dbo.players)

SELECT playerID, nameGiven, birth_day, debut, finalGame,
		DATEDIFF(YEAR, birth_day, debut) AS starting_age,
		DATEDIFF(YEAR, birth_day, finalGame) AS finish_age,
		DATEDIFF(YEAR, debut, finalGame) AS career_length
FROM T1
ORDER BY career_length DESC;

-- 3. What team did each player play on for their starting and ending years?
SELECT pl.nameGiven, pl.debut, pl.finalGame,
		sa.yearID, sa.teamID, se.yearID, se.teamID  
FROM dbo.players AS pl JOIN dbo.salaries AS sa
							ON pl.playerID = sa.playerID
							AND YEAR(pl.debut) = sa.yearID
							JOIN dbo.salaries AS se
							ON pl.playerID = se.playerID
							AND YEAR(pl.finalGame) = se.yearID;

-- 4. How many players started and ended on the same team and also played for over a decade?
SELECT pl.nameGiven, pl.debut, pl.finalGame,
		sa.yearID AS starting_year, sa.teamID AS starting_team, se.yearID AS ending_year, se.teamID AS ending_team,  se.yearID - sa.yearID AS total_years
FROM dbo.players AS pl JOIN dbo.salaries AS sa
							ON pl.playerID = sa.playerID
							AND YEAR(pl.debut) = sa.yearID
							JOIN dbo.salaries AS se
							ON pl.playerID = se.playerID
							AND YEAR(pl.finalGame) = se.yearID
WHERE sa.teamID = se.teamID AND se.yearID - sa.yearID > 10;

-- PART IV: PLAYER COMPARISON ANALYSIS
-- 1. View the players table
select * from dbo.players;

-- 2. Which players have the same birthday?
WITH T1 AS (SELECT nameGiven, CAST(DATEFROMPARTS(birthYear, birthMonth, birthDay)AS DATE) AS birth_day
			FROM dbo.players)

SELECT birth_day, STRING_AGG(CAST(nameGiven AS VARCHAR(MAX)), ', ') AS concatenated_player_names, COUNT(nameGiven) AS total_people_birth
FROM T1
WHERE birth_day IS NOT NULL
GROUP BY birth_day
HAVING COUNT(nameGiven) > 1
ORDER BY birth_day

-- 3. Create a summary table that shows for each team, what percent of players bat right, left and both
With cte as (
	select
	 s.teamID,
	 COUNT(p.playerID) as totalplayers,
	 SUM(Case When p.bats = 'L' Then 1 ELse 0 End) as Bats_left_players,
	 SUM(Case When p.bats = 'R' Then 1 Else 0 End) as Bats_right_players,
	 SUM(Case When p.bats = 'B' Then 1 Else 0 End) as Bats_both_players
	from dbo.players as p 
	left join dbo.salaries as s
	on p.playerID = s.playerid
	group by s.teamID)
Select 
	teamid,
	Bats_left_players,
	ROUND((Cast(Bats_left_players as float)/Nullif(totalplayers,0))*100,2) as bats_left_rate,
	Bats_right_players,
	ROUND((Cast(Bats_right_players as float)/Nullif(totalplayers,0))*100,2) as bats_right_rate,
	Bats_both_players,
	ROUND((Cast(Bats_both_players as float)/Nullif(totalplayers,0))*100,2) as bats_both_rate
From cte ;

-- 4. How have average height and weight at debut game changed over the years, and what's the decade-over-decade difference?
With Cte as (
	select 
		year(debut) as debut_year,
		avg(weight) as avg_weight,
		avg(height) as avg_height
	from dbo.players
	where debut is not null
	group by year(debut)
	)
Select *,--changer over years
	avg_weight-lag(avg_weight) over(order by debut_year) as weight_change,
	avg_height-lag(avg_height) over(order by debut_year) as height_change
from cte;
			-------------------
With Cte1 as (
	select 
		Floor((year(debut)/10)*10) as debut_decade,
		avg(weight) as avg_weight,
		avg(height) as avg_height
	from dbo.players
	where debut is not null
	group by Floor((year(debut)/10)*10)
	)
Select *,--changer over decades
	avg_weight-lag(avg_weight) over(order by debut_decade) as weight_change,
	avg_height-lag(avg_height) over(order by debut_decade) as height_change
from cte1

