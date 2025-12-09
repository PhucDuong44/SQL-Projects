---==============QUALITY CHECK===============--
---Check for unwanted spaces---
select 
	account,
	sector
from crm.account
where account != trim (account) or sector != trim(sector);

Select 
	sales_agent,
	product,
	account
From crm.sales_pipeline
Where sales_agent != trim(sales_agent) or product != trim(product) or account != trim(acount)

-- Data Standardization & Consistency
Select distinct deal_stage
from crm.sales_pipeline

-- Check for NULLs or Duplicates in Primary Key
Select 
	opportunity_id,
	Count (*) as IDcount
From crm.sales_pipeline
Group by opportunity_id
Having Count(*) >1 or opportunity_id is null

-- Check for Invalid Date
Select*from crm.sales_pipeline
Where engage_date > close_date
