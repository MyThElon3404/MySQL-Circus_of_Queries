
-- QUESTION : 1
-- 1. Write a SQL query to obtain the third transaction of every user. 
-- Output the user id, spend, and transaction date.

drop table if exists transactions;
CREATE TABLE transactions (
    user_id INTEGER,
    spend decimal(10, 2),
    transaction_date DATE
);

-- Insert data into transactions table
INSERT INTO transactions (user_id, spend, transaction_date) VALUES
(111, 100.50, '2022-01-08'),
(111, 55.00, '2022-01-10'),
(121, 36.00, '2022-01-18'),
(145, 24.99, '2022-01-26'),
(121, 56.00, '2022-02-18'),
(111, 89.60, '2022-02-05'),
(121, 46.00, '2022-03-18');

select * from transactions;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with user_transaction_cte as (
  select *,
    row_number() over(partition by user_id order by transaction_date asc) 
      as tran_rn
  from transactions
)
select user_id, spend, transaction_date
from user_transaction_cte
where tran_rn = 3
order by user_id;

--                  OR

select t1.user_id, t1.spend, t1.transaction_date
from transactions as t1
where (
          select
            count(DISTINCT t2.transaction_date) as tran_count
          from transactions as t2
          where t2.user_id = t1.user_id
            and t2.transaction_date <= t1.transaction_date
          
) = 3;
-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Find the top 5 products whose revenue has decreased in comparison to the 
-- previous year (both 2022 and 2023). Return the product name, 
-- revenue for the previous year, revenue for the current year, 
-- revenue decreased, and the decreased ratio (percentage).

drop table if exists product_revenue;
CREATE TABLE product_revenue (
    product_name VARCHAR(255),
    year INTEGER,
    revenue DECIMAL(10, 2)
);

-- Insert sample records
INSERT INTO product_revenue (product_name, year, revenue) VALUES
('Product A', 2022, 10000.00),
('Product A', 2023, 9500.00),
('Product B', 2022, 15000.00),
('Product B', 2023, 14500.00),
('Product C', 2022, 8000.00),
('Product C', 2023, 8500.00),
('Product D', 2022, 12000.00),
('Product D', 2023, 12500.00),
('Product E', 2022, 20000.00),
('Product E', 2023, 19000.00),
('Product F', 2022, 7000.00),
('Product F', 2023, 7200.00),
('Product G', 2022, 18000.00),
('Product G', 2023, 17000.00),
('Product H', 2022, 3000.00),
('Product H', 2023, 3200.00),
('Product I', 2022, 9000.00),
('Product I', 2023, 9200.00),
('Product J', 2022, 6000.00),
('Product J', 2023, 5900.00);

select * from product_revenue;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with product_revenue_cte as (
	select *,
		lag(revenue) 
		over(partition by product_name order by year asc) as prev_year_revenue
	from product_revenue
)
select top 5
	product_name, year,
	prev_year_revenue,
	revenue as curr_year_revenue,
	(prev_year_revenue - revenue) as revenue_decreased,
	cast(((prev_year_revenue - revenue)/prev_year_revenue)*100 
		as decimal(10, 2)) as revenue_decreased_ratio
from product_revenue_cte
where prev_year_revenue is not null
order by revenue_decreased desc;
-- ==================================================================================================================================  