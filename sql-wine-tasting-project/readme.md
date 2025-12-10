# Wine Tasting Analysis

## 1. Project Overview
This project analyzes wine tasting data from Maven Analytics. The dataset contains information about wine reviews, including reviewer details, wine variety, country of origin, scores (points), and prices.

## 2. Objectives
1. Explore the distribution of wine points and prices.  
2. Determine whether wine scores (points) predict price and the strength of the correlation.  
3. Analyze reviewer-level trends: do reviewers specialize in certain regions or varieties?  
4. Examine wine descriptions to identify common terms in positive and negative reviews.  

## 3. Dataset
- Source: Maven Analytics – Wine Tasting Dataset  
- Key columns:  
  - `taster_name` – reviewer name  
  - `points` – wine score  
  - `price` – wine price  
  - `province`, `country` – wine origin  
  - `variety` – wine type  
  - `description` – text review of the wine  
- Notes: Some rows may have missing values (`NULL`). Filtering and cleaning may be required before analysis.

## 4. Tools & Environment
- **Database:** Microsoft SQL Server  
- **IDE:** SQL Server Management Studio (SSMS)  
- **Data Source:** Maven Analytics – Wine Tasting dataset  

## 5. Key Learnings
- Wine points and price are positively correlated; higher-rated wines tend to be more expensive.  
- Reviewers often specialize in specific regions or wine varieties.  
- Positive reviews frequently mention terms like "fruity", "oak", "sweet", "acid", while negative reviews highlight similar terms less frequently.  
- Text analysis of the `description` column provides insights into common wine characteristics associated with high and low scores.  

## 6. Next Steps
- Clean and normalize the dataset for advanced analysis.  
- Explore more descriptive statistics, e.g., average price by variety or province.  
- Combine with visualization tools (Power BI, Tableau) to create interactive dashboards.  
- Conduct deeper sentiment analysis on wine descriptions for richer insights.
