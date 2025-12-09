use RestaurantOrders
--=========================================---
---View the menu_items table---
select * from ro.menu_items

---find the number of items on the menu---
select
	count( distinct menu_item_id) as number_of_items
from ro.menu_items

---What are the least and the most expensive items on the menu---
select 
	*
from ro.menu_items
order by price 

---How many Italians dishes are on the menu and What are the least & the most expensive Italian dish ---
select
	count(*) as Italian_dishes
from ro.menu_items
where category='Italian';

select
	*
from ro.menu_items
where category='Italian'
order by price

---How many dishes are in each category
---and avarage dishes price within each category---
select 
	category,
	count (distinct menu_item_id) as Number_of_dishes,
	cast (round (avg (price),2) as decimal (10,2)) as avg_dishes_price
from ro.menu_items
group by category

--=========================================---
---View the order_details table---
select * from ro.order_details

---What is the date range of the table 
select
	min(order_date) as earliest_order,
	max(order_date) as lastest_order,
--- how many orders were made within this date range---
	count(distinct order_id) as total_orders,
--- how many items were ordered within this date range---
	count(item_id) as total_items
from ro.order_details

---Which orders had the most number of items---
select 
	order_id,
	count(item_id) as number_of_items
from ro.order_details
group by order_id 
Having count(item_id) > 12 ---how many orders had more than 12 items---
order by count(item_id) desc

--=========================================---
---Combine the menu_items and order_details tables into a single table---
select 
	o.order_id,
	m.menu_item_id,
	m.item_name,
	m.category,
	m.price,
	o.order_details_id,
	o.order_date,
	o.order_time
from ro.menu_items as m
left join ro.order_details as o
on m.menu_item_id = o.item_id

---What are the least and the most ordered items? What category were they in ?---
select 
	m.menu_item_id,
	m.item_name,
	count (menu_item_id) as number_of_orders,
	m.category
from ro.menu_items as m
left join ro.order_details as o
on m.menu_item_id = o.item_id
group by 
	m.item_name,
	m.menu_item_id,
	m.category
order by count (menu_item_id) desc ---most ordered items
order by count (menu_item_id )	   ---least ordered items	

---Top 5 orders that spend the most money---
select top 5
	o.order_id,
	sum(price) as total_spend
from ro.menu_items as m
left join ro.order_details as o
on m.menu_item_id = o.item_id
group by order_id
order by sum(price) desc

---View the details of highest spend order and extract insights---
select 
	o.order_id,
	m.menu_item_id,
	m.item_name,
	m.category,
	m.price,
	o.order_details_id
from ro.menu_items as m
left join ro.order_details as o
on m.menu_item_id = o.item_id
where o.order_id = 440;

select
	m.category,
	count (menu_item_id) as total_dishes
from ro.menu_items as m
left join ro.order_details as o
on m.menu_item_id = o.item_id
where o.order_id = 440
group by m.category

---View the details of top 5 spend order and extract insights---
select 
	o.order_id,
	m.menu_item_id,
	m.item_name,
	m.category,
	m.price,
	o.order_details_id
from ro.menu_items as m
left join ro.order_details as o
on m.menu_item_id = o.item_id
where o.order_id in (440,2075,1957,330,2675);


select
	o.order_id,
	m.category,
	count (menu_item_id) as total_dishes
from ro.menu_items as m
left join ro.order_details as o
on m.menu_item_id = o.item_id
where o.order_id in (440,2075,1957,330,2675)
group by m.category , o.order_id

