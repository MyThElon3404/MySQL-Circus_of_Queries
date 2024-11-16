-- QUESTION : 1
-- 1. Assume you're given tables with information on Snapchat users, including their ages and time spent sending and opening snaps. 
-- Write an SQL query to obtain a breakdown of the time spent sending vs. opening snaps as a percentage of total time spent on these activities,
-- grouped by age group. Round the percentages to 2 decimal places.

-- 𝑪𝒂𝒍𝒄𝒖𝒍𝒂𝒕𝒆 𝒕𝒉𝒆 𝒇𝒐𝒍𝒍𝒐𝒘𝒊𝒏𝒈 𝒑𝒆𝒓𝒄𝒆𝒏𝒕𝒂𝒈𝒆𝒔:

-- Time spent sending / (Time spent sending + Time spent opening)
-- Time spent opening / (Time spent sending + Time spent opening)
-- To avoid integer division in percentages, multiply by 100.0 and not 100.

DROP TABLE IF EXISTS activities;
CREATE TABLE activities (
 activity_id INTEGER,
 user_id INTEGER,
 activity_type VARCHAR(6), -- 'send', 'open', 'chat'
 time_spent FLOAT,
 activity_date DATETIME
);
INSERT INTO activities (activity_id, user_id, activity_type, time_spent, activity_date) 
VALUES
(7274, 123, 'open', 4.50, '2022-06-22 12:00:00'),
(2425, 123, 'send', 3.50, '2022-06-22 12:00:00'),
(1413, 456, 'send', 5.67, '2022-06-23 12:00:00'),
(1414, 789, 'chat', 11.00, '2022-06-25 12:00:00'),
(2536, 456, 'open', 3.00, '2022-06-25 12:00:00');


DROP TABLE IF EXISTS age_breakdown;
CREATE TABLE age_breakdown (
 user_id INTEGER,
 age_bucket VARCHAR(6) -- e.g., '21-25', '26-30', '31-35'
);
INSERT INTO age_breakdown (user_id, age_bucket) VALUES
(123, '31-35'),
(456, '26-30'),
(789, '21-25');

select * from activities;
select * from age_breakdown;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with send_open_spent_time as (
	select ab.age_bucket as age_group,
		sum(case when activity_type='send' then time_spent else 0 end) as send_spent_time,
		sum(case when activity_type='open' then time_spent else 0 end) as open_spent_time
	from activities as att
	join age_breakdown as ab
		on att.user_id = ab.user_id
	where att.activity_type in ('send', 'open')
	group by ab.age_bucket
)
select age_group,
	round((send_spent_time)*100.0 / (send_spent_time+open_spent_time), 2) as send_perc,
	round((open_spent_time)*100.0 / (send_spent_time+open_spent_time), 2) as open_perc
from send_open_spent_time;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. We are changing some condition of above questions
-- what if for any age group send time or open time is null


DROP TABLE IF EXISTS activities;
CREATE TABLE activities (
    activity_id INTEGER PRIMARY KEY,
    user_id INTEGER,
    activity_type VARCHAR(6), -- 'send', 'open', 'chat'
    time_spent FLOAT,
    activity_date DATETIME
);
INSERT INTO activities (activity_id, user_id, activity_type, time_spent, activity_date) 
VALUES
(7274, 123, 'open', 4.50, '2022-06-22 12:00:00'),
(2425, 123, 'send', 3.50, '2022-06-22 12:00:00'),
(1413, 456, 'send', 5.67, '2022-06-23 12:00:00'),
(1414, 789, 'chat', 11.00, '2022-06-25 12:00:00'),
(2536, 456, 'open', 3.00, '2022-06-25 12:00:00'),
(3411, 101, 'open', NULL, '2022-06-26 14:00:00'), -- NULL time_spent case
(4512, 202, 'send', 2.00, '2022-06-27 15:00:00'), -- User in 21-25 age group
(4623, 101, 'send', NULL, '2022-06-28 16:00:00'), -- NULL time_spent case
(5284, 303, 'open', 3.75, '2022-06-29 17:00:00');



DROP TABLE IF EXISTS age_breakdown;
CREATE TABLE age_breakdown (
    user_id INTEGER PRIMARY KEY,
    age_bucket VARCHAR(6) -- e.g., '21-25', '26-30', '31-35'
);
INSERT INTO age_breakdown (user_id, age_bucket) VALUES
(123, '31-35'), -- User 123 in age group 31-35
(456, '26-30'), -- User 456 in age group 26-30
(789, '21-25'), -- User 789 in age group 21-25
(101, '31-35'), -- User 101 in age group 31-35
(202, '21-25'), -- User 202 in age group 21-25
(303, '26-30'); -- User 303 in age group 26-30

select * from activities;
select * from age_breakdown;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with send_open_spent_time as (
	select ab.age_bucket as age_group,
		coalesce(sum(case when activity_type='send' then time_spent end), 0) as send_spent_time,
		coalesce(sum(case when activity_type='open' then time_spent end), 0) as open_spent_time
	from activities as att
	join age_breakdown as ab
		on att.user_id = ab.user_id
	where att.activity_type in ('send', 'open')
	group by ab.age_bucket
)
select age_group,
	case
		when send_spent_time = 0 then 0
		else round(send_spent_time*100.0 / (send_spent_time + open_spent_time), 2) 
	end as send_prec,
	case
		when open_spent_time = 0 then 0
		else round(open_spent_time*100.0 / (send_spent_time + open_spent_time), 2) 
	end as open_prec
from send_open_spent_time;

-- ==================================================================================================================================
