-- QUESTION : 1
-- 1. From the given CARS table, delete the records where car details are duplicated

drop table if exists cars;
create table cars (
	model_id		int primary key,
	model_name		varchar(100),
	color			varchar(100),
	brand			varchar(100)
);
insert into cars values(1,'Leaf', 'Black', 'Nissan');
insert into cars values(2,'Leaf', 'Black', 'Nissan');
insert into cars values(3,'Model S', 'Black', 'Tesla');
insert into cars values(4,'Model X', 'White', 'Tesla');
insert into cars values(5,'Ioniq 5', 'Black', 'Hyundai');
insert into cars values(6,'Ioniq 5', 'Black', 'Hyundai');
insert into cars values(7,'Ioniq 6', 'White', 'Hyundai');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1: Using CTE and RANK window function
with car_cte as (
	select *,
		RANK() over(partition by model_name, color, brand order by model_id) as car_rk
	from cars
)
delete from car_cte
where car_rk = 2;

-- SOLUTION 2: Using sub-query
delete from cars
where model_id not in (
	select min(model_id)
	from cars
	group by model_name, color, brand
);

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================
