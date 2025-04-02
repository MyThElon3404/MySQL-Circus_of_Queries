-- QUESTION : 1
-- 1. Calculate each user's average session time, 
-- where a session is defined as the time difference between a page_load and a page_exit. 
-- Assume each user has only one session per day. If there are multiple page_load or page_exit events on the same day, 
-- use only the latest page_load and the earliest page_exit, ensuring the page_load occurs before the page_exit. 
-- Output the user_id and their average session time.

CREATE TABLE facebook_web_log (
    user_id INT,
    timestamp DATETIME,
    action VARCHAR(20)
);

INSERT INTO facebook_web_log (user_id, timestamp, action) 
  VALUES
(0, '2019-04-25 13:30:15', 'page_load'),
(0, '2019-04-25 13:30:18', 'page_load'),
(0, '2019-04-25 13:30:40', 'scroll_down'),
(0, '2019-04-25 13:30:45', 'scroll_up'),
(0, '2019-04-25 13:31:10', 'scroll_down'),
(0, '2019-04-25 13:31:25', 'scroll_down'),
(0, '2019-04-25 13:31:40', 'page_exit'),
(1, '2019-04-25 13:40:00', 'page_load'),
(1, '2019-04-25 13:40:10', 'scroll_down'),
(1, '2019-04-25 13:40:15', 'scroll_down'),
(1, '2019-04-25 13:40:20', 'scroll_down'),
(1, '2019-04-25 13:40:25', 'scroll_down'),
(1, '2019-04-25 13:40:30', 'scroll_down'),
(1, '2019-04-25 13:40:35', 'page_exit'),
(2, '2019-04-25 13:41:21', 'page_load'),
(2, '2019-04-25 13:41:30', 'scroll_down'),
(2, '2019-04-25 13:41:35', 'scroll_down'),
(2, '2019-04-25 13:41:40', 'scroll_up'),
(1, '2019-04-26 11:15:00', 'page_load'),
(1, '2019-04-26 11:15:10', 'scroll_down'),
(1, '2019-04-26 11:15:20', 'scroll_down'),
(1, '2019-04-26 11:15:25', 'scroll_up'),
(1, '2019-04-26 11:15:35', 'page_exit'),
(0, '2019-04-28 14:30:15', 'page_load'),
(0, '2019-04-28 14:30:10', 'page_load'),
(0, '2019-04-28 13:30:40', 'scroll_down'),
(0, '2019-04-28 15:31:40', 'page_exit');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- Solution 1 - Using cte and group by
with page_load_cte as (
	select
		user_id,
		CAST(timestamp as date) as session_date,
		max(timestamp) as latest_page_load
	from facebook_web_log
	where action = 'page_load'
	group by user_id, CAST(timestamp as date)
),
	page_exit_cte as (
		select
			user_id,
			CAST(timestamp as date) as session_date,
			min(timestamp) as earliest_page_exit
		from facebook_web_log
		where action = 'page_exit'
		group by user_id, CAST(timestamp as date)
),
	session_duration_cte as (
		select
			pl.user_id,
			DATEDIFF(SECOND, pl.latest_page_load, pe.earliest_page_exit) as session_duration
		from page_load_cte pl
		join page_exit_cte pe
			on pl.session_date = pe.session_date
			and pl.user_id = pe.user_id
		where pl.latest_page_load < pe.earliest_page_exit
	)
select
	user_id,
	AVG(session_duration) as avg_session_duration
from session_duration_cte
group by user_id;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Find IDs of LinkedIn users who were employed at Google on November 1st, 2021. 
-- Do not consider users who started or ended their employment at Google on that day 
-- but do include users who changed their position within Google on that day.

CREATE TABLE employment_history (
    user_id INT,
    employer VARCHAR(50),
    position VARCHAR(50),
    start_date DATE,
    end_date DATE
);
INSERT INTO employment_history (user_id, employer, position, start_date, end_date)
VALUES 
    (1, 'Microsoft', 'developer', '2020-04-13', '2021-11-01'),
    (1, 'Google', 'developer', '2021-11-01', NULL),
    (2, 'Google', 'manager', '2021-01-01', '2021-01-11'),
    (2, 'Microsoft', 'manager', '2021-01-11', NULL),
    (3, 'Microsoft', 'analyst', '2019-03-15', '2020-07-24'),
    (3, 'Amazon', 'analyst', '2020-08-01', '2020-11-01'),
    (3, 'Google', 'senior analyst', '2020-11-01', '2021-03-04'),
    (4, 'Google', 'junior developer', '2018-06-01', '2021-11-01'),
    (4, 'Google', 'senior developer', '2021-11-01', NULL),
    (5, 'Microsoft', 'manager', '2017-09-26', NULL),
    (6, 'Google', 'CEO', '2015-10-02', NULL);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- Solution 1 - Simple and & between
SELECT distinct user_id
FROM employment_history
WHERE employer = 'Google'
AND '2021-11-01' BETWEEN start_date AND COALESCE(end_date, '9999-12-31')
AND start_date != '2021-11-01'
AND end_date != '2021-11-01';

-- Solution 2 - 
SELECT DISTINCT user_id 
FROM employment_history
WHERE employer = 'Google'
AND start_date < '2021-11-01'
AND (end_date IS NULL OR end_date > '2021-11-01');

-- ==================================================================================================================================

-- QUESTION : 3
-- 3. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================
