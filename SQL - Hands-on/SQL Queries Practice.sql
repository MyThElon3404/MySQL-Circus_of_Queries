-- ==========================================================================================
-- 			SQL Queries
-- ==========================================================================================

# Q1. Delete duplicate data from cars table (Example Table)
-- create a cars table
drop table if exists cars;
create table cars(
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

select * from cars;

# SOLUTION :

-- Solution 1: using sub-query
delete from cars
where model_id not in (select min(model_id)
					  from cars
					  group by model_name, brand);

-- Solution 2: using row_number window function
delete from cars
where model_id in (select model_id
                  from (select *
                       , row_number() over(partition by model_name, brand order by model_id) as rn
                       from cars) x
                  where x.rn > 1);
-- =========================================================================================================

# Q2. Display highest and lowest salary from employee table
-- create a emplyee table
drop table if exists employee;
create table employee(
	id 		int primary key GENERATED ALWAYS AS IDENTITY,
	name 		varchar(100),
	dept 		varchar(100),
	salary 		int
);
insert into employee values(default, 'Alexander', 'Admin', 6500);
insert into employee values(default, 'Leo', 'Finance', 7000);
insert into employee values(default, 'Robin', 'IT', 2000);
insert into employee values(default, 'Ali', 'IT', 4000);
insert into employee values(default, 'Maria', 'IT', 6000);
insert into employee values(default, 'Alice', 'Admin', 5000);
insert into employee values(default, 'Sebastian', 'HR', 3000);
insert into employee values(default, 'Emma', 'Finance', 4000);
insert into employee values(default, 'John', 'HR', 4500);
insert into employee values(default, 'Kabir', 'IT', 8000);

select * from employee;

# SOLUTION : using window function (aggregate with window) - pls check window function TUT

select * 
, max(salary) over(partition by dept order by salary desc) as highest_sal
, min(salary) over(partition by dept order by salary desc
                  range between unbounded preceding and unbounded following) as lowest_sal
from employee;

-- =============================================================================================================

# Q3. Find actual distance
	
drop table if exists car_travels;
create table car_travels(
    cars                    varchar(40),
    days                    varchar(10),
    cumulative_distance     int
);
insert into car_travels values ('Car1', 'Day1', 50);
insert into car_travels values ('Car1', 'Day2', 100);
insert into car_travels values ('Car1', 'Day3', 200);
insert into car_travels values ('Car2', 'Day1', 0);
insert into car_travels values ('Car3', 'Day1', 0);
insert into car_travels values ('Car3', 'Day2', 50);
insert into car_travels values ('Car3', 'Day3', 50);
insert into car_travels values ('Car3', 'Day4', 100);

select * from car_travels;

# SOLUTION : using lag window function (pls check Tutorials for window functions)

select *
, cumulative_distance - lag(cumulative_distance, 1, 0) over(partition by cars order by days) as distance_travelled
from car_travels;

-- =================================================================================================================

# Q4. Convert the given input to expected output

drop table if exists src_dest_distance;
create table src_dest_distance
(
    source          varchar(20),
    destination     varchar(20),
    distance        int
);
insert into src_dest_distance values ('Bangalore', 'Hyderbad', 400);
insert into src_dest_distance values ('Hyderbad', 'Bangalore', 400);
insert into src_dest_distance values ('Mumbai', 'Delhi', 400);
insert into src_dest_distance values ('Delhi', 'Mumbai', 400);
insert into src_dest_distance values ('Chennai', 'Pune', 400);
insert into src_dest_distance values ('Pune', 'Chennai', 400);

select * from src_dest_distance;

# SOLUTION : using cte, window function and self join

with cte as(
	select *, 
		row_number() over() as rn
    	from src_dest_distance
)
select t1.source, t1.destination, t1.distance
from cte t1
join cte t2
        on t1.rn < t2.rn
        and t1.source = t2.destination
        and t1.destination = t2.source;

