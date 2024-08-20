
-- QUESTION : 1
-- 1. Find the original Origin and Destination for the passenger
-- Example - 
-- cid - 1 going del to hyd and then hyd to blr
-- so end result is origin - del and Destination - blr

CREATE TABLE flights (
    cid VARCHAR(512),
    fid VARCHAR(512),
    origin VARCHAR(512),
    destination VARCHAR(512)
);
INSERT INTO flights (cid, fid, origin, destination) VALUES ('1', 'f1', 'Del', 'Hyd');
INSERT INTO flights (cid, fid, origin, destination) VALUES ('1', 'f2', 'Hyd', 'Blr');
INSERT INTO flights (cid, fid, origin, destination) VALUES ('2', 'f3', 'Mum', 'Agra');
INSERT INTO flights (cid, fid, origin, destination) VALUES ('2', 'f4', 'Agra', 'Kol');
INSERT INTO flights (cid, fid, origin, destination) VALUES ('3', 'f5', 'Kol', 'Pune');
INSERT INTO flights (cid, fid, origin, destination) VALUES ('3', 'f6', 'Pune', 'Del');
INSERT INTO flights (cid, fid, origin, destination) VALUES ('4', 'f7', 'Blr', 'Chn');
INSERT INTO flights (cid, fid, origin, destination) VALUES ('4', 'f8', 'Chn', 'Mum');
INSERT INTO flights (cid, fid, origin, destination) VALUES ('5', 'f9', 'Hyd', 'Goa');
INSERT INTO flights (cid, fid, origin, destination) VALUES ('5', 'f10', 'Goa', 'Blr');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1 - Using Inner Join
select t1.cid as cust_id,
	t1.origin as origin,
	t2.destination as destination
from flights as t1
inner join flights as t2
	on t1.destination = t2.origin
	and t1.cid = t2.cid
order by t1.cid;

-- SOLUTION 2 - Using cte's
WITH OriginalOrigins AS (
    SELECT
        f1.cid,
        f1.origin AS original_origin
    FROM flights f1
    LEFT JOIN flights f2 ON f1.origin = f2.destination AND f1.cid = f2.cid
    WHERE f2.destination IS NULL
),
FinalDestinations AS (
    SELECT
        f1.cid,
        f1.destination AS final_destination
    FROM flights f1
    LEFT JOIN flights f2 ON f1.destination = f2.origin AND f1.cid = f2.cid
    WHERE f2.origin IS NULL
)
SELECT 
    o.cid,
    o.original_origin AS origin,
    d.final_destination AS destination
FROM OriginalOrigins o
JOIN FinalDestinations d ON o.cid = d.cid
ORDER BY o.cid;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. New customer count per month
-- Example - 
-- for month 01 there are two new customer c1 and c2
-- for month 02 there is only one customer c3 because c1 already visited last month
-- so we only want new customer count per month

drop table if exists sales;
CREATE TABLE sales (
    order_date date,
    customer VARCHAR(512),
    qty INT
);
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-01-01', 'C1', '20');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-01-01', 'C2', '30');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-02-01', 'C1', '10');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-02-01', 'C3', '15');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-03-01', 'C5', '19');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-03-01', 'C4', '10');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-04-01', 'C3', '13');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-04-01', 'C5', '15');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-04-01', 'C6', '10');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1 - With CTE and windows function (ROW_NUMBER())
with rn_cte as (
	select *,
		ROW_NUMBER() over(partition by customer order by order_date) as rn
	from sales
)
select order_date,
	count(distinct customer) as cust_per_month_cnt
from rn_cte
where rn = 1
group by order_date;

-- SOLUTION 2 - With CTE and Min value method
WITH FirstPurchase AS (
    SELECT
        customer,
        MIN(order_date) AS first_order_date
    FROM sales
    GROUP BY customer
)
SELECT
    YEAR(first_order_date) AS year,
    MONTH(first_order_date) AS month,
    COUNT(DISTINCT customer) AS new_customer_count
FROM FirstPurchase
GROUP BY 
    YEAR(first_order_date), 
    MONTH(first_order_date)
ORDER BY 
    YEAR(first_order_date), 
    MONTH(first_order_date);

-- ==================================================================================================================================
