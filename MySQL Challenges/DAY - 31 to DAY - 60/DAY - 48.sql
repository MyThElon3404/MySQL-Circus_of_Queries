-- QUESTION : 1
-- 1. A telecommunications company wants to invest in new countries. The country intends to invest in the countries 
-- where the average call duration of the calls in this country is strictly greater than the global average call duration.
-- Write an SQL query to find the countries where this company can invest.
-- Return the result table in any order

CREATE TABLE Person (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    phone_number VARCHAR(20)
);
INSERT INTO Person (id, name, phone_number) 
VALUES
(3, 'Jonathan', '051-1234567'),
(12, 'Elvis', '051-7654321'),
(1, 'Moncef', '212-1234567'),
(2, 'Maroua', '212-6523651'),
(7, 'Meir', '972-1234567'),
(9, 'Rachel', '972-0011100');

CREATE TABLE Country (
    name VARCHAR(255),
    country_code VARCHAR(3) PRIMARY KEY
);
INSERT INTO Country (name, country_code) 
VALUES
('Peru', '051'),
('Israel', '972'),
('Morocco', '212'),
('Germany', '049'),
('Ethiopia', '251');

CREATE TABLE Calls (
    caller_id INT,
    callee_id INT,
    duration INT
);
INSERT INTO Calls (caller_id, callee_id, duration) 
VALUES
(1, 9, 33), (2, 9, 4), (1, 2, 59),
(3, 12, 102), (3, 12, 330), (12, 3, 5),
(7, 9, 13), (7, 1, 3), (9, 7, 1),
(1, 7, 7);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with call_avg_cte as (
	select c.name as country_name,
		avg(duration) as call_duration_avg
	from country c
	join person p
		on c.country_code = SUBSTRING(p.phone_number, 1, 3)
	join calls cl
		on p.id = cl.caller_id
	group by c.name
)
select country_name
from call_avg_cte
where call_duration_avg > (
	select AVG(duration) from calls
);

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Write an SQL query to report the customer_id and customer_name of customers who bought 
-- products "A", "B" but did not buy the product "C" since we want to recommend them buy this product.
-- Return the result table ordered by customer_id.

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);
INSERT INTO Customers (customer_id, customer_name) 
VALUES
(1, 'Daniel'), (2, 'Diana'),
(3, 'Elizabeth'), (4, 'Jhon');

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
INSERT INTO Orders (order_id, customer_id, product_name) 
VALUES
(10, 1, 'A'), (20, 1, 'B'), (30, 1, 'D'),
(40, 1, 'C'), (50, 2, 'A'), (60, 3, 'A'),
(70, 3, 'B'), (80, 3, 'D'), (90, 4, 'C');

select * from Customers;
select * from Orders;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1 - Using INNER JOIN and SUB-QUERY
select c.customer_id,
	c.customer_name
from customers c
join orders o1
	on c.customer_id = o1.customer_id
	and o1.product_name = 'A'
join orders o2
	on c.customer_id = o2.customer_id
	and o2.product_name = 'B'
where c.customer_id NOT IN (
	select customer_id
	from orders
	where product_name = 'C'
);

-- SOLUTION 2 - Using ONLY SUB-QUERY
select customer_id,
	customer_name
from customers
where customer_id IN (
	select customer_id
	from orders
	where product_name = 'A'
)
AND customer_id IN (
	select customer_id
	from orders
	where product_name = 'B'
)
AND customer_id NOT IN (
	select customer_id
	from orders
	where product_name = 'C'
);

-- SOLUTION 3 - Using GROUP BY and HAVING Clause
select c.customer_id,
	c.customer_name
from Customers c
join Orders o
	on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having 
	SUM(case when o.product_name = 'A' then 1 else 0 end) > 0
and SUM(case when o.product_name = 'B' then 1 else 0 end) > 0
and SUM(case when o.product_name = 'C' then 1 else 0 end) = 0;

-- ==================================================================================================================================
