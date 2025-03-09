-- QUESTION : 1
-- 1. If a person do a task on a regular basis and the output of the task is either success or fail.

-- suppose:
-- Case 1 :
2022-01-01 - success
2022-01-02 - success
2022-01-03 - fail
2022-01-04 - success
2022-01-05 - fail
2022-01-06 - fail
2022-01-07 - fail
2022-01-08 - success

-- now my task is to write a query so that the output is like:

-- start_date    end_date      result
-- 2022-01-01   2022-01-02    success
-- 2022-01-03   2022-01-03    fail
-- 2022-01-04 	 2022-01-04    success
-- 2022-01-05   2022-01-07    fail
-- 2022-01-08   2022-01-08    success

--          OR (year wise)

-- Case 2 :

2019-01-01	success
2019-01-02	success
2019-01-03	success
2019-01-04	fail
2019-01-05	fail
2019-01-06	success
2022-01-01	success
2022-01-02	success
2022-01-03	fail
2022-01-04	success
2022-01-05	fail
2022-01-06	fail
2022-01-07	fail
2022-01-08	success

-- 2019-01-03	2019-01-01	success
-- 2019-01-05	2019-01-04	fail
-- 2019-01-06	2019-01-06	success
-- 2022-01-02	2022-01-01	success
-- 2022-01-03	2022-01-03	fail
-- 2022-01-04	2022-01-04	success
-- 2022-01-07	2022-01-05	fail
-- 2022-01-08	2022-01-08	success
  
drop table if exists tasks;
create table tasks (
	date_value date,
	state varchar(10)
);
insert into tasks  values 
('2019-01-01','success'),
('2019-01-02','success'),
('2019-01-03','success'),
('2019-01-04','fail'),
('2019-01-05','fail'),
('2019-01-06','success'),
('2022-01-01','success'),
('2022-01-02','success'),
('2022-01-03','fail'),
('2022-01-04','success'),
('2022-01-05','fail'),
('2022-01-06','fail'),
('2022-01-07','fail'),
('2022-01-08','success');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1 : CASE 1

with state_date as (
	select *,
		row_number() over(partition by state order by date_value) as state_rn,
		row_number() over(order by date_value) as date_rn
	from tasks
),
	state_date_diff as (
		select date_value, state,
			(date_rn - state_rn) as diff
		from state_date
	)
select min(date_value) as start_date,
	max(date_value) as end_date,
	state
from state_date_diff
group by state, diff
order by start_date;

-- SOLUTION 1 : CASE 2

with state_date as (
	select *,
		DATEPART(YEAR, date_value) as date_value_year,
		row_number() over(partition by state, DATEPART(YEAR, date_value) 
			order by date_value) as state_rn,
		row_number() over(order by date_value) as date_rn
	from tasks
),
	state_date_diff as (
		select date_value, state,
			(date_rn - state_rn) as diff
		from state_date
	)
select min(date_value) as start_date,
	max(date_value) as end_date,
	state
from state_date_diff
group by state, diff
order by start_date;
