-- QUESTION : 1
-- 1. You have a table called "website_traffic" with columns "date", "page_views", and "unique_visitors". 
-- Write a query to find the days where the page views increased by more than 20% compared to the previous day, 
-- and the unique visitors also increased by more than 15% compared to the previous day.

drop table if exists website_traffic;
CREATE TABLE website_traffic (
    date DATE,
    page_views INT,
    unique_visitors INT
);

-- Insert 30 rows of modified sample data
INSERT INTO website_traffic (date, page_views, unique_visitors) VALUES
('2024-10-01', 100, 80),
('2024-10-02', 125, 95),  -- 25% increase in page_views, 18.75% in unique_visitors
('2024-10-03', 110, 88),
('2024-10-04', 130, 95),
('2024-10-05', 160, 110), -- 23.1% increase in page_views, 15.8% in unique_visitors
('2024-10-06', 140, 100),
('2024-10-07', 175, 120), -- 25% increase in page_views, 20% in unique_visitors
('2024-10-08', 150, 105),
('2024-10-09', 180, 125), -- 20% increase in page_views, 19% in unique_visitors
('2024-10-10', 200, 140), -- 11.1% increase in page_views, 12% increase in unique_visitors (not meeting conditions)
('2024-10-11', 250, 170), -- 25% increase in page_views, 21.4% in unique_visitors
('2024-10-12', 205, 135);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

WITH website_traffic_cte AS (
    SELECT date,
        page_views AS curr_pv,
        LAG(page_views) OVER w AS prev_pv,
        unique_visitors AS curr_uv,
        LAG(unique_visitors) OVER w AS prev_uv
    FROM website_traffic
    WINDOW w AS (ORDER BY date ASC)
)
SELECT date
FROM website_traffic_cte
WHERE prev_pv IS NOT NULL
    AND prev_uv IS NOT NULL
	  AND curr_pv > 1.2 * prev_pv
	  AND curr_uv > 1.15 * prev_uv;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. You have a table called "orders" with columns "order_id", "customer_id", "order_date", and "total_amount". 
-- Write a query to find the customers who have placed exactly three orders in the last 90 days, 
-- with each order having a total amount greater than $500.

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id INT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2)
);
INSERT INTO orders (order_id, customer_id, order_date, total_amount) VALUES
(1, 101, '2024-07-15', 600.00),  -- Order more than 90 days ago
(2, 102, '2024-08-10', 550.00),  -- Order within 90 days
(3, 102, '2024-08-20', 600.00),  -- Order within 90 days
(4, 102, '2024-08-30', 700.00),  -- Order within 90 days (Exactly 3 for customer 102)
(5, 103, '2024-09-05', 400.00),  -- Order below $500, doesn't count
(6, 104, '2024-09-15', 550.00),  -- Order within 90 days
(7, 104, '2024-09-20', 600.00),  -- Order within 90 days
(8, 104, '2024-09-25', 650.00),  -- Order within 90 days (Exactly 3 for customer 104)
(9, 105, '2024-09-28', 500.00),  -- Order exactly $500, doesn't count
(10, 106, '2024-10-02', 800.00), -- Order within 90 days
(11, 106, '2024-10-10', 900.00), -- Order within 90 days
(12, 106, '2024-10-15', 550.00); -- Order within 90 days (Exactly 3 for customer 106)

select * from orders;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with orders_cte as (
	select customer_id,
		count(order_id) as order_cnt
	from orders
	where order_date >= DATEADD(DAY, -90, GETDATE())
		and total_amount > 500
	group by customer_id
)
select customer_id
from orders_cte
where order_cnt = 3;

-- ==================================================================================================================================
