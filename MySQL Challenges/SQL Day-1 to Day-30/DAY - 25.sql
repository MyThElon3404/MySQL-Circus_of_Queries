-- QUESTION : 1
-- 1. 3 or more consecutive empty seats
drop table if exists bms;
create table bms (
	seat_no int,
	is_empty varchar(10)
);
insert into bms 
values (1,'N')
,(2,'Y') ,(3,'N') ,(4,'Y')
,(5,'Y') ,(6,'Y') ,(7,'N')
,(8,'Y') ,(9,'Y') ,(10,'Y')
,(11,'Y') ,(12,'N') ,(13,'Y') ,(14,'Y');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with bms_cte as (
	select *,
		row_number() over(order by seat_no) as rn,
		seat_no - row_number() over(order by seat_no) as rn_diff
	from bms
	where is_empty = 'Y'
)
select seat_no
from bms_cte
where rn_diff in (
	select rn_diff
	from bms_cte
	group by rn_diff
	having count(1) >= 3
)
order by seat_no asc;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. return the fraction of users, rounded to two decimal places, 
-- who accessed Amazon music and upgraded to prime membership within the first 30 days of signing up
drop table if exists users;
create table users (
	user_id integer,
	name varchar(20),
	join_date date
);
insert into users
values 
(1, 'Jon', CAST('2-14-20' AS date)), 
(2, 'Jane', CAST('2-14-20' AS date)), 
(3, 'Jill', CAST('2-15-20' AS date)), 
(4, 'Josh', CAST('2-15-20' AS date)), 
(5, 'Jean', CAST('2-16-20' AS date)), 
(6, 'Justin', CAST('2-17-20' AS date)),
(7, 'Jeremy', CAST('2-18-20' AS date));

drop table if exists events;
create table events (
	user_id integer,
	type varchar(10),
	access_date date
);
insert into events values
(1, 'Pay', CAST('3-1-20' AS date)), 
(2, 'Music', CAST('3-2-20' AS date)), 
(2, 'P', CAST('3-12-20' AS date)),
(3, 'Music', CAST('3-15-20' AS date)), 
(4, 'Music', CAST('3-15-20' AS date)), 
(1, 'P', CAST('3-16-20' AS date)), 
(3, 'P', CAST('3-22-20' AS date));

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with music_user as (
	select distinct u.user_id
	from users as u
	join events as e
		on u.user_id = e.user_id
	where e.type = 'Music'
	and e.access_date between u.join_date
		and DATEADD(DAY, 30, u.join_date)
),
	prime_user as (
		select distinct u.user_id
		from users as u
		join events as e
			on u.user_id = e.user_id
		where e.type = 'P'
		and e.access_date between u.join_date
			and DATEADD(DAY, 30, u.join_date)
), 
	music_prime_user_count as (
		select count(*) as mp_count
		from music_user as mu
		join prime_user as pu
			on mu.user_id = pu.user_id
	)
select 
	CAST(ROUND(CAST(mp_count as decimal(10, 2)) * 100 /
	(select count(*) from music_user), 2)
	as decimal(10, 2)) as fraction_music_prime_and_music,
	CAST(ROUND(CAST(mp_count as decimal(10, 2)) * 100 /
	(select count(*) from users), 2)
	as decimal(10, 2)) as fraction_total_user_and_music_prime
from music_prime_user_count;

-- ==================================================================================================================================
