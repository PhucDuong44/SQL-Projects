# Movie Data Warehouse Project

## 1. Project Overview

This project implements an **end-to-end Data Warehouse pipeline** for a Movie dataset using a **Medallion Architecture (Bronze → Silver → Gold)**. The goal is to transform raw, semi-structured movie data into **clean, analytics-ready dimensional models** and expose them through **reporting views** for business analysis.

The project focuses on:

* Data ingestion and standardization
* Data quality enforcement
* Dimensional modeling (Star Schema)
* Analytical views and business queries

---

## 2. Architecture Overview

### Medallion Architecture

* **Bronze Layer**
  Raw ingested data with minimal transformation. Handles schema alignment and basic type casting.

* **Silver Layer**
  Cleansed and standardized data:

  * Data type validation
  * Trimming and normalization (UPPER/TRIM)
  * Removal of invalid or corrupt records

* **Gold Layer**
  Analytics-ready layer:

  * Star schema (Dimensions & Facts)
  * Aggregation-friendly structure
  * Reporting views for analysis

---

## 3. Gold Layer Data Model

### Dimension Tables

* **dim_movie**
  Movie master data (title, language, collection/franchise)

* **dim_person**
  Actors and crew members

* **dim_genre**
  Movie genres

* **dim_company**
  Production companies

* **dim_job**
  Normalized crew job roles (DIRECTOR, PRODUCER, etc.)

### Fact Tables

* **fact_movie**
  Core movie performance metrics (budget, revenue, profit, ratings)

* **fact_movie_casts**
  Bridge table between movies and cast members

* **fact_movie_crews**
  Bridge table between movies, crew members, and job roles

---

## 4. ETL Strategy

### Load Strategy

* Full refresh using `TRUNCATE + INSERT`
* Single transaction per layer load to ensure atomicity
* Error handling with `TRY...CATCH` and rollback

### Data Standardization

* Text normalization using `UPPER(TRIM())`
* Null filtering for primary/foreign keys
* Derived metrics (profit = revenue - budget)

---

## 5. Data Quality Checks

Quality checks are executed after loading the Gold layer and include:

### Dimension Checks

* Primary key uniqueness
* Null key detection
* Empty or invalid text fields
* Standardization validation (e.g. job_name in uppercase)

### Fact Checks

* Duplicate fact records
* Orphan records (FK not found in dimensions)
* Invalid numeric values (negative budget, revenue, ratings)
* Derived metric validation (profit consistency)

These checks ensure **referential integrity and analytical correctness** before reporting.

---

## 6. Reporting Views

### 1. `gold.view_movie_genres`

Purpose: Analyze movie performance by genre.

Key Metrics:

* Revenue
* Profit
* Ratings
* Popularity

Example Analyses:

* Top genres by average revenue
* Top genres by average rating

---

### 2. `gold.view_movie_crews`

Purpose: Measure the impact of crew roles on movie performance.

Key Metrics:

* Revenue
* Profit
* Ratings

Example Analyses:

* Top directors by average revenue
* Average rating by job role

---

### 3. `gold.view_movie_casts`

Purpose: Analyze actor participation and success.

Key Metrics:

* Number of movies per actor
* Average movie rating per actor

Example Analyses:

* Most active actors
* Actors with highest average ratings (minimum movie threshold)

---

### 4. `gold.view_movie_performance`

Purpose: High-level movie and franchise performance analysis.

Key Metrics:

* Budget, revenue, profit
* ROI
* Popularity and ratings

Example Analyses:

* Revenue by decade
* Franchise-level revenue and profitability

---

## 7. Business Questions Answered

* Which genres generate the highest revenue on average?
* Which directors consistently produce high-grossing movies?
* Which actors appear most frequently and receive high ratings?
* How does movie performance change across decades?
* Which franchises deliver the highest ROI?

---

## 8. Tools & Technologies

* **SQL Server**
* **T-SQL (Stored Procedures, Views)**
* **Star Schema Modeling**
* **Medallion Architecture**

---

## 9. Key Takeaways

* Demonstrates a complete data engineering workflow
* Emphasizes data quality and correctness
* Separates transformation, modeling, and analytics concerns
* Suitable for BI tools, dashboards, or ad-hoc analysis

---

**Author:** Phuc Duong
**Project Type:** Data Engineering – SQL Data Warehouse
