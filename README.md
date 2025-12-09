<<<<<<< HEAD
<<<<<<< HEAD
"# SQL Projects - Monorepo" 
=======
# sql-data-warehouse-project
# **Build Data Warehouse for Analytics and Business Insights**

This project uses **Microsoft SQL Server** to build a **Data Warehouse** from scratch, integrating data from **CRM and ERP sources**. The **ETL process** extracts raw data, performs **data cleansing and transformation**, and loads **structured data** into a star schema for business analytics.

---

## **Data Architecture**  
The data architecture follows the **Medallion Architecture** with **Bronze, Silver, and Gold layers**:  
<img width="1544" height="912" alt="data_architecture" src="https://github.com/user-attachments/assets/7beb8b08-0a3c-4e50-a05b-746b36b39979" />



1. **Bronze Layer**: Stores raw data **as-is** from the CRM and ERP sources. Data is ingested into SQL Server using **CSV files**.  
2. **Silver Layer**: Processes **data cleansing, standardization, and normalization** to enhance data quality and consistency.  
3. **Gold Layer**: Stores **business-ready** data, structured into a **star schema** for analytics and reporting.

---

## **Data Flow**  

<img width="1094" height="671" alt="data_flow" src="https://github.com/user-attachments/assets/d47c38f9-43ff-47ad-b7be-028c63ad4225" />

The data flow starts with **source systems (CRM & ERP)**, where raw data is collected and stored in the **Bronze Layer**. Next, in the **Silver Layer**, the data undergoes **cleansing, standardization, and integration** to remove inconsistencies. Finally, in the **Gold Layer**, transformed data is **modeled** into fact and dimension tables, making it **ready for business intelligence and reporting**.

### **Key Steps in the Data Flow:**  
1. **Extract**: Data is pulled from CRM and ERP in **CSV format**.  
2. **Transform**: The data undergoes **deduplication, formatting, and standardization**.  
3. **Load**: The cleaned data is stored in **fact and dimension tables** for efficient querying.  

---
## **Key Relationships and Integration:**  
<img width="1522" height="861" alt="data_integration" src="https://github.com/user-attachments/assets/38bf5cb3-3e12-4991-a537-f428bbc2686f" />



- **CRM Data** includes **sales transactions, customer details, and product history**.  
- **ERP Data** provides **customer locations, product categories, and additional customer attributes**.  
- **Primary and Foreign Keys** establish relationships between **customers, products, and sales** across both sources.

From the diagram, we can observe:  
- **Two ERP tables** provide **customer information** that links to the **CRM customer table**.  
- **Another ERP table** provides **product category details** that relate to **CRM product data**.  

To create a meaningful business schema, we integrate these sources following the **schema structure** shown in the diagram, ensuring accuracy and consistency for analysis and reporting.
---

## **Data Model**  
![image](https://github.com/user-attachments/assets/446fb80b-8732-413f-8f7d-c031a0ba8fd1)


The **final data model** follows a **Star Schema**, consisting of:  
- **Fact Table (`fact_sales`)**: Contains **transactional sales data** with references to dimension tables.  
- **Dimension Tables**:  
  - `dim_customers` → Stores **customer details** from CRM & ERP.  
  - `dim_products` → Combines **product history and categories**.  

This model optimizes query performance, enabling **fast and efficient reporting** for business analytics.


---
## **Deployment Guide**  
Follow the **SQL scripts** to deploy the project step by step:

1. **Initialize Database & Environment**:  
   - Navigate to the `scripts` folder.
   - Run `init_database.sql` to set up the **database and schemas**.

2. **Bronze Layer - Raw Data Storage**:  
   - Go to the `bronze` folder.
   - Run `ddl_bronze.sql` to **create tables** and **define constraints** (e.g., `id INT`, `name NVARCHAR(50)`).
   - Execute `proc_load_bronze.sql` to **load data from CRM and ERP sources** into the Bronze Layer tables.

3. **Silver Layer - Data Cleansing & Transformation**:  
   - Navigate to the `silver` folder.
   - Run `ddl_silver.sql` to **create tables** for the Silver Layer (following the same steps as in the Bronze Layer).
   - Execute `proc_load_silver.sql` to **transform data from the Bronze Layer and apply data cleansing**.
   - At this stage, data in the Silver Layer is **clean and structured**.

4. **Gold Layer - Business-Ready Data Model**:  
   - Navigate to the `gold` folder.
   - Run `ddl_gold.sql` to **combine tables** based on **key relationships and integration** from the previous layers.
   - The final **star schema** is deployed, making data **ready for analytics and business insights**.

---

## **Exploratory Data Analysis (EDA)**  
After successfully building our **data warehouse**, the next step is to **explore our data**.  

### **Why is EDA Important?**  
When working on a **new role or project**, it's essential to **understand the data warehouse structure** and datasets. EDA helps answer questions such as:
- How many datasets do we have?
- How many columns exist in these datasets?
- What are the column features and constraints?

### **Step-by-Step EDA Process**  
1. Navigate to the **`scripts`** folder.
2. Open the **`Exploratory-Data-Steps`** folder.
3. Run the **SQL scripts (01 to 06)** to:
   - Identify **dimension and measure columns**.
   - Analyze **date ranges** within the datasets.
   - Explore **key measures** to understand their impact.
   - Perform **magnitude analysis** to assess data distribution.
   - Conduct **ranking analysis** to categorize performance levels.

By performing these steps, we can gain **a complete overview of the dataset** before diving into deeper analysis.

---

## **Analyzing Data to Extract Business Insights**  
Once we have **explored and understood** our datasets, the next step is to **analyze the data** to uncover **business insights**.

### **Step-by-Step Business Analysis**  
1. Stay in the **`scripts`** folder.
2. Open the **`Analyze-Data-For-Business-Steps`** folder.
3. Execute SQL scripts **01 to 07** in sequence to perform:
   
   - **Trend Analysis:** Examine how a **measure evolves over time** to detect trends and seasonality.
   - **Deep Dive Analysis:** Drill down further to identify **causes of fluctuations** and anomalies.
   - **Cumulative Analysis:** Calculate **running totals and moving averages** for key performance metrics.
   - **Part-to-Whole Analysis:** Understand **category contributions** to overall sales or revenue.
   - **Performance Analysis:** Evaluate **product, customer, and regional** performance over time.
   - **Ad-Hoc Analysis:** Segment customers to support **business strategy and decision-making**.
   - **Final Reporting:** Prepare a summary report on **customers and products** to provide actionable insights.
  
---   
## **Conclusion**  
This project demonstrates how to **build a scalable data warehouse** using SQL Server, following **best practices in ETL, data modeling, and star schema design**. The structured data enables data analysts and business users to derive meaningful insights for decision-making.
>>>>>>> remote_1/main
"# SQL Projects Monorepo" 
=======
# sql-data-analytics-project
A comprehensive collection of SQL scripts for data exploration, analytics, and reporting. These scripts cover various analyses such as database exploration, measures and metrics, time-based trends, cumulative analytics, segmentation, and more.
This repository contains SQL queries designed to help data analysts and BI professionals quickly explore, segment, and analyze data within a relational database. Each script focuses on a specific analytical theme and demonstrates best practices for SQL queries.

---
>>>>>>> remote_2/main
"# SQL Projects Monorepo" 
