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
-- 2. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================
