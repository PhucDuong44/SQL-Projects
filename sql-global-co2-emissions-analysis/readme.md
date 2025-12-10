# Global CO₂ Emissions Analysis Project

## 1. Project Overview

This project explores global carbon dioxide (CO₂) emissions using the **Global CO₂ dataset from Maven Analytics**.  

**Objectives:**
- Understand how global CO₂ emissions have changed over time.
- Identify the largest CO₂-emitting countries annually.
- Examine per-capita CO₂ emissions to see where the average person emits the most.
- Compare emissions from **fossil fuels** versus **land use changes**.

---

## 2. Dataset

**Table:** `GCE.global_co2_data`  
**Source:** Maven Analytics  

**Sample Columns:**
- `country` – Country or region name  
- `year` – Year of observation  
- `iso_code` – ISO code for the country (3 characters for most countries)  
- `co2` – CO₂ emissions from fossil fuels (million tonnes)  
- `co2_including_luc` – Total CO₂ emissions including land-use change  
- `co2_per_capita` – CO₂ emissions per person  
- `coal_co2`, `oil_co2`, `gas_co2`, `cement_co2` – Sector-specific emissions  
- `land_use_change_co2` – Emissions due to land use  
- `population`, `gdp` – Supporting socio-economic data  

**Note:** Some rows represent regions, income groups, or global totals (e.g., `World`, `European Union`, `High-income countries`) and not individual countries.

---

## 3. SQL Analysis

### Global Emissions Trend
```sql
SELECT year, co2 AS fossil_fuel_emissions, co2_including_luc AS total_emissions
FROM GCE.global_co2_data
WHERE country = 'World'
ORDER BY year;
WITH TopEmitters AS (
    SELECT 
        year,
        country,
        co2,
        ROW_NUMBER() OVER (PARTITION BY year ORDER BY co2 DESC) AS rn
    FROM GCE.global_co2_data
    WHERE LEN(iso_code) = 3 -- Only real countries
)
SELECT year, country, co2
FROM TopEmitters
WHERE rn = 1;
SELECT year, country, co2_per_capita
FROM GCE.global_co2_data
WHERE LEN(iso_code) = 3
ORDER BY year, co2_per_capita DESC;
SELECT year, SUM(coal_co2) AS coal, SUM(oil_co2) AS oil, SUM(gas_co2) AS gas, SUM(cement_co2) AS cement, SUM(land_use_change_co2) AS land_use
FROM GCE.global_co2_data
WHERE country = 'World'
GROUP BY year
ORDER BY year;

---


## 4. Tools & Environment
- **Database:** Microsoft SQL Server  
- **IDE:** SQL Server Management Studio (SSMS)  
- **Data Source:** Maven Analytics – Global CO₂ dataset  

---

## 5. Key Learnings
- **Global CO₂ emissions are rising**, primarily driven by fossil fuels.  
- Land-use change emissions fluctuate but remain significant.  
- Industrialized countries and regions have **higher per-capita emissions**.  
- Policy-relevant insights can be drawn by comparing emissions by source (coal, oil, gas, cement, land use).

---
