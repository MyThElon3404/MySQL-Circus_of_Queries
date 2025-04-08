-- QUESTION : 1
-- 1. Workers Who Are Also Managers
-- Find all employees who have or had a job title that includes manager.
-- Output the first name along with the corresponding title.

CREATE TABLE worker (
    worker_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    salary INT,
    joining_date DATE,
    department VARCHAR(50)
);
INSERT INTO worker 
	VALUES
(1, 'Monika', 'Arora', 100000, '2014-02-20', 'HR'),
(2, 'Niharika', 'Verma', 80000, '2014-06-11', 'Admin'),
(3, 'Vishal', 'Singhal', 300000, '2014-02-20', 'HR'),
(4, 'Amitah', 'Singh', 500000, '2014-02-20', 'Admin'),
(5, 'Vivek', 'Bhati', 500000, '2014-06-11', 'Admin'),
(6, 'Vipul', 'Diwan', 200000, '2014-06-11', 'Account'),
(7, 'Satish', 'Kumar', 75000, '2014-01-20', 'Account'),
(8, 'Geetika', 'Chauhan', 90000, '2014-04-11', 'Admin'),
(9, 'Agepi', 'Argon', 90000, '2015-04-10', 'Admin'),
(10, 'Moe', 'Acharya', 65000, '2015-04-11', 'HR'),
(11, 'Nayah', 'Laghari', 75000, '2014-03-20', 'Account'),
(12, 'Jai', 'Patel', 85000, '2014-03-21', 'HR');

CREATE TABLE title (
    worker_ref_id INT,
    worker_title VARCHAR(50),
    affected_from DATE
);
INSERT INTO title 
	VALUES
(1, 'Manager', '2016-02-20'),
(2, 'Executive', '2016-06-11'),
(8, 'Executive', '2016-06-11'),
(5, 'Manager', '2016-06-11'),
(4, 'Asst. Manager', '2016-06-11'),
(7, 'Executive', '2016-06-11'),
(6, 'Lead', '2016-06-11'),
(3, 'Lead', '2016-06-11');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1 - Using INNER JOIN + WHERE LIKE
select 
	w.worker_id,
	CONCAT(w.first_name,' ', w.last_name) as worker_name,
	t.worker_title
from worker w
inner join title t
	on w.worker_id = t.worker_ref_id
where t.worker_title like '%Manager%';

-- SOLUTION 2 - Using IN with Subquery
select 
	w.worker_id,
	CONCAT(w.first_name,' ', w.last_name) as worker_name,
	t.worker_title
from worker w, title t
where w.worker_id = t.worker_ref_id
and w.worker_id in (
	select worker_ref_id
	from title
	where worker_title like '%Manager%'
);

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================

-- QUESTION : 3
-- 3. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================
