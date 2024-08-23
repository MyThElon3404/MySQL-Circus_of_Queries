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
-- 2. Determine the users who have posted more than 2 times in the past week and calculate the total number of likes
-- they have received. Return user_id and number of post and no of likes

drop table if exists posts;
CREATE TABLE posts (
    post_id INT PRIMARY KEY,
    user_id INT,
    likes INT,
    post_date DATE
);
INSERT INTO posts (post_id, user_id, likes, post_date) 
VALUES
	(1, 101, 50, '2024-02-27'),	(2, 102, 30, '2024-02-28'),
	(3, 103, 70, '2024-02-29'), (4, 101, 80, '2024-02-01'),
	(5, 102, 40, '2024-02-02'), (6, 103, 60, '2024-02-29'),
	(7, 101, 90, '2024-01-29'), (8, 101, 20, '2024-02-05'),
	(9, 102, 50, '2024-01-29'), (10, 103, 30, '2024-02-29'),
	(11, 101, 60, '2024-01-08'), (12, 102, 70, '2024-01-09'),
	(13, 103, 80, '2024-01-10'), (14, 101, 40, '2024-01-29'),
	(15, 102, 90, '2024-01-29'), (16, 103, 20, '2024-01-13'),
	(17, 101, 70, '2024-01-14'), (18, 102, 50, '2024-02-29'),
	(19, 103, 30, '2024-02-16'), (20, 101, 60, '2024-02-17');

select * from posts;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with current_date_cte as (
	select min(post_date) as first_date
	from posts
)
select user_id,
	count(post_id) as total_post,
	sum(likes) as total_likes
from posts
where post_date >= (select first_date from current_date_cte)
	and post_date <= DATEADD(DAY, 7, (select first_date from current_date_cte))
group by user_id
having count(post_id) >= 2;

-- ==================================================================================================================================
