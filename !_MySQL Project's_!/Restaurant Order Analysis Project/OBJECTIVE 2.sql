-- View the order_details table. What is the date range of the table?

-- 1. View order_details table
select *
from order_details;

-- 2. date range of the table
select min(order_date) as min_order_date,
	max(order_date) as max_order_date
from order_details;

-- =====================================================================================

-- How many orders were made within this date range? How many items were ordered within this date range?

-- 1. How many orders were made within this date range
select COUNT(distinct order_id) as total_orders_made
from order_details;

-- 2. How many items were ordered within this date range
select COUNT(*) as num_of_item_ordered
from order_details;

-- =====================================================================================

-- Which orders had the most number of items?

select TOP 1 order_id,
	COUNT(item_id) as num_of_items
from order_details
group by order_id
order by num_of_items desc;

-- =====================================================================================

-- How many orders had more than 12 items?

WITH orders_with_items AS (
    SELECT order_id,
		COUNT(item_id) AS num_of_item
    FROM order_details
    GROUP BY order_id
)
SELECT COUNT(*) AS num_of_orders
FROM orders_with_items
where num_of_item > 12;
