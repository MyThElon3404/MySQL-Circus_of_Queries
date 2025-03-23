-- QUESTION : 1
-- 1. Since some IDs have been removed from Logs. 
-- Write an SQL query to find the start and end number of continuous ranges in table Logs.

CREATE TABLE Logs (
    log_id INT PRIMARY KEY
);

INSERT INTO Logs (log_id) VALUES
(1), (2), (3), (7), (8), (10);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- Solution 1 - Using window function, cte, min, max
with cte as (
	select log_id,
		log_id - row_number() over(order by log_id) as rn
	from logs
)
select min(log_id) as start_n,
	max(log_id) as end_n
from cte
group by rn;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Write an SQL query to find the npv of all each query of queries table.

CREATE TABLE NPV (
    id INT,
    year INT,
    npv INT,
    PRIMARY KEY (id, year)
);

INSERT INTO NPV (id, year, npv) 
	VALUES
(1, 2018, 100),
(7, 2020, 30),
(13, 2019, 40),
(1, 2019, 113),
(2, 2008, 121),
(3, 2009, 12),
(11, 2020, 99),
(7, 2019, 0);

CREATE TABLE Queries (
    id INT,
    year INT,
    PRIMARY KEY (id, year)
);

INSERT INTO Queries (id, year) 
	VALUES
(1, 2019),
(2, 2008),
(3, 2009),
(7, 2018),
(7, 2019),
(7, 2020),
(13, 2019);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- Solution 1 - Using LEFT JOIN (Handling Missing Data)
select q.id, q.year,
	coalesce(n.npv, 0) as npv
from Queries q
left join NPV n
	on q.id = n.id
	and q.year = n.year;

-- Solution 2 - Using INNER JOIN
SELECT q.id, q.year, n.npv
FROM Queries q
JOIN NPV n
ON q.id = n.id AND q.year = n.year;

-- ==================================================================================================================================

-- QUESTION : 3
-- 3. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================
