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
-- 2. Person and type is the column names and it is the input table
-- We need output as pair table
-- Like these are adult and child in the table and they are going for a fair and they have a ride on some jhoola, 
-- so one adult can go with one child and is last one adult will be alone

create table family (
	person varchar(5),
	type varchar(10),
	age int
);

insert into family 
values 
('A1','Adult',54),('A2','Adult',53),
('A3','Adult',52),('A4','Adult',58),
('A5','Adult',54),('C1','Child',20),
('C2','Child',19),('C3','Child',22),
('C4','Child',15);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with adult_cte as (
	SELECT Person AS Adult, 
		ROW_NUMBER() OVER (ORDER BY Person) AS RowNum
	FROM family
	WHERE Type = 'Adult'
),
	child_cte as (
		SELECT Person AS Child, 
			ROW_NUMBER() OVER (ORDER BY Person) AS RowNum
		FROM family
		WHERE Type = 'Child'
	)
select a.Adult, COALESCE(c.Child, '') as Child 
from adult_cte a
left join child_cte c
	on a.RowNum = c.RowNum;

-- ==================================================================================================================================
