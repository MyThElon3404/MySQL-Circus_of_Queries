-- QUESTION : 1
-- 1. Query to Find Customers Who Placed Orders in the Last 30 Days But Not in the Last 14 Days

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2)
);
INSERT INTO orders (order_id, customer_id, order_date, total_amount)
VALUES
(1, 101, '2024-08-01', 150.50),
(2, 102, '2024-08-10', 200.00),
(3, 103, '2024-08-20', 350.75),
(4, 104, '2024-08-28', 500.00),
(5, 101, '2024-08-31', 125.00),
(6, 105, '2024-09-01', 175.00),
(7, 102, '2024-09-03', 400.00),
(8, 103, '2024-09-15', 275.00),
(9, 104, '2024-09-04', 325.50);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1: If you have latest data that contain today's date
select customer_id
from orders
where order_date between DATEADD(DAY, -30, GETDATE())
	and DATEADD(DAY, -14, GETDATE());

-- SOLUTION 2: This is for old data
WITH MaxOrderDate AS (
    SELECT MAX(order_date) AS max_date
    FROM orders
)
SELECT DISTINCT customer_id
FROM orders, MaxOrderDate
WHERE order_date BETWEEN DATEADD(DAY, -30, MaxOrderDate.max_date) 
	AND DATEADD(DAY, -14, MaxOrderDate.max_date);

-- ==================================================================================================================================


