-- QUESTION : 1
-- 1. Write a query to replace rent at null value

create table tb (
	id int,
  	rent int
);

insert into tb
value
(1, 150),
(2, null),
(3, null),
(4, null),
(5, 100),
(6, null),
(7, null),
(8, null);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- 1. Using CTE
with cte_1 as (
	SELECT id, rent,
		count(rent) OVER (ORDER BY id) AS rn
	FROM tb
)
select id,
	max(rent) over(partition by rn) as new_rent
from cte_1;

-- 2. Using recursive CTE
WITH RECURSIVE cte AS (
    -- Base case: Select the first row
    SELECT id, rent
    FROM tb
    WHERE id = 1

    UNION ALL

    -- Recursive case: Propagate the previous value for subsequent rows
    SELECT t.id, 
           CASE
               WHEN t.rent IS NOT NULL THEN t.rent
               ELSE cte.rent
           END AS rent
    FROM tb t
    JOIN cte ON t.id = cte.id + 1
)
SELECT id, rent
FROM cte;

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
