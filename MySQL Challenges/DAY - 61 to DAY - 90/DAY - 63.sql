-- QUESTION : 1
-- 1. Write an SQL query to find the salaries of the employees after applying taxes.
-- The tax rate is calculated for each company based on the following criteria:
-- 0% If the max salary of any employee in the company is less than 1000$.
-- 24% If the max salary of any employee in the company is in the range [1000, 10000] inclusive.
-- 49% If the max salary of any employee in the company is greater than 10000$.
-- Return the result table in any order. Round the salary to the nearest integer.

CREATE TABLE Salaries (
    company_id INT,
    employee_id INT,
    employee_name VARCHAR(255),
    salary INT,
    PRIMARY KEY (company_id, employee_id)
);
INSERT INTO Salaries (company_id, employee_id, employee_name, salary) 
  VALUES
(1, 1, 'Tony', 2000),
(1, 2, 'Pronub', 21300),
(1, 3, 'Tyrrox', 10800),
(2, 1, 'Pam', 300),
(2, 7, 'Bassem', 450),
(2, 9, 'Hermione', 700),
(3, 7, 'Bocaben', 100),
(3, 2, 'Ognjen', 2200),
(3, 13, 'Nyancat', 3300),
(3, 15, 'Morninngcat', 1866);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- Solution 1 - Using CASE with JOIN
SELECT s.company_id, 
       s.employee_id, 
       s.employee_name, 
       ROUND(s.salary * (1 - 
           CASE 
               WHEN max_salary < 1000 THEN 0
               WHEN max_salary BETWEEN 1000 AND 10000 THEN 0.24
               ELSE 0.49
           END)) AS after_tax_salary
FROM Salaries s
JOIN (
    SELECT company_id, MAX(salary) AS max_salary
    FROM Salaries
    GROUP BY company_id
) max_s ON s.company_id = max_s.company_id;

-- Solution 2 - Using WINDOW FUNCTION
WITH max_salaries AS (
    SELECT company_id, 
           MAX(salary) OVER (PARTITION BY company_id) AS max_salary,
           employee_id, employee_name, salary
    FROM Salaries
)
SELECT company_id, 
       employee_id, 
       employee_name, 
       ROUND(salary * (1 - 
           CASE 
               WHEN max_salary < 1000 THEN 0
               WHEN max_salary BETWEEN 1000 AND 10000 THEN 0.24
               ELSE 0.49
           END)) AS after_tax_salary
FROM max_salaries;

-- Solution 3 - Using CASE with SELF-JOIN
SELECT s.company_id, 
       s.employee_id, 
       s.employee_name, 
       ROUND(s.salary * (1 - 
           CASE 
               WHEN (SELECT MAX(s2.salary) FROM Salaries s2 WHERE s2.company_id = s.company_id) < 1000 THEN 0
               WHEN (SELECT MAX(s2.salary) FROM Salaries s2 WHERE s2.company_id = s.company_id) BETWEEN 1000 AND 10000 THEN 0.24
               ELSE 0.49
           END)) AS after_tax_salary
FROM Salaries s;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================

-- QUESTION : 3
-- 3. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================
