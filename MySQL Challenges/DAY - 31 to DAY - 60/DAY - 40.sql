-- QUESTION : 1
-- 1. Find the number of Apple product users and the number of total users with a device and group the counts by language. 
-- Assume Apple products are only MacBook-Pro, iPhone 5s, and iPad-air. Output the language along with the total number of Apple users 
-- and users with any device. Order your results based on the number of total users in descending order.

DROP TABLE IF EXISTS playbook_users;
CREATE TABLE playbook_users (
	user_id INT PRIMARY KEY,
	created_at DATE,
	company_id INT,
	language VARCHAR(10),
	activated_at DATETIME,
	state VARCHAR(10)
);
INSERT INTO playbook_users (user_id, created_at, company_id, language, activated_at, state) 
	VALUES
(1, '2024-01-01 08:00:00', 101, 'English', '2024-01-05 10:00:00', 'Active'),
(2, '2024-01-02 09:00:00', 102, 'Spanish', '2024-01-06 11:00:00', 'Inactive'),
(3, '2024-01-03 10:00:00', 103, 'French', '2024-01-07 12:00:00', 'Active'),
(4, '2024-01-04 11:00:00', 104, 'English', '2024-01-08 13:00:00', 'Active'),
(5, '2024-01-05 12:00:00', 105, 'Spanish', '2024-01-09 14:00:00', 'Inactive');

DROP TABLE IF EXISTS playbook_events;
CREATE TABLE playbook_events ( 
	user_id INT, 
	occurred_at DATE, 
	event_type VARCHAR(50), 
	event_name VARCHAR(50), 
	location VARCHAR(10), 
	device VARCHAR(30)
);
INSERT INTO playbook_events (user_id, occurred_at, event_type, event_name, location, device) 
	VALUES
(1, '2024-01-05 14:00:00', 'Click', 'Login', 'USA', 'MacBook-Pro'),
(2, '2024-01-06 15:00:00', 'View', 'Dashboard', 'Spain', 'iPhone 5s'),
(3, '2024-01-07 16:00:00', 'Click', 'Logout', 'France', 'iPad-air'),
(4, '2024-01-08 17:00:00', 'Purchase', 'Subscription', 'USA', 'Windows-Laptop'), 
(5, '2024-01-09 18:00:00', 'Click', 'Login', 'Spain', 'Android-Phone');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- Solution 1 : Using CTE

with apple_users as (
	select pu.language,
		count(distinct pu.user_id) as apple_user_count
	from playbook_users as pu
	join playbook_events as pe
		on pu.user_id = pe.user_id
	where pe.device in ('MacBook-Pro', 'iPhone 5s', 'iPad-air')
	group by pu.language
), 
	total_users as (
		select pu.language,
			count(pu.user_id) as total_user_count
		from playbook_users as pu
		join playbook_events as pe
			on pu.user_id = pe.user_id
		where pe.device is not null
		group by pu.language
	)
select tu.language,
	apple_user_count,
	total_user_count
from apple_users as au
right join total_users as tu
	on au.language = tu.language
order by total_user_count desc;

-- Solution 1 : Using case statement
select pu.language,
	sum(case when pe.device in ('MacBook-Pro', 'iPhone 5s', 'iPad-air') then 1 else 0 end) as apple_users,
	count(distinct pu.user_id) as total_users
from playbook_users as pu
join playbook_events as pe
	on pu.user_id = pe.user_id
group by pu.language
order by total_users desc;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Write a query that returns the company (customer id column) with highest number of users that use desktop only.

CREATE TABLE fact_events (
	id INT PRIMARY KEY, 
	time_id DATE, 
	user_id VARCHAR(50), 
	customer_id VARCHAR(50), 
	client_id VARCHAR(50), 
	event_type VARCHAR(50), 
	event_id INT
);
INSERT INTO fact_events (id, time_id, user_id, customer_id, client_id, event_type, event_id) 
	VALUES
(1, '2024-12-01 10:00:00', 'U1', 'C1', 'desktop', 'click', 101), 
(2, '2024-12-01 11:00:00', 'U2', 'C1', 'mobile', 'view', 102), 
(3, '2024-12-01 12:00:00', 'U3', 'C2', 'desktop', 'click', 103), 
(4, '2024-12-01 13:00:00', 'U1', 'C1', 'desktop', 'click', 104), 
(5, '2024-12-01 14:00:00', 'U2', 'C1', 'tablet', 'view', 105), 
(6, '2024-12-01 15:00:00', 'U4', 'C3', 'desktop', 'click', 106), 
(7, '2024-12-01 16:00:00', 'U3', 'C2', 'desktop', 'click', 107), 
(8, '2024-12-01 17:00:00', 'U5', 'C4', 'desktop', 'click', 108), 
(9, '2024-12-01 18:00:00', 'U6', 'C4', 'mobile', 'view', 109), 
(10, '2024-12-01 19:00:00', 'U7', 'C5', 'desktop', 'click', 110);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

WITH desktop_only_users AS (
    SELECT user_id,
        customer_id
    FROM fact_events
    GROUP BY user_id, customer_id
    HAVING COUNT(DISTINCT client_id) = 1 
        AND MAX(client_id) = 'desktop'
), 
	desktop_users_per_customer AS (
		SELECT customer_id, 
			COUNT(DISTINCT user_id) AS desktop_only_count
		FROM desktop_only_users
		GROUP BY customer_id
)
SELECT TOP 1
    customer_id, 
    desktop_only_count
FROM desktop_users_per_customer
ORDER BY desktop_only_count DESC;

-- ==================================================================================================================================
