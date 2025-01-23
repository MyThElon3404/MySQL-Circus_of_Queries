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
    employee_name VARCHAR(50),
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

with max_salary_cte as (
	select company_id,
		max(salary) as max_salary
	from salaries
	group by company_id
)
select s.company_id, employee_id, employee_name, salary, ms.max_salary,
	ROUND(
		case
			when max_salary < 1000 then salary
			when max_salary between 1000 and 10000 then salary * 0.76
			else salary * 0.51
		end
	, 0) as salary_after_tax
from Salaries s
join max_salary_cte ms
	on s.company_id = ms.company_id;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================
