---==========SQL TASKS==========---

---1.How is each sales team performing compared to the rest?---
Select
	s.manager as Teamsale_name,
	ROUND(
		(Cast(Count(Case When deal_stage = 'won' then 1 End ) as float ) /
		Cast(Count(Case When deal_stage in ('won','lost') then 1 End ) as float))
		,2) as Win_rate,
	SUM( Case When deal_stage ='won' then close_value End) as Total_won_revenue,
	ROUND(
	(Sum( Case When deal_stage ='won' then close_value End) /
	Cast(Count(Case When deal_stage = 'won' then 1 End ) as float))
	,2) as AVG_won_revenue,
	COUNT(deal_stage) as Total_deals
From crm.salesteams as s
Left join crm.sales_pipeline as p
on s.sales_agent = p.sales_agent
Group by manager
Order by Win_rate Desc

---2.Are any sales agents lagging behind?---
Select 
	sales_agent  as Sale_agent,
	COUNT(deal_stage) as Total_opportunity,
	ROUND
		(Cast(Count(Case When deal_stage = 'won' then 1 End ) as float)/
		Cast(Count(Case When deal_stage in ('won','lost') then 1 End ) as float),2) as Win_Rate,
	ROUND
		(Cast(Count(Case When deal_stage = 'won' then 1 End) as float )/
		Cast(Count(deal_stage) as float ),2) as Sales_Effectiveness_Rate,
	SUM(close_value) as Total_revenue,
	AVG(Case When Deal_stage = 'won' Then DATEDIFF(day, engage_date, close_date) End ) as AVG_sales_cycle,
	COUNT(Case When deal_stage in ('engaging','prospecting') then 1 End) as Total_pipeline_opportunity
From crm.sales_pipeline
Group by sales_agent
Order by Win_Rate, Total_revenue

---3.Are there any quarter-over-quarter trends?---
Select 
	DATEPART(YEAR, close_date) AS Year,
    DATEPART(QUARTER, close_date) AS Quarter,
	COUNT(deal_stage) as Total_opportunity,
	ROUND
		(Cast(Count(Case When deal_stage = 'won' then 1 End ) as float)/
		Cast(Count(Case When deal_stage in ('won','lost') then 1 End ) as float),2) as Win_Rate,

	SUM(close_value) as Total_revenue,
	AVG(Case When Deal_stage = 'won' Then DATEDIFF(day, engage_date, close_date) End ) as AVG_sales_cycle
From crm.sales_pipeline
WHERE deal_stage IN ('won','lost')
Group by DATEPART(YEAR, close_date),DATEPART(QUARTER, close_date)
Order by DATEPART(QUARTER, close_date)
;

--Determine the overall time range
DECLARE @start_time DATE = (SELECT MIN(engage_date) FROM crm.sales_pipeline);
DECLARE @end_time DATE = (SELECT MAX(close_date) FROM crm.sales_pipeline);
-- Create CTE quarters
WITH Quarters AS (
    SELECT 0 AS q_offset
    UNION ALL
    SELECT q_offset + 1
    FROM Quarters
    WHERE DATEADD(QUARTER, q_offset + 1, @start_time) <= @end_time
)
--Aggregate query
SELECT
    DATEPART(YEAR, DATEADD(QUARTER, q.q_offset, @start_time)) AS Year,
    DATEPART(QUARTER, DATEADD(QUARTER, q.q_offset, @start_time)) AS Quarter,
    SUM(CASE WHEN s.deal_stage='won' THEN s.close_value ELSE 0 END) AS Total_Revenue,
    ROUND(
        CAST(COUNT(CASE WHEN s.deal_stage='won' THEN 1 END) AS FLOAT) /
        CAST(COUNT(CASE WHEN s.deal_stage IN ('won','lost') THEN 1 END) AS FLOAT), 2
    ) AS Win_Rate,
    AVG(CASE WHEN s.deal_stage='won' THEN DATEDIFF(DAY, s.engage_date, s.close_date) END) AS AVG_Sales_Cycle
FROM Quarters q
LEFT JOIN crm.sales_pipeline s
    ON s.deal_stage IN ('won','lost')
   AND s.engage_date < DATEADD(QUARTER, q.q_offset + 1, @start_time)
   AND s.close_date >= DATEADD(QUARTER, q.q_offset, @start_time)
GROUP BY q.q_offset
ORDER BY Year, Quarter

---4.Do any products have better win rates?---
Select 
	p.product as Product_name,
	p.series as Product_series,
	COUNT (deal_stage) as Total_deal,
	COUNT(Case When deal_stage ='won' Then 1 End ) as Total_deals_won, 
	COUNT(Case When deal_stage ='lost' Then 1 End ) as Total_deals_lost,
	ROUND (
	Cast(Count(Case When deal_stage = 'won' Then 1 End) as float)/
	Cast(Count(Case When deal_stage in ('won','lost') Then 1 End) as float),2) as Win_rate,
	SUM(close_value) as Total_revenue,
	AVG(Case When deal_stage = 'won' Then datediff(day,engage_date,close_date) End ) as AVG_sales_cycle,
	COUNT (deal_stage) - (COUNT(Case When deal_stage ='won' Then 1 End )+COUNT(Case When deal_stage ='lost' Then 1 End )) as Total_pipeline_opportunity
From crm.products  as p
Left join crm.sales_pipeline as s
on p.product = Case 
				When s.product = 'GTXPro' Then 'GTX Pro'
				Else s.product 
				End
Group by p.product, p.series
Order by Win_rate desc
