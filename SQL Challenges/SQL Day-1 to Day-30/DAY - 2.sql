-- QUESTION 1 :

-- 1. Write a SQL query to retrieve the IDs of the Facebook pages that have zero likes. 
-- The output should be sorted in ascending order based on the page IDs.

drop table if exists pages;
CREATE TABLE pages (
    page_id INTEGER PRIMARY KEY,
    page_name VARCHAR(255)
);

-- Insert data into pages table
INSERT INTO pages (page_id, page_name) 
VALUES
	(20001, 'SQL Solutions'),
	(20045, 'Brain Exercises'),
	(20701, 'Tips for Data Analysts');

drop table if exists page_likes;
CREATE TABLE page_likes (
    user_id INTEGER,
    page_id INTEGER,
    liked_date DATETIME,
    FOREIGN KEY (page_id) REFERENCES pages(page_id)
);

-- Insert data into page_likes table
INSERT INTO page_likes (user_id, page_id, liked_date) 
VALUES
	(111, 20001, '2022-04-08 00:00:00'),
	(121, 20045, '2022-03-12 00:00:00'),
	(156, 20001, '2022-07-25 00:00:00');

select * from pages;
select * from page_likes;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

select pg.page_id
from pages as pg
left join page_likes as pl
	on pg.page_id = pl.page_id
group by pg.page_id
having count(pl.page_id)=0
order by pg.page_id asc;

-- ==================================================================================================================================

-- QUESTION 2 :

-- 2. Write a query to calculate the click-through rate (CTR) for the app in 2022 and round the results to 2 decimal places.
-- Definition and note:
-- Percentage of click-through rate (CTR) = 100.0 * Number of clicks / Number of impressions
-- To avoid integer division, multiply the CTR by 100.0, not 100.
-- Expected Output Columns: app_id, ctr

drop table if exists events;
CREATE TABLE events (
    app_id INTEGER,
    event_type VARCHAR(10),
    timestamp DATETIME
);

-- Insert records into the events table
INSERT INTO events (app_id, event_type, timestamp) VALUES
(123, 'impression', '2022-07-18 11:36:12'),
(123, 'impression', '2022-07-18 11:37:12'),
(123, 'click', '2022-07-18 11:37:42'),
(234, 'impression', '2022-07-18 14:15:12'),
(234, 'click', '2022-07-18 14:16:12');

select * from events;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

select app_id,
	ROUND((100.0*cast(sum(case when event_type='click' then 1 end) as float)) /
	(cast(count(*) as float)), 2) as ctr
from events
where year(timestamp) = '2022'
group by app_id;

-- ==================================================================================================================================
