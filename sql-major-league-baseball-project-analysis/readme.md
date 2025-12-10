# MLB SQL Project

## Project Overview
This project analyzes Major League Baseball (MLB) player data using SQL. The dataset includes information about players' career spans, salaries, ages, and performance metrics. The goal is to extract insights on career progression, salary trends, and player demographics using SQL queries.

## Objectives
1. Analyze player career information such as debut age, retirement age, and career length.  
2. Examine salary trends across different seasons and player positions.  
3. Explore player performance metrics in relation to age, position, and career progression.  
4. Practice SQL skills for filtering, grouping, aggregating, and summarizing large datasets.

## Dataset
- Source: Alice Zhao’s MLB SQL dataset on Udemy.  
- Contains player details including:
  - `playerID`, `nameFirst`, `nameLast`
  - `debut` and `finalGame`
  - `birthYear`, `birthMonth`, `birthDay`
  - `weight`, `height`, `bats`, `throws`
  - `salary`, `teamID`, `lgID`

## Key Learnings
1. Learned how to query and aggregate player career data, such as debut age, retirement age, and career length.  
2. Understood trends in player salaries over different seasons and how to analyze them.  
3. Practiced comparing player performance metrics with age, position, and career progression.  
4. Gained experience in filtering, grouping, and summarizing large datasets in SQL.  
5. Prepared data insights suitable for visualization and further analysis in BI tools.

## SQL Analysis Examples
1. Calculate average debut age per decade:
```sql
SELECT AVG(YEAR(debut) - birthYear) AS avg_debut_age
FROM Players
GROUP BY FLOOR(YEAR(debut)/10)*10;
