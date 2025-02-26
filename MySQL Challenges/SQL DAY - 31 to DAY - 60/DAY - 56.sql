-- QUESTION : 1
-- 1. The problem is called as Most Popular Room Types.  In this problem we will learn how to convert comma separated values into row.
-- find the most popular room type. output with room type and no. of time it searches.

create table airbnb_searches (
	user_id int,
	date_searched date,
	filter_room_types varchar(200)
);

insert into airbnb_searches 
values
(1,'2022-01-01','entire home,private room')
,(2,'2022-01-02','entire home,shared room')
,(3,'2022-01-02','private room,shared room')
,(4,'2022-01-03','private room');


-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1: 
with cte as (
	select user_id, date_searched,
		TRIM(value) as room_type
	from airbnb_searches
	cross apply string_split(filter_room_types, ',')
)
select room_type,
	count(*) as num_time_searched
from cte
group by room_type
order by num_time_searched desc;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1: 


-- SOLUTION 2: 

-- ==================================================================================================================================
