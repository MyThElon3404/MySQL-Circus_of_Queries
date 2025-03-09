-- QUESTION : 1
-- 1. write sql query to find busiest route along with total ticket count
-- oneway_round = 'O' -> One way trip
-- oneway_round = 'R' -> Return trip
-- NOTE: DEL -> BOM and BOM -> DEL diff route type

CREATE TABLE tickets (
    airline_number VARCHAR(10),
    origin VARCHAR(3),
    destination VARCHAR(3),
    oneway_round CHAR(1),
    ticket_count INT
);

INSERT INTO tickets (airline_number, origin, destination, oneway_round, ticket_count)
VALUES
    ('DEF456', 'BOM', 'DEL', 'O', 150),
    ('GHI789', 'DEL', 'BOM', 'R', 50),
    ('JKL012', 'BOM', 'DEL', 'R', 75),
    ('MNO345', 'DEL', 'NYC', 'O', 200),
    ('PQR678', 'NYC', 'DEL', 'O', 180),
    ('STU901', 'NYC', 'DEL', 'R', 60),
    ('ABC123', 'DEL', 'BOM', 'O', 100),
    ('VWX234', 'DEL', 'NYC', 'R', 90);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1: Using CTE and UNION ALL
with route_cte as (
	select origin, destination, oneway_round, ticket_count
	from tickets
	UNION ALL
	select destination, origin, oneway_round, ticket_count
	from tickets
	where oneway_round = 'R'
)
select TOP 1
	origin, destination,
	sum(ticket_count) as tc
from route_cte
group by origin, destination
order by tc desc;

-- SOLUTION 2: Using sub-query
SELECT TOP 1 
    origin, destination, 
    SUM(ticket_count) AS tc
FROM (
    SELECT origin, destination, oneway_round, ticket_count 
    FROM tickets
    UNION ALL
    SELECT destination, origin, oneway_round, ticket_count 
    FROM tickets 
    WHERE oneway_round = 'R'
) AS route_cte
GROUP BY origin, destination
ORDER BY tc DESC;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. write a SQL query to find out supplier_id, product_id, and starting date of record_date 
-- for which stock quantity is less than 50 for two or more consecutive days.

CREATE TABLE stock (
    supplier_id INT,
    product_id INT,
    stock_quantity INT,
    record_date DATE
);

INSERT INTO stock (supplier_id, product_id, stock_quantity, record_date)
VALUES
    (1, 1, 60, '2022-01-01'),
    (1, 1, 40, '2022-01-02'),
    (1, 1, 35, '2022-01-03'),
    (1, 1, 45, '2022-01-04'),
    (1, 1, 51, '2022-01-06'),
    (1, 1, 55, '2022-01-09'),
    (1, 1, 25, '2022-01-10'),
    (1, 1, 48, '2022-01-11'),
    (1, 1, 45, '2022-01-15'),
    (1, 1, 38, '2022-01-16'),
    (1, 2, 45, '2022-01-08'),
    (1, 2, 40, '2022-01-09'),
    (2, 1, 45, '2022-01-06'),
    (2, 1, 55, '2022-01-07'),
    (2, 2, 45, '2022-01-08'),
    (2, 2, 48, '2022-01-09'),
    (2, 2, 35, '2022-01-10'),
    (2, 2, 52, '2022-01-15'),
    (2, 2, 23, '2022-01-16');


-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

WITH stock_cte AS (
    SELECT supplier_id, product_id, 
        stock_quantity, record_date,
        LAG(stock_quantity) OVER (PARTITION BY supplier_id, product_id ORDER BY record_date) AS prev_stock,
        LAG(record_date) OVER (PARTITION BY supplier_id, product_id ORDER BY record_date) AS prev_date
    FROM stock
)
SELECT supplier_id, product_id, 
    MIN(record_date) AS start_date
FROM stock_cte
WHERE stock_quantity < 50 
  AND prev_stock < 50 
  AND DATEDIFF(day, prev_date, record_date) = 1  -- Ensures consecutive days
GROUP BY supplier_id, product_id;


-- ==================================================================================================================================
