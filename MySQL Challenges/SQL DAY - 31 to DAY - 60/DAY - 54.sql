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
-- 2. we need to find number of employees inside the hospital.

create table hospital ( 
	emp_id int, 
	action varchar(10), 
	time datetime
);

insert into hospital values ('1', 'in', '2019-12-22 09:00:00');
insert into hospital values ('1', 'out', '2019-12-22 09:15:00');
insert into hospital values ('2', 'in', '2019-12-22 09:00:00');
insert into hospital values ('2', 'out', '2019-12-22 09:15:00');
insert into hospital values ('2', 'in', '2019-12-22 09:30:00');
insert into hospital values ('3', 'out', '2019-12-22 09:00:00');
insert into hospital values ('3', 'in', '2019-12-22 09:15:00');
insert into hospital values ('3', 'out', '2019-12-22 09:30:00');
insert into hospital values ('3', 'in', '2019-12-22 09:45:00');
insert into hospital values ('4', 'in', '2019-12-22 09:45:00');
insert into hospital values ('5', 'out', '2019-12-22 09:40:00');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1: 
with cte as (
	select emp_id,
		count(case when action = 'in' then 1 end) as emp_in_cnt,
		count(case when action = 'out' then 1 end) as emp_out_cnt
	from hospital
	group by emp_id
	having count(case when action = 'in' then 1 end) > 0
)
select emp_id
from cte
where emp_in_cnt != emp_out_cnt;

-- SOLUTION 2: 
with cte as (
	select emp_id,
		max(case when action = 'in' then time end) as max_in_time,
		max(case when action = 'out' then time end) as max_out_time
	from hospital
	group by emp_id
	having max(case when action = 'in' then time end) is not null
)
select emp_id
from cte
where max_in_time > max_out_time 
	or max_out_time is null;

-- ==================================================================================================================================
