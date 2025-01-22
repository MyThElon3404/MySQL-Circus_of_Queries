-- QUESTION : 1
-- 1. Write an SQL query to find the names of all the activities with neither maximum, nor minimum number of participants.
-- Return the result table in any order. Each activity in table Activities is performed by any person in the table Friends.

CREATE TABLE Friends (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    activity VARCHAR(255)
);
INSERT INTO Friends (id, name, activity)
VALUES
(1, 'Jonathan D.', 'Eating'),
(2, 'Jade W.', 'Singing'),
(3, 'Victor J.', 'Singing'),
(4, 'Elvis Q.', 'Eating'),
(5, 'Daniel A.', 'Eating'),
(6, 'Bob B.', 'Horse Riding');

CREATE TABLE Activities (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);
INSERT INTO Activities (id, name)
VALUES
(1, 'Eating'),
(2, 'Singing'),
(3, 'Horse Riding');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with activity_cnt_cte as (
	select activity,
		count(*) as activity_cnt
	from Friends
	group by activity
)
select a.name
from Activities a
join activity_cnt_cte ac
	on ac.activity = a.name
where ac.activity_cnt not in (
	select max(activity_cnt)
	from activity_cnt_cte
	union all
	select min(activity_cnt)
	from activity_cnt_cte
);

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Write an SQL query to find employee_id of all employees that directly or indirectly report their work to the head of the company.
-- The indirect relation between managers will not exceed 3 managers as the company is small.

DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(15),
    manager_id INT
);
INSERT INTO Employees
VALUES
(1, 'Boss', 1), (3, 'Alice', 3), (2, 'Bob', 1),
(4, 'Daniel', 2), (7, 'Luis', 4), (8, 'Jhon', 3),
(9, 'Angela', 8), (77, 'Robert', 1);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with recursive EmployeeHierarchy AS (
    -- Base case: the head of the company (employee_id = 1)
    select employee_id, manager_id
    from Employees
    where employee_id = 1
    union all
    -- Recursive case: find employees who report to the employees already found
    select e.employee_id, e.manager_id
    from Employees e
    join EmployeeHierarchy eh 
		on e.manager_id = eh.employee_id
)
select  employee_id
from EmployeeHierarchy
where employee_id != 1;

-- ==================================================================================================================================
