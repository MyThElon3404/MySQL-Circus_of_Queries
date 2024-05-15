-- QUESTION : 1
-- 1. Write an SQL query to find for each month and country, 
-- the number of transactions and their total amount, 
-- the number of approved transactions and their total amount.

DROP TABLE IF EXISTS Transactions;
CREATE TABLE Transactions (
    id INT PRIMARY KEY,
    country VARCHAR(20),
    trans_status VARCHAR(20),
    amount INT,
    trans_date DATE
);

INSERT INTO Transactions
VALUES
(121, 'US', 'approved', 1000, '2018-12-18'),
(122, 'US', 'declined', 2000, '2018-12-19'),
(123, 'US', 'approved', 2000, '2019-01-01'),
(124, 'DE', 'approved', 2000, '2019-01-07');

select * from Transactions;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

select
	FORMAT(trans_date, 'yyyy-MM') as trans_month,
	country,
	count(id) as trans_count,
	sum(amount) as trans_totla_amount,
	count(case when trans_status='approved' then 1 else 0 end) 
		as approved_trans_count,
	sum(case when trans_status='approved' then amount else 0 end) 
		as approved_trans_total_amount
from Transactions
group by FORMAT(trans_date, 'yyyy-MM'), country
order by trans_month asc;

-- we can also use SELECT DATE_FORMAT('2018-12-31', '%Y-%m') rather than FORMAT(trans_date, 'yyyy-MM')

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. write a query in SQL to find the highest sale among salespersons that appears only once
-- Return salesperson ID and sale amount

DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
	TRANSACTION_ID int NOT NULL,
	SALESMAN_ID int NOT NULL,
	SALE_AMOUNT decimal(8,2),
	PRIMARY KEY (TRANSACTION_ID)
);

INSERT INTO sales 
VALUES
	(501,18,5200.00), (502,50,5566.00),(503,38,8400.00),
	(504,43,8400.00), (505,11,9000.00), (506,42,12200.00),
	(507,13,7000.00), (508,33,6000.00), (509,41,8200.00),
	(510,11,4500.00), (511,51,10000.00), (512,29,9500.00),
	(513,59,6500.00), (514,38,7800.00), (515,58,9800.00),
	(516,60,12000.00), (517,58,14000.00), (518,23,12200.00),
	(519,34,5480.00), (520,35,8129.00), (521,49,9323.00),
	(522,46,8200.00), (523,47,9990.00), (524,42,14000.00),
	(525,44,7890.00), (526,47,5990.00), (527,21,7770.00),
	(528,57,6645.00), (529,56,5125.00), (530,25,10990.00);

select * from sales;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

select 
	salesman_id,sale_amount
from sales
where sale_amount = (
	select TOP 1
		sale_amount
	from sales
	group by sale_amount
	having count(*) = 1
	order by sale_amount desc
);

-- ==================================================================================================================================
