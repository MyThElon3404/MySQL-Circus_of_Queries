-- ==========================================================================================
-- 			SQL Queries
-- ==========================================================================================

# Q. Delete duplicate data from cars table (Example Table)
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

# Q. Display highest and lowest salary from employee table
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

# Q. Find actual distance
	
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

# Q. Convert the given input to expected output

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

-- =================================================================================================================

# Q. Write a SQL query to find the second highest salary from the table emp. (Column name – id, salary)

drop table if exists emp_salary;
create table emp_salary (
	id int,
  	salary int
);

insert into emp_salary
values (1, 50000), (2, 60000), (3, 45000), (4, 70000), (5, 55000),
	(6, 80000), (7, 40000), (8, 72000), (9, 68000), (10, 59000);

select * from emp_salary
order by salary desc;

-- SOLUTION 1 : using limit

select * from emp_salary
order by salary desc
limit 1, 1; -- first value skip no of rows and second value display limited rows
-- here skip 1 row and display 1 row

-- SOLUTION 2 : using limit and offset

select * from emp_salary
order by salary desc
limit 1 -- display 1 row
offset 1; -- skip 1 row

-- SOLUTION 3 : using sub-query

select *
from emp_salary
where salary < (
	select max(salary) from emp_salary
)
order by salary desc
limit 1;

-- SOLUTION 4 : using CTE
with salary_cte as (
	select *,
  		row_number() over(order by salary desc) as salary_rnum
  	from emp_salary
)
select id, salary from salary_cte
where salary_rnum = 2;

-- =================================================================================================================

# Q. Write a SQL query to find the numbers which consecutively occurs 3 
	number_tb (Column name – id, numbers)

drop table if exists number_tb;
create table number_tb (
	id int not null,
  	number int not null
);

insert into number_tb
values (1, 5), (2, 2), (3, 2), (4, 2), (5, 7), (6, 7), (7, 7),
	(8, 3), (9, 3), (10, 3), (11, 4), (12, 4), (13, 4), (14, 4);

select * from number_tb;

-- SOLUTION 1 : using self join

select distinct t1.number as number_occurance
from number_tb as t1
join number_tb as t2 on t1.id = t2.id - 1
join number_tb as t3 on t2.id = t3.id - 1
where t1.number = t2.number
	and t2.number = t3.number;

-- SOLUTION 2 : using CTE and window function

with number_cte as (
	select id, number,
  		lag(number, 1) over (order by id) as prev,
  		lag(number, 2) over (order by id) as prev_prev
  	from number_tb
)
select distinct number
from number_cte
where number = prev
	and number = prev_prev;

-- =================================================================================================================

# Q. Write a SQL query to find the days when temperature was higher than its prev day - 
	temp_tb (Column name – Days, Temp)

drop table if exists temperature_tb;
create table temperature_tb (
	days int not null,
  	temperatures int not null
);

insert into temperature_tb
values (1, 25), (2, 28), (3, 27), 
	(4, 30), (5, 26), (6, 32), (7, 31), (8, 35);

select * from temperature_tb;

-- SOLUTION 1 : using self join

select t1.days, t1.temperatures
from temperature_tb as t1
join temperature_tb as t2 on t1.days = t2.days + 1
where t1.temperatures > t2.temperatures;

-- SOLUTION 2 : using CTE and window function

with temp_rank_cte as (
	select days, temperatures,
  		lag(temperatures, 1) over (order by days) as prev_temp
  	from temperature_tb
)
select days, temperatures
from temp_rank_cte
where temperatures > prev_temp;

-- SOLUTION 3 : using sub-queries

select days, temperatures
from temperature_tb
where temperatures > (
	select temperatures
  	from temperature_tb as t2
  	where t2.days = temperature_tb.days - 1
)

-- =================================================================================================================
