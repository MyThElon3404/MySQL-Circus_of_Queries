-- QUESTION : 1
-- 1. Since some IDs have been removed from Logs. 
-- Write an SQL query to find the start and end number of continuous ranges in table Logs.
-- Order the result table by start_id.

CREATE TABLE Logs (
    log_id INT PRIMARY KEY
);
INSERT INTO Logs (log_id) 
VALUES 
(1), (2), (3), (7), (8), (10);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with cte as (
  select log_id,
  log_id - row_number() over(order by log_id) as rn
  from Logs
)
select min(log_id) as start_num,
  max(log_id) as end_num
from cte
group by rn;

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
