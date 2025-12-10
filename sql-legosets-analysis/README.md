# Lego Sets SQL Project

## Project Overview
This project analyzes LEGO set data using SQL. The dataset includes information about LEGO sets released over the years, their themes, number of pieces, retail prices, and reviews. The goal is to explore trends in LEGO products, pricing, and popularity using SQL queries.

## Objectives
1. Analyze trends in LEGO set releases over time, including number of sets and themes.  
2. Examine pricing trends relative to set size (number of pieces) and year of release.  
3. Explore the distribution of LEGO sets across different themes and categories.  
4. Practice SQL skills such as filtering, grouping, aggregating, and joining data tables.

## Dataset
- Source: Maven Analytics LEGO Sets dataset.  
- Contains columns such as:
  - `set_num`, `name`, `year`, `theme_id`, `theme_name`  
  - `num_parts`, `retail_price`, `review_score`, `review_count`  
  - `minifig_count`, `tags`

## Key Learnings
1. Learned how to query and aggregate set release information by year and theme.  
2. Explored correlations between set size, price, and popularity.  
3. Practiced analyzing distribution patterns across LEGO themes and categories.  
4. Gained experience in filtering, grouping, and summarizing large datasets in SQL.  
5. Prepared data insights for further visualization or BI analysis.

## SQL Analysis Examples
1. Number of LEGO sets released per year:
```sql
SELECT year, COUNT(set_num) AS total_sets
FROM LegoSets
GROUP BY year
ORDER BY year;

