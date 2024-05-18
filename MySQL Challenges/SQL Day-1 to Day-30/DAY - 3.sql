-- QUESTION 1:
-- Write an SQL query to calculate the difference between the highest salaries 
-- in the marketing and engineering department. Output the absolute difference in salaries.

drop table if exists Salaries;
CREATE TABLE Salaries (
	emp_name VARCHAR(50),
	department VARCHAR(50),
	salary INT,
	PRIMARY KEY (emp_name, department)
);

INSERT INTO Salaries (emp_name,department, salary)
VALUES
	('Kathy', 'Engineering', 50000),('Roy', 'Marketing', 30000),
	('Charles', 'Engineering', 45000),('Jack', 'Engineering', 85000),
	('Benjamin', 'Marketing', 34000),('Anthony', 'Marketing', 42000),
	('Edward', 'Engineering', 102000),('Terry', 'Engineering', 44000),
	('Evelyn', 'Marketing', 53000),('Arthur', 'Engineering', 32000);

SELECT * FROM Salaries;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- Approach 1: with ABS and max(salary) from deparments

select 
	ABS(max(case when department='Engineering' then salary end) - 
	max(case when department='Marketing' then salary end))
from salaries;

-- Approach 2: with CTE

WITH RankedSalaries AS (
    SELECT department, salary,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) 
		AS salary_rank
    FROM Salaries
    WHERE department IN ('Marketing', 'Engineering')
)
SELECT
    ABS(MAX(CASE WHEN department = 'Marketing' THEN salary END) - 
	MAX(CASE WHEN department = 'Engineering' THEN salary END)) AS salary_difference
FROM RankedSalaries
WHERE salary_rank = 1;

-- Approach 3: Sub-query

SELECT ABS(m1.max_salary - m2.max_salary) AS salary_difference
FROM 
    (SELECT MAX(salary) AS max_salary FROM Salaries WHERE department = 'Marketing') m1,
    (SELECT MAX(salary) AS max_salary FROM Salaries WHERE department = 'Engineering') m2;
-- ==================================================================================================================================
