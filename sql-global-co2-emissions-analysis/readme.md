# Global CO₂ Emissions Analysis

## 1. Project Overview
This project analyzes global carbon dioxide (CO₂) emissions data over time using SQL Server. The dataset is sourced from Maven Analytics and contains country-level and region-level emissions data including fossil fuel and land use contributions.

## 2. Objectives
1. Track global CO₂ emissions trends over time.  
2. Identify which countries emit the most CO₂ each year.  
3. Determine where the average person emits the most CO₂ annually.  
4. Examine changes in CO₂ emissions from fossil fuels and land use over time.  
5. Compare emissions by source (coal, oil, gas, cement, land use).  

## 3. Dataset
- Source: Maven Analytics – Global CO₂ Dataset  
- Key columns:  
  - `country`, `year`, `iso_code`  
  - `co2`, `co2_per_capita`  
  - `coal_co2`, `oil_co2`, `gas_co2`, `cement_co2`  
  - `land_use_change_co2` and related per-capita values  
- Notes: Some rows represent regions or groups (e.g., "World", "High-income countries"). Filtering by `iso_code` ensures proper country-level analysis.

## 4. Tools & Environment
- **Database:** Microsoft SQL Server  
- **IDE:** SQL Server Management Studio (SSMS)  
- **Data Source:** Maven Analytics – Global CO₂ dataset  

## 5. Key Learnings
- Global CO₂ emissions are rising, primarily driven by fossil fuels.  
- Land-use change emissions fluctuate but remain significant.  
- Industrialized countries and regions have higher per-capita emissions.  
- Policy-relevant insights can be drawn by comparing emissions by source (coal, oil, gas, cement, land use).

## 6. Next Steps
- Prepare cleaned country-level dataset for BI visualizations.  
- Analyze trends for specific regions or income groups.  
- Investigate correlation between CO₂ emissions and GDP or population.  
- Forecast future emissions using SQL time-series aggregations.
