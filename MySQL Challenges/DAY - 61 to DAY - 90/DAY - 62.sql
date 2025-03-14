-- QUESTION : 1
-- 1. Write an SQL query to find the id and the name of active users.
-- Active users are those who logged in to their accounts for 5 or more consecutive days.

CREATE TABLE Accounts (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);
CREATE TABLE Logins (
    id INT,
    login_date DATE
);

INSERT INTO Accounts (id, name) 
	VALUES
(1, 'Winston'),
(7, 'Jonathan');
INSERT INTO Logins (id, login_date) 
	VALUES
(7, '2020-05-30'),
(1, '2020-05-30'),
(7, '2020-05-31'),
(7, '2020-06-01'),
(7, '2020-06-02'),
(7, '2020-06-02'),
(7, '2020-06-03'),
(1, '2020-06-07'),
(7, '2020-06-10');


-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1 - Using ROW_NUMBER() to Detect Gaps
-- we apply row_numbers to get partition by id, login_date
with logins_rn as (
	select id, login_date,
		row_number() over(partition by id order by login_date) as rn
	from (select distinct id, login_date from logins) as distinct_logins
),	-- find grp of dates using dateadd
	consecutiveGroups as (
		select id, login_date,
			dateadd(day, -rn, login_date) as grp
		from logins_rn
	),	-- find id in logins where they logins for consecutively 5 days or more than 5
		consecutiveLogins as (
			select id
			from ConsecutiveGroups
			group by id, grp
			having count(*) >= 5
		)
		select a.id, a.name
		from consecutiveLogins cl
		join accounts a
			on cl.id = a.id;

-- SOLUTION 2 - Using GROUP BY and COUNT(*) with a Self Join
with consecutive_user_login as (
	select l1.id, l1.login_date
	from (select distinct id, login_date from logins) as l1
	join (select distinct id, login_date from logins) as l2
		on l1.id = l2.id
		and DATEDIFF(DAY, l1.login_date, l2.login_date) between 0 and 4
	group by l1.id, l1.login_date
	having count(*) = 5
)
select id, name
from Accounts
where id in 
	(select id from consecutive_user_login);

-- SOLUTION 3 - Using LAG() to Find Consecutive Days
WITH RankedLogins AS (
    SELECT id, login_date,
           LAG(login_date, 1) OVER (PARTITION BY id ORDER BY login_date) AS prev_day1,
           LAG(login_date, 2) OVER (PARTITION BY id ORDER BY login_date) AS prev_day2,
           LAG(login_date, 3) OVER (PARTITION BY id ORDER BY login_date) AS prev_day3,
           LAG(login_date, 4) OVER (PARTITION BY id ORDER BY login_date) AS prev_day4
    FROM (SELECT DISTINCT id, login_date FROM Logins) AS DistinctLogins
)
SELECT DISTINCT A.id, A.name 
FROM Accounts A
JOIN RankedLogins RL ON A.id = RL.id
WHERE DATEDIFF(DAY, RL.prev_day1, RL.login_date) = 1
  AND DATEDIFF(DAY, RL.prev_day2, RL.prev_day1) = 1
  AND DATEDIFF(DAY, RL.prev_day3, RL.prev_day2) = 1
  AND DATEDIFF(DAY, RL.prev_day4, RL.prev_day3) = 1
ORDER BY A.id;


-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Write an SQL query to find the names of all the activities with neither maximum, nor minimum number of participants.
-- Return the result table in any order. Each activity in table Activities is performed by any person in the table Friends.

CREATE TABLE Friends (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    activity VARCHAR(255)
);
CREATE TABLE Activities (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

INSERT INTO Friends (id, name, activity) 
	VALUES
(1, 'Jonathan D.', 'Eating'),
(2, 'Jade W.', 'Singing'),
(3, 'Victor J.', 'Singing'),
(4, 'Elvis Q.', 'Eating'),
(5, 'Daniel A.', 'Eating'),
(6, 'Bob B.', 'Horse Riding');
INSERT INTO Activities (id, name) 
	VALUES
(1, 'Eating'),
(2, 'Singing'),
(3, 'Horse Riding');


-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- Solution 1: Using COUNT(), MIN(), and MAX()
with participant_count_cte as (
	select activity,
		count(*) as participant_count
	from Friends
	group by activity
)
select activity
from participant_count_cte
where participant_count not in (
	select min(participant_count)
	from participant_count_cte
	UNION
	select max(participant_count)
	from participant_count_cte
);

-- Solution 2: Using RANK() for Performance Optimization
with participant_count_cte as (
	select activity,
		count(*) as participant_count,
		rank() over(order by count(*)) as min_rn,
		rank() over(order by count(*) desc) as max_rn
	from Friends
	group by activity
)
select activity
from participant_count_cte
where min_rn > 1 and max_rn > 1;

-- ==================================================================================================================================

-- QUESTION : 3
-- 3. Write an SQL query to find employee_id of all employees that directly or indirectly report their work to the head of the company.
-- The indirect relation between managers will not exceed 3 managers as the company is small.
-- The head of the company is the employee with employee_id = 1

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(255),
    manager_id INT
);
INSERT INTO Employees (employee_id, employee_name, manager_id) VALUES
(1, 'Boss', 1),
(3, 'Alice', 3),
(2, 'Bob', 1),
(4, 'Daniel', 2),
(7, 'Luis', 4),
(8, 'Jhon', 3),
(9, 'Angela', 8),
(77, 'Robert', 1);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- Solution 1: Using Recursive Common Table Expressions (CTE)
WITH EmployeeHierarchy (employee_id, manager_id) AS (
    -- Base case: Employees who directly report to the CEO (employee_id = 1)
    SELECT employee_id, manager_id
    FROM Employees
    WHERE manager_id = 1  

    UNION ALL

    -- Recursive case: Employees who report to someone in the hierarchy
    SELECT e.employee_id, e.manager_id
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.manager_id = eh.employee_id
)
SELECT DISTINCT employee_id FROM EmployeeHierarchy;

--------------------------------------------------- OR ---------------------------------------------------

WITH RECURSIVE EmployeeHierarchy AS (
    SELECT employee_id, manager_id
    FROM Employees
    WHERE manager_id = 1  -- Direct reports to the CEO

    UNION ALL

    SELECT e.employee_id, e.manager_id
    FROM Employees e
    JOIN EmployeeHierarchy eh ON e.manager_id = eh.employee_id
)
SELECT DISTINCT employee_id FROM EmployeeHierarchy;

-- Solution 2: Using Recursive Common Table Expressions (CTE)
WITH dirc AS (
    -- Get employees who directly report to the CEO (ID = 1)
    SELECT employee_id
    FROM Employees
    WHERE manager_id = 1 AND employee_id <> 1
),
indirect1 AS (
    -- Get employees who report to direct reports of the CEO
    SELECT employee_id
    FROM Employees
    WHERE manager_id IN (SELECT employee_id FROM dirc)
),
indirect2 AS (
    -- Get employees who report to the second-level managers
    SELECT employee_id
    FROM Employees
    WHERE manager_id IN (SELECT employee_id FROM indirect1)
)
-- Combine all levels and remove duplicates
SELECT DISTINCT employee_id FROM (
    SELECT employee_id FROM dirc
    UNION ALL
    SELECT employee_id FROM indirect1
    UNION ALL
    SELECT employee_id FROM indirect2
) AS combined;

-- Solution 2: Using an Iterative Approach (Join-based Solution)
SELECT DISTINCT e1.employee_id
FROM Employees e1
LEFT JOIN Employees e2 ON e1.manager_id = e2.employee_id
LEFT JOIN Employees e3 ON e2.manager_id = e3.employee_id
WHERE (e1.manager_id = 1 OR e2.manager_id = 1 OR e3.manager_id = 1)
	and e1.employee_id != 1;

-- ==================================================================================================================================
