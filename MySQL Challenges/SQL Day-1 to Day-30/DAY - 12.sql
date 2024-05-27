-- QUESTION : 1
-- 1. Write a query to find no of gold model per swimmer, swimmer who only own gold model

drop table if exists events;
CREATE TABLE events (
	ID int,
	event varchar(255),
	YEAR INt,
	GOLD varchar(255),
	SILVER varchar(255),
	BRONZE varchar(255)
);

INSERT INTO events 
VALUES 
	(1,'100m',2016, 'Amthhew Mcgarray','donald','barbara'),
	(2,'200m',2016, 'Nichole','Alvaro Eaton','janet Smith'),
	(3,'500m',2016, 'Charles','Nichole','Susana'),
	(4,'100m',2016, 'Ronald','maria','paula'),
	(5,'200m',2016, 'Alfred','carol','Steven'),
	(6,'500m',2016, 'Nichole','Alfred','Brandon'),
	(7,'100m',2016, 'Charles','Dennis','Susana'),
	(8,'200m',2016, 'Thomas','Dawn','catherine'),
	(9,'500m',2016, 'Thomas','Dennis','paula'),
	(10,'100m',2016, 'Charles','Dennis','Susana'),
	(11,'200m',2016, 'jessica','Donald','Stefeney'),
	(12,'500m',2016,'Thomas','Steven','Catherine');

select * from events;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with only_gold_winnners_cte as (
	select distinct gold as swimmer
	from events
	where gold is not null
		and gold not in (
			select distinct silver from events
			where silver is not null
		)
		and gold not in (
			select distinct bronze from events
			where bronze is not null
		)
)
select og.swimmer as swimmer,
	count(id) as gold_model_count
from only_gold_winnners_cte as og
inner join events as e
	on og.swimmer = e.gold
group by og.swimmer;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Company X has a record of its customers and their orders. 
-- Find the customer(s) with the highest order price for orders placed within 10 years of the first order (earliest order_date) in the database. 
-- Print the customer name and order price. If multiple records are returned, they can be in any order.

drop table if exists customers;
create table customers (
	id int primary key,
	name varchar(20) not null
);
INSERT INTO customers 
VALUES
	(1, 'Alice'), (2, 'Bob'), (3, 'Charlie'),
	(4, 'David'), (5, 'Eve'), (6, 'Frank'),
(7, 'Grace'), (8, 'Henry'), (9, 'Irene'), (10, 'Jack');

select * from customers;

drop table if exists orders;
create table orders (
	id int primary key,
	customer_id int,
	order_date date,
	price decimal(10, 2),
	foreign key (customer_id) references customers(id)
);
INSERT INTO orders
VALUES
	(1, 1, '2000-01-15', 200.00), (2, 2, '2001-03-22', 450.00),
	(3, 3, '2002-07-11', 300.00), (4, 1, '2003-08-09', 150.00),
	(5, 4, '2004-04-18', 500.00), (6, 2, '2005-02-22', 250.00),
	(7, 5, '2006-06-25', 400.00), (8, 3, '2007-11-30', 600.00),
	(9, 4, '2008-12-12', 700.00), (10, 5, '2009-09-21', 550.00),
	(11, 6, '2010-05-10', 800.00), (12, 7, '2011-07-15', 350.00),
	(13, 8, '2012-09-18', 900.00), (14, 9, '2013-11-20', 650.00),
	(15, 10, '2014-01-25', 450.00), (16, 6, '2015-02-26', 300.00),
	(17, 7, '2016-04-30', 700.00), (18, 8, '2017-06-14', 200.00),
	(19, 9, '2018-08-20', 1000.00), (20, 10, '2019-10-22', 850.00),
	(21, 1, '2020-01-15', 950.00), (22, 2, '2021-03-22', 500.00),
	(23, 3, '2022-07-11', 750.00), (24, 4, '2023-08-09', 800.00),
	(25, 5, '2024-04-18', 600.00), (26, 6, '2025-02-22', 950.00),
	(27, 7, '2026-06-25', 400.00), (28, 8, '2027-11-30', 1100.00),
	(29, 9, '2028-12-12', 1300.00), (30, 10, '2029-09-21', 1500.00);

select * from orders;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with earliest_order_date as (
	select min(order_date) as first_order_date
	from orders
), all_prev_orders as (
	select ct.name as cust_name, od.price as spent_amount, od.order_date
	from customers as ct
	join orders as od
		on ct.id = od.customer_id
	where od.order_date <= (
		DATEADD(YEAR, 10, (select first_order_date from earliest_order_date))
	)
), max_order_price as (
	select max(spent_amount) as max_amount_spent
	from all_prev_orders
)
select cust_name, spent_amount,order_date
from all_prev_orders
where spent_amount = (
	select max_amount_spent from max_order_price
);

-- ==================================================================================================================================
