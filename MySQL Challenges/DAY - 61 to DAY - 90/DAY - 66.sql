-- QUESTION : 1
-- 1. Write a sql query to calculate the average transaction amount per year for each client for the years 2018 to 2022. 

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    transaction_date DATE NOT NULL,
    transaction_amount DECIMAL(10, 2) NOT NULL
);

INSERT INTO transactions (transaction_id, user_id, transaction_date, transaction_amount)
  VALUES
    (1, 269, '2018-08-15', 500),
    (2, 478, '2018-11-25', 400),
    (3, 269, '2019-01-05', 1000),
    (4, 123, '2020-10-20', 600),
    (5, 478, '2021-07-05', 700),
    (6, 123, '2022-03-05', 900);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- Solution 1 - Using Group BY
select user_id,
	year(transaction_date) as trans_year,
	round(avg(transaction_amount), 2) as avg_trans_amount
from transaction_tb
where year(transaction_date) between 2018 and 2022
group by user_id, year(transaction_date)
order by user_id, trans_year, avg_trans_amount;

-- Solution 2 - Using CTE
with trans_cte as (
	select user_id,
		year(transaction_date) as trans_year,
		transaction_amount
	from transaction_tb
	where year(transaction_date) >= 2018
		and year(transaction_date) <= 2022
)
select user_id, trans_year,
	round(avg(transaction_amount), 2) as avg_trans_amount
from trans_cte
group by user_id, trans_year
order by user_id, trans_year, avg_trans_amount;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. You are given two tables: Customers and Orders. 
-- Your task is to calculate the 3-month moving average of sales revenue for each month, using the sales data in the Orders table.

CREATE TABLE Customers (
    Customer_id INT PRIMARY KEY,
    Name VARCHAR(100),
    Join_Date DATE
);

INSERT INTO Customers (Customer_id, Name, Join_Date) 
	VALUES
(1, 'John', '2023-01-10'),
(2, 'Simmy', '2023-02-15'),
(3, 'Iris', '2023-03-20');

CREATE TABLE Orders (
    Order_id INT PRIMARY KEY,
    Customer_id INT,
    Order_Date DATE,
    Amount DECIMAL(10,2),
    FOREIGN KEY (Customer_id) REFERENCES Customers(Customer_id)
);

INSERT INTO Orders (Order_id, Customer_id, Order_Date, Amount) 
	VALUES
(1, 1, '2023-01-05', 100.00),
(2, 2, '2023-02-14', 150.00),
(3, 1, '2023-02-28', 200.00),
(4, 3, '2023-03-22', 300.00),
(5, 2, '2023-04-10', 250.00),
(6, 1, '2023-05-15', 400.00),
(7, 3, '2023-06-10', 350.00);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- Solution 1 - Using AVG() with Window Function
with order_cte as (
	select format(order_date, 'yyyy-MM') as months,
	sum(amount) as total_amount
	from Order_tb
	group by format(order_date, 'yyyy-MM')
)
select months, total_amount,
	avg(total_amount) over(order by months rows between 2 preceding and current row) as moving_avg
from order_cte;

-- Solution 2 - Using LAG() and LEAD()
WITH order_cte AS (
    SELECT 
        FORMAT(order_date, 'yyyy-MM') AS months,
        SUM(amount) AS total_amount
    FROM Order_tb
    GROUP BY FORMAT(order_date, 'yyyy-MM')
)
SELECT 
    months, 
    total_amount,
    (total_amount 
        + COALESCE(LAG(total_amount, 1) OVER (ORDER BY months), 0) 
        + COALESCE(LAG(total_amount, 2) OVER (ORDER BY months), 0)) / 
    (1 
        + IIF(LAG(total_amount, 1) OVER (ORDER BY months) IS NOT NULL, 1, 0) 
        + IIF(LAG(total_amount, 2) OVER (ORDER BY months) IS NOT NULL, 1, 0)
    ) AS Moving_Avg_3_Months
FROM order_cte;

-- ==================================================================================================================================

-- QUESTION : 3
-- 3. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================
