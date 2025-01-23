-- QUESTION : 1
-- 1. Write an SQL query to find the salaries of the employees after applying taxes.

-- The tax rate is calculated for each company based on the following criteria:
-- 0% If the max salary of any employee in the company is less than 1000$.
-- 24% If the max salary of any employee in the company is in the range [1000, 10000] inclusive.
-- 49% If the max salary of any employee in the company is greater than 10000$.
-- Return the result table in any order. Round the salary to the nearest integer.

CREATE TABLE Salaries (
    company_id INT,
    employee_id INT,
    employee_name VARCHAR(50),
    salary INT,
    PRIMARY KEY (company_id, employee_id)
);
INSERT INTO Salaries (company_id, employee_id, employee_name, salary) 
VALUES
(1, 1, 'Tony', 2000),
(1, 2, 'Pronub', 21300),
(1, 3, 'Tyrrox', 10800),
(2, 1, 'Pam', 300),
(2, 7, 'Bassem', 450),
(2, 9, 'Hermione', 700),
(3, 7, 'Bocaben', 100),
(3, 2, 'Ognjen', 2200),
(3, 13, 'Nyancat', 3300),
(3, 15, 'Morninngcat', 1866);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with max_salary_cte as (
	select company_id,
		max(salary) as max_salary
	from salaries
	group by company_id
)
select s.company_id, employee_id, employee_name, salary, ms.max_salary,
	ROUND(
		case
			when max_salary < 1000 then salary
			when max_salary between 1000 and 10000 then salary * 0.76
			else salary * 0.51
		end
	, 0) as salary_after_tax
from Salaries s
join max_salary_cte ms
	on s.company_id = ms.company_id;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Write an SQL query to report the Capital gain/loss for each stock.
-- The capital gain/loss of a stock is total gain or loss after buying and selling the stock one or many times.
-- Return the result table in any order.

CREATE TABLE Stocks (
    stock_name VARCHAR(15),
    operation NVARCHAR(10) check(operation in ('Sell', 'Buy')),
    operation_day INT,
    price INT,
    PRIMARY KEY (stock_name, operation_day)
);
INSERT INTO Stocks (stock_name, operation, operation_day, price) 
VALUES
('Leetcode', 'Buy', 1, 1000),
('Corona Masks', 'Buy', 2, 10),
('Leetcode', 'Sell', 5, 9000),
('Handbags', 'Buy', 17, 30000),
('Corona Masks', 'Sell', 3, 1010),
('Corona Masks', 'Buy', 4, 1000),
('Corona Masks', 'Sell', 5, 500),
('Corona Masks', 'Buy', 6, 1000),
('Handbags', 'Sell', 29, 7000),
('Corona Masks', 'Sell', 10, 10000);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

select stock_name,
	sum (case
		when operation = 'Sell' then price
		else - price
	end) as capital_gain_loss
from stocks
group by stock_name
order by capital_gain_loss desc;

-- ------------------------------------ OR -------------------------------------------

select stock_name,
	sell_price - buy_price as capital_gain_loss
from (
	select stock_name,
		sum(price) as sell_price
	from stocks
	where operation = 'Sell'
	group by stock_name
) sp
inner join
	(
	select stock_name as sn,
		sum(price) as buy_price
	from stocks
	where operation = 'Buy'
	group by stock_name
) bp
	on sp.stock_name = bp.sn
order by capital_gain_loss desc;

-- ==================================================================================================================================

-- Note - Every buy stock should get sell. If not eliminate those stocks please

WITH BuyOperations AS (
    SELECT stock_name, operation_day AS buy_day, price AS buy_price
    FROM Stocks
    WHERE operation = 'Buy'
),
SellOperations AS (
    SELECT stock_name, operation_day AS sell_day, price AS sell_price
    FROM Stocks
    WHERE operation = 'Sell'
)
SELECT b.stock_name,
       SUM(s.sell_price - b.buy_price) AS capital_gain_loss
FROM BuyOperations b
JOIN SellOperations s ON b.stock_name = s.stock_name AND s.sell_day > b.buy_day
GROUP BY b.stock_name;
