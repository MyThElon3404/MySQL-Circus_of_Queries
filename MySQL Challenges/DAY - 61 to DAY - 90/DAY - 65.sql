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
-- 3. Your team at JPMorgan Chase is soon launching a new credit card, and to gain some context, 
-- you are analyzing how many credit cards were issued each month.
-- Write a query that outputs the name of each credit card and the difference in issued amount between the 
-- month with the most cards issued, and the least cards issued. Order the results according to the biggest difference.

CREATE TABLE credit_card_issuance (
    card_name VARCHAR(50) NOT NULL,
    issued_amount INT NOT NULL,
    issue_month TINYINT NOT NULL CHECK (issue_month BETWEEN 1 AND 12),
    issue_year YEAR NOT NULL,
    PRIMARY KEY (card_name, issue_month, issue_year)
);

INSERT INTO credit_card_issuance (card_name, issued_amount, issue_month, issue_year) 
	VALUES
('Chase Freedom Flex', 55000, 1, 2021),
('Chase Freedom Flex', 60000, 2, 2021),
('Chase Freedom Flex', 65000, 3, 2021),
('Chase Freedom Flex', 70000, 4, 2021),
('Chase Sapphire Reserve', 170000, 1, 2021),
('Chase Sapphire Reserve', 175000, 2, 2021),
('Chase Sapphire Reserve', 180000, 3, 2021);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- Solution 1 - Using MAX() and MIN() with GROUP BY
select card_name,
	max(issued_amount) - 
	min(issued_amount) as issue_difference
from credit_card_issuance
group by card_name
order by issue_difference desc;

-- Solution 2 - Using RANK() for Max/Min Values
with amount_cte as (
	select card_name, issued_amount,
		row_number() over(partition by card_name order by issued_amount desc) as max_amount,
		row_number() over(partition by card_name order by issued_amount asc) as min_amount
	from credit_card_issuance
)
select card_name,
	max(case when max_amount = 1 then issued_amount end) -
	min(case when min_amount = 1 then issued_amount end) as issue_difference
from amount_cte
group by card_name
order by issue_difference desc;

-- ==================================================================================================================================
