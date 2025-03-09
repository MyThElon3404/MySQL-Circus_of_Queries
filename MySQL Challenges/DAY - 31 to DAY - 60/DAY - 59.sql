-- QUESTION : 1
-- 1. Active User Retention
-- Assume you're given a table containing information on Facebook user actions. 
-- Write a query to obtain number of monthly active users (MAUs) in July 2022, 
-- including the month in numerical format "1, 2, 3".

-- Hint:
-- An active user is defined as a user who has performed actions such as 'sign-in', 'like', or 'comment' in 
-- both the current month and the previous month.

DROP TABLE IF EXISTS user_actions;
CREATE TABLE user_actions (
    user_id INT,
    event_id INT,
    event_type VARCHAR(50),
    event_date DATETIME
);

INSERT INTO user_actions (user_id, event_id, event_type, event_date)
VALUES 
    (445, 7765, 'sign-in', '2022-05-31 12:00:00'),
    (445, 3634, 'like', '2022-06-05 12:00:00'),
    (648, 3124, 'like', '2022-06-18 12:00:00'),
    (648, 2725, 'sign-in', '2022-06-22 12:00:00'),
    (648, 8568, 'comment', '2022-07-03 12:00:00'),
    (445, 4363, 'sign-in', '2022-07-05 12:00:00'),
    (445, 2425, 'like', '2022-07-06 12:00:00'),
    (445, 2484, 'like', '2022-07-22 12:00:00'),
    (648, 1423, 'sign-in', '2022-07-26 12:00:00'),
    (445, 5235, 'comment', '2022-07-29 12:00:00'),
    (742, 6458, 'sign-in', '2022-07-03 12:00:00'),
    (742, 1374, 'comment', '2022-07-19 12:00:00');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with MAU_cte as (
	select user_id, event_date,
		MONTH(event_date) as month,
		lag(MONTH(event_date)) over(partition by user_id order by event_date) as pres_month
	from user_actions
	where event_type in ('sign-in', 'like', 'comment')
		and MONTH(event_date) in (6, 7)
)
select distinct month,
	count(distinct user_id) as active_user_cnt
from MAU_cte
where month = 7 and pres_month = 6
	and YEAR(event_date) = 2022
group by month;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Assume you're given a table containing information about Wayfair user transactions for different products. 
-- Write a query to calculate the year-on-year growth rate for the total spend of each product, grouping the results by product ID.

-- The output should include the year in ascending order, product ID, current year's spend, 
-- previous year's spend and year-on-year growth percentage, rounded to 2 decimal places.


DROP TABLE IF EXISTS user_transactions;
CREATE TABLE user_transactions (
    transaction_id INT PRIMARY KEY,
    product_id INT,
    spend DECIMAL(10,2),
    transaction_date DATETIME
);

INSERT INTO user_transactions (transaction_id, product_id, spend, transaction_date) 
	VALUES
(1341, 123424, 1500.60, '2019-12-31 12:00:00'),
(1423, 123424, 1000.20, '2020-12-31 12:00:00'),
(1623, 123424, 1246.44, '2021-12-31 12:00:00'),
(1322, 123424, 2145.32, '2022-12-31 12:00:00'),
(1344, 234412, 1800.00, '2019-12-31 12:00:00'),
(1435, 234412, 1234.00, '2020-12-31 12:00:00'),
(4325, 234412, 889.50, '2021-12-31 12:00:00'),
(5233, 234412, 2900.00, '2022-12-31 12:00:00'),
(2134, 543623, 6450.00, '2019-12-31 12:00:00'),
(1234, 543623, 5348.12, '2020-12-31 12:00:00'),
(2423, 543623, 2345.00, '2021-12-31 12:00:00'),
(1245, 543623, 5680.00, '2022-12-31 12:00:00');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

WITH current_spend_cte AS (
    SELECT 
        YEAR(transaction_date) AS years, 
        product_id,
        SUM(spend) AS current_year_spend
    FROM user_transactions
    GROUP BY YEAR(transaction_date), product_id
),
prev_spend_cte AS (
    SELECT *,
        LAG(current_year_spend) OVER (PARTITION BY product_id ORDER BY years) AS prev_year_spend
    FROM current_spend_cte
)
SELECT *,
    CASE 
        WHEN prev_year_spend IS NULL THEN NULL  -- NULL means no previous data
        ELSE ROUND(((current_year_spend - prev_year_spend) / prev_year_spend) * 100, 2) 
    END AS YOY_Growth_Rate_Per_Product
FROM prev_spend_cte
ORDER BY product_id, years;

-- ==================================================================================================================================
