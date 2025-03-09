-- QUESTION : 1
-- 1. Identify the top 3 posts with the highest engagement (likes + comments) for each user on a Facebook page. 
-- Display the user ID, post ID, engagement count, and rank for each post.

DROP TABLE IF EXISTS fb_posts;
CREATE TABLE fb_posts (
    post_id INT PRIMARY KEY,
    user_id INT,
    likes INT,
    comments INT,
    post_date DATE
);
INSERT INTO fb_posts (post_id, user_id, likes, comments, post_date) 
VALUES
	(1, 101, 50, 20, '2024-02-27'), (2, 102, 30, 15, '2024-02-28'),
	(3, 103, 70, 25, '2024-02-29'), (4, 101, 80, 30, '2024-03-01'),
	(5, 102, 40, 10, '2024-03-02'), (6, 103, 60, 20, '2024-03-03'),
	(7, 101, 90, 35, '2024-03-04'), (8, 101, 90, 35, '2024-03-05'),
	(9, 102, 50, 15, '2024-03-06'), (10, 103, 30, 10, '2024-03-07'),
	(11, 101, 60, 25, '2024-03-08'), (12, 102, 70, 30, '2024-03-09'),
	(13, 103, 80, 35, '2024-03-10'), (14, 101, 40, 20, '2024-03-11'),
	(15, 102, 90, 40, '2024-03-12'), (16, 103, 20, 5, '2024-03-13'),
	(17, 101, 70, 25, '2024-03-14'), (18, 102, 50, 15, '2024-03-15'),
	(19, 103, 30, 10, '2024-03-16'), (20, 101, 60, 20, '2024-03-17');

SELECT * FROM fb_posts;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with engagement_rank_cte as (
	select user_id, post_id,
		sum(likes + comments) as engagement_count,
		-- row_number() over(partition by user_id order by sum(likes + comments) desc) as eg_rn
		dense_rank() over(partition by user_id order by sum(likes + comments) desc) as eg_rn
		-- rank() over(partition by user_id order by sum(likes + comments) desc) as eg_rn
	from fb_posts
	group by user_id, post_id
)
select *
from engagement_rank_cte
where eg_rn <= 3
order by user_id, engagement_count desc;

-- NOTE : Use rank functions (row_number, dense_rank, rank) acccording to situation

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
