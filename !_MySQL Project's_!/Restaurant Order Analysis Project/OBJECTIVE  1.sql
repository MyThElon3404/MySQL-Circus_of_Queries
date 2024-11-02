-- View the menu_items table and write a query to find the number of items on the menu

-- 1. View the menu_items table
select * 
from menu_items;

-- 2. Find the number of items on the menu
select count(*) as number_of_items
from menu_items; 

-- =====================================================================================

-- What are the least and most expensive items on the menu?

-- 1. least expensive items on the menu
select *
from menu_items
where price = (select min(price) from menu_items);

-- 2. most expensive items on the menu
select *
from menu_items
where price = (select max(price) from menu_items);

-- =====================================================================================

-- How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu?

-- 1. number of italian dishes in the menu
select count(*) as num_of_italian_dishes
from menu_items
where category = 'Italian';

-- 2. least expensive Italian dishes
select *
from menu_items
where category = 'Italian' and
	price = (select min(price) from menu_items where category = 'Italian');

-- 3. most expensive Italian dishes
select *
from menu_items
where category = 'Italian' and
	price = (select max(price) from menu_items where category = 'Italian');

-- =====================================================================================

-- How many dishes are in each category? What is the average dish price within each category?

-- 1. How many dishes are in each category
select category,
	COUNT(*) as num_of_category
from menu_items
group by category;

-- 2. Average dish price within each category
select category,
	ROUND(AVG(price), 2) as avg_price
from menu_items
group by category;
