-- QUESTION : 1
-- 1. For each week, find the total number of orders. Include only the orders that are from the first quarter of 2023.
-- Quarter - start date = '2023-01-01' and end date = '2023-03-31'
-- The output should contain 'week' and 'quantity'.

DROP TABLE IF EXISTS orders_analysis
CREATE TABLE orders_analysis (
    stage_of_order VARCHAR(50),
    week DATE,
    quantity INT
);
INSERT INTO orders_analysis (stage_of_order, week, quantity) 
VALUES
('Completed', '2023-01-02', 10),
('Completed', '2023-01-09', 15),
('Completed', '2023-01-16', 20),
('Completed', '2023-01-23', 25),
('Completed', '2023-01-30', 30),
('Completed', '2023-02-06', 35),
('Completed', '2023-02-13', 40),
('Completed', '2023-02-20', 45),
('Completed', '2023-02-27', 50),
('Completed', '2023-03-06', 55),
('Completed', '2023-03-13', 60),
('Completed', '2023-03-20', 65),
('Completed', '2023-03-27', 70),
('Processing', '2023-01-02', 5),
('Processing', '2023-01-09', 10),
('Processing', '2023-01-16', 15),
('Processing', '2023-01-23', 20),
('Processing', '2023-01-30', 25),
('Processing', '2023-02-06', 30),
('Processing', '2023-02-13', 35),
('Processing', '2023-02-20', 40),
('Processing', '2023-02-27', 45),
('Processing', '2023-03-06', 50),
('Processing', '2023-03-13', 55),
('Processing', '2023-03-20', 60),
('Processing', '2023-03-27', 65),
('Cancelled', '2023-01-02', 2),
('Cancelled', '2023-01-09', 4),
('Cancelled', '2023-01-16', 6),
('Cancelled', '2023-01-23', 8),
('Cancelled', '2023-01-30', 10),
('Cancelled', '2023-02-06', 12),
('Cancelled', '2023-02-13', 14),
('Cancelled', '2023-02-20', 16),
('Cancelled', '2023-02-27', 18),
('Cancelled', '2023-03-06', 20),
('Cancelled', '2023-03-13', 22),
('Cancelled', '2023-03-20', 24),
('Cancelled', '2023-03-27', 26),
('Pending', '2023-01-02', 3),
('Pending', '2023-01-09', 6),
('Pending', '2023-01-16', 9),
('Pending', '2023-01-23', 12),
('Pending', '2023-01-30', 15),
('Pending', '2023-02-06', 18),
('Pending', '2023-02-13', 21),
('Pending', '2023-02-20', 24),
('Pending', '2023-02-27', 27),
('Pending', '2023-03-06', 30),
('Pending', '2023-03-13', 33);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------
select
	week as start_of_week,
	DATEPART(WEEK, week) as week_number,
	sum(quantity) as weekly_total_quantity
from orders_analysis
where week between '2023-01-01' and '2023-03-31'
group by week, DATEPART(WEEK, week)
order by week asc;
-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Top Monthly Sellers - You are provided with a transactional dataset from Amazon that contains detailed information about sales across different products and marketplaces. Your task is to list the top 3 sellers in each product category for January.
-- The output should contain 'seller_id' , 'total_sales' ,'product_category' , 'market_place', and 'month'.

DROP TABLE IF EXISTS sales_data;
CREATE TABLE sales_data (
    seller_id VARCHAR(50),
    total_sales FLOAT,
    product_category VARCHAR(50),
    market_place VARCHAR(50),
    month DATE
);
INSERT INTO sales_data (seller_id, total_sales, product_category, market_place, month)
VALUES
('seller1', 100.50, 'Electronics', 'Amazon US', '2023-01-01'),
('seller1', 120.75, 'Electronics', 'Amazon US', '2023-01-01'),
('seller1', 80.25, 'Electronics', 'Amazon US', '2023-01-01'),

('seller2', 75.20, 'Electronics', 'Amazon US', '2023-01-01'),
('seller2', 90.60, 'Electronics', 'Amazon US', '2023-01-01'),
('seller2', 110.30, 'Electronics', 'Amazon US', '2023-01-01'),

('seller3', 150.80, 'Electronics', 'Amazon US', '2023-01-01'),
('seller3', 95.40, 'Electronics', 'Amazon US', '2023-01-01'),
('seller3', 125.10, 'Electronics', 'Amazon US', '2023-01-01'),

('seller4', 200.75, 'Clothing', 'Amazon UK', '2023-01-01'),
('seller4', 180.50, 'Clothing', 'Amazon UK', '2023-01-01'),
('seller4', 220.30, 'Clothing', 'Amazon UK', '2023-01-01'),

('seller5', 120.25, 'Clothing', 'Amazon UK', '2023-01-01'),
('seller5', 140.60, 'Clothing', 'Amazon UK', '2023-01-01'),
('seller5', 160.40, 'Clothing', 'Amazon UK', '2023-01-01'),

('seller6', 80.30, 'Clothing', 'Amazon UK', '2023-01-01'),
('seller6', 90.10, 'Clothing', 'Amazon UK', '2023-01-01'),
('seller6', 100.20, 'Clothing', 'Amazon UK', '2023-01-01'),

('seller7', 300.50, 'Books', 'Amazon US', '2023-01-01'),
('seller7', 320.75, 'Books', 'Amazon US', '2023-01-01'),
('seller7', 280.25, 'Books', 'Amazon US', '2023-01-01'),

('seller8', 275.20, 'Books', 'Amazon US', '2023-01-01'),
('seller8', 290.60, 'Books', 'Amazon US', '2023-01-01'),
('seller8', 310.30, 'Books', 'Amazon US', '2023-01-01'),

('seller9', 350.80, 'Books', 'Amazon US', '2023-01-01'),
('seller9', 295.40, 'Books', 'Amazon US', '2023-01-01'),
('seller9', 325.10, 'Books', 'Amazon US', '2023-01-01');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------
with category_sales_cte as (
	select *,
		ROW_NUMBER() over (partition by product_category order by total_sales desc)
			as ctg_sales_rn
	from sales_data
	where MONTH(month) = 1
)
select 
	seller_id, total_sales, product_category, 
	market_place, datename(month, month) as month
from category_sales_cte
where ctg_sales_rn <= 3
order by seller_id asc;
-- ==================================================================================================================================
