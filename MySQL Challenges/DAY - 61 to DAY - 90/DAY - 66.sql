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
-- 2. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================

-- QUESTION : 3
-- 3. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================
