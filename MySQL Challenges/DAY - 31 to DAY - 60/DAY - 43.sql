
-- QUESTION : 1
-- 1. (business_id, event_type) is the primary key of this table.
-- Each row in the table logs the info that an event of some type occured at some business for a number of times.
-- Write an SQL query to find all active businesses.
-- An active business is a business that has more than one event type with occurences greater than the average occurences of that event type among all businesses.

CREATE TABLE Events (
    business_id INT,
    event_type VARCHAR(50),
    occurences INT
);

INSERT INTO Events (business_id, event_type, occurences) VALUES
(1, 'reviews', 7), (3, 'reviews', 3), (1, 'ads', 11),
(2, 'ads', 7), (3, 'ads', 6), (1, 'page views', 3),
(2, 'page views', 12);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with event_type_avg as (
	select event_type as event,
		AVG(occurences) as occured_avg
	from Events
	group by event_type
),
	avg_occurence_greater as (
		select e.business_id, e.event_type
		from event_type_avg as eta
		join events as e
			on eta.event = e.event_type
		where e.occurences > eta.occured_avg
	)
select business_id
from avg_occurence_greater
group by business_id
having count(event_type) > 1;

-- ---------------------------------- OR ----------------------------------------

select e.business_id
from events as e
where occurences > (
		select avg(occurences)
		from events
		where event_type = e.event_type
	)
group by e.business_id
having count(*) > 1;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. -- Write an SQL query to find the id and the name of active users.
-- Active users are those who logged in to their accounts for 5 or more consecutive days.
-- Return the result table ordered by the id.

CREATE TABLE Accounts (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

INSERT INTO Accounts (id, name) VALUES
(1, 'Winston'), (7, 'Jonathan');

CREATE TABLE Logins (
    id INT,
    login_date DATE
);

INSERT INTO Logins (id, login_date) VALUES
(7, '2020-05-30'), (1, '2020-05-30'), (7, '2020-05-31'), (7, '2020-06-01'),
(7, '2020-06-02'), (7, '2020-06-02'), (7, '2020-06-03'), (1, '2020-06-07'),
(7, '2020-06-10');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with drn_cte as (
	select id, login_date,
		dense_rank() over(partition by id order by login_date) as drn
	from Logins
), 
	date_grp as (
		select id, login_date,
			DATEADD(DAY, -drn, login_date) as date_grp
		from drn_cte
	),
		occured_date as (
			select id, date_grp,
				count(date_grp) as date_occurence
			from date_grp
			group by id, date_grp
		)
select a.id, a.name
from Accounts a
join occured_date od
	on a.id = od.id
where date_occurence >= 5;

-- ==================================================================================================================================
