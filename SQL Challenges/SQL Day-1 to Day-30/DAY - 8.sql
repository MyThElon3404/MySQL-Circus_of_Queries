-- QUESTION : 1
-- 1. Write a query to obtain a histogram of tweets posted per user in 2022. 
-- Output the tweet count per user as the bucket and 
-- the number of Twitter users who fall into that bucket.

drop table if exists tweets;
CREATE TABLE tweets (
    tweet_id INTEGER,
    user_id INTEGER,
    msg VARCHAR(255),
    tweet_date TIMESTAMP
);

-- Insert sample records
INSERT INTO tweets (tweet_id, user_id, msg, tweet_date) VALUES
(214252, 111, 'Am considering taking Tesla private at $420. Funding secured.', '2021-12-30 00:00:00'),
(739252, 111, 'Despite the constant negative press covfefe', '2022-01-01 00:00:00'),
(846402, 111, 'Following @NickSinghTech on Twitter changed my life!', '2022-02-14 00:00:00'),
(241425, 254, 'If the salary is so competitive why won’t you tell me what it is?', '2022-03-01 00:00:00'),
--(231574, 148, 'I no longer have a manager. I can\'t be managed', '2022-03-23 00:00:00');

select * from tweets;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with tweet_count_per_user as (
  select user_id,
    count(tweet_id) as tweet_count
  from tweets
  where year(tweet_date)='2022'
  group by user_id
), 
  histogram as (
  select tweet_count as bucket,
    count(user_id) as num_users
  from tweet_count_per_user
  group by tweet_count
)
select
  bucket, num_users
from histogram;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Remove duplicate records if distance, source, destination is same
-- and keep the first occurrence only

DROP TABLE IF EXISTS city_distance;
CREATE TABLE city_distance (
    distance INT,
    source VARCHAR(512),
    destination VARCHAR(512)
);

INSERT INTO city_distance(distance, source, destination) 
VALUES 
	('100', 'New Delhi', 'Panipat'), ('200', 'Ambala', 'New Delhi'),
	('150', 'Bangalore', 'Mysore'), ('150', 'Mysore', 'Bangalore'),
	('250', 'Mumbai', 'Pune'), ('250', 'Pune', 'Mumbai'),
	('2500', 'Chennai', 'Bhopal'), ('2500', 'Bhopal', 'Chennai'),
	('60', 'Tirupati', 'Tirumala'), ('80', 'Tirumala', 'Tirupati');

select * from city_distance;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- 1. Using cte, row_number, left join

with rn_cte as (
	select *,
		ROW_NUMBER() over(order by (select null)) as rn
	from city_distance
)
select t1.distance as distance, t1.source as source, t1.destination as destination
from rn_cte as t1
left join rn_cte as t2
	on t1.source = t2.destination and t1.destination = t2.source
where t2.destination is null or t1.distance <> t2.distance or t1.rn < t2.rn;

-- 2. using self join and where clause

select t1.*
from city_distance as t1
left join city_distance as t2
	on t1.source = t2.destination and t2.source = t1.destination
where t2.distance is null or t1.distance <> t2.distance or t1.source < t2.source;

-- ==================================================================================================================================
