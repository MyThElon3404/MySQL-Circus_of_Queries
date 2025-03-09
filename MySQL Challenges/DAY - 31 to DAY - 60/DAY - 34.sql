-- QUESTION : 1
-- 1. Write a query that returns binary description of rate type per loan_id. 
-- The results should have one row per loan_id and two columns: for fixed and variable type.

drop table if exists submissions;
CREATE TABLE submissions (
    id INT PRIMARY KEY,
    balance FLOAT,
    interest_rate FLOAT,
    rate_type VARCHAR(10),
    loan_id INT
);
INSERT INTO submissions (id, balance, interest_rate, rate_type, loan_id)
VALUES
(1, 5229.12, 8.75, 'variable', 2),
(2, 12727.52, 11.37, 'fixed', 4),
(3, 14996.58, 8.25, 'fixed', 9),
(4, 21149, 4.75, 'variable', 7),
(5, 14379, 3.75, 'variable', 5),
(6, 6221.12, 6.75, 'variable', 11),
(7, 5229.12, 8.75, 'fixed', 2),
(8, 12727.52, 11.37, 'variable', 4),
(9, 14996.58, 8.25, 'fixed', 9),
(10, 21149, 4.75, 'fixed', 7),
(11, 14379, 3.75, 'variable', 5),
(12, 6221.12, 6.75, 'fixed', 11);

select * from submissions;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

select loan_id,
	MAX(case
		when rate_type='fixed' then 1
		else 0
	end) as fixed_rate,
	MAX(case
		when rate_type='variable' then 1
		else 0
	end) as variable_rate
from submissions
group by loan_id;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Write a query that returns the rate_type, loan_id, loan balance , and a column that shows with 
-- what percentage the loan's balance contributes to the total balance among the loans of the same rate type.

drop table if exists submissions;
CREATE TABLE submissions (
    id INT PRIMARY KEY,
    balance FLOAT,
    interest_rate FLOAT,
    rate_type VARCHAR(10),
    loan_id INT
);
INSERT INTO submissions (id, balance, interest_rate, rate_type, loan_id)
VALUES
(1, 5229.12, 8.75, 'variable', 2),
(2, 12727.52, 11.37, 'fixed', 4),
(3, 14996.58, 8.25, 'fixed', 9),
(4, 21149, 4.75, 'variable', 7),
(5, 14379, 3.75, 'variable', 5),
(6, 6221.12, 6.75, 'variable', 11);

select * from submissions;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with sub_cte as (
	select *,
		sum(balance) over(partition by rate_type) as total_balance
	from submissions
)
select rate_type, loan_id,
	balance as loan_balance,
	total_balance,
	ROUND((balance / total_balance) * 100, 2) as percentage_contribution
from sub_cte;

-- ==================================================================================================================================
