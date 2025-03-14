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
-- 2. Write an SQL query to report the Capital gain/loss for each stock.
-- The capital gain/loss of a stock is total gain or loss after buying and selling the stock one or many times.

CREATE TABLE Stocks (
    stock_name VARCHAR(50),
    operation ENUM('Buy', 'Sell'),
    operation_day INT,
    price INT,
    PRIMARY KEY (stock_name, operation_day)
);
INSERT INTO Stocks (stock_name, operation, operation_day, price) VALUES
('Leetcode', 'Buy', 1, 1000),
('Corona Masks', 'Buy', 2, 10),
('Leetcode', 'Sell', 5, 9000),
('Handbags', 'Buy', 17, 30000),
('Corona Masks', 'Sell', 3, 1010),
('Corona Masks', 'Buy', 4, 1000),
('Corona Masks', 'Sell', 5, 500),
('Corona Masks', 'Buy', 6, 1000),
('Handbags', 'Sell', 29, 7000),
('Corona Masks', 'Sell', 10, 10000);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- Solution 1 - Using SUM with CASE WHEN
SELECT 
    stock_name, 
    SUM(CASE WHEN operation = 'Sell' THEN price ELSE -price END) AS capital_gain_loss
FROM Stocks
GROUP BY stock_name;

-- Solution 2 - Using JOIN to Match Buys and Sells
SELECT s1.stock_name, SUM(s1.price - s2.price) AS capital_gain_loss
FROM Stocks s1
JOIN Stocks s2 
ON s1.stock_name = s2.stock_name 
AND s1.operation = 'Sell' 
AND s2.operation = 'Buy' 
AND s2.operation_day < s1.operation_day
GROUP BY s1.stock_name;

-- Solution 3 - Using CTE with Window Functions
WITH StockBuy AS (
    SELECT stock_name, price FROM Stocks WHERE operation = 'Buy'
),
StockSell AS (
    SELECT stock_name, price FROM Stocks WHERE operation = 'Sell'
)
SELECT b.stock_name, SUM(s.price - b.price) AS capital_gain_loss
FROM StockBuy b
JOIN StockSell s ON b.stock_name = s.stock_name
GROUP BY b.stock_name;

-- ==================================================================================================================================

-- QUESTION : 3
-- 3. Write a SQL query to find all numbers that appear at least three times consecutively.

CREATE TABLE Numbers (
    Id INT PRIMARY KEY,
    Num INT
);

INSERT INTO Numbers (Id, Num) 
    VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 1),
(6, 2),
(7, 2);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- Solution 1 - Using LAG() and LEAD()
SELECT DISTINCT Num
FROM (
    SELECT Num,
           LAG(Num, 1) OVER (ORDER BY Id) AS PrevNum,
           LEAD(Num, 1) OVER (ORDER BY Id) AS NextNum
    FROM Numbers
) t
WHERE Num = PrevNum AND Num = NextNum;

-- Solution 2 - Using GROUP BY and HAVING on Consecutive Blocks
SELECT Num
FROM (
    SELECT Num, 
           Id - ROW_NUMBER() OVER (PARTITION BY Num ORDER BY Id) AS grp
    FROM Numbers
) t
GROUP BY Num, grp
HAVING COUNT(*) >= 3;

-- Solution 3 - Using SELF JOIN
SELECT DISTINCT n1.Num
FROM Numbers n1
JOIN Numbers n2 ON n1.Id = n2.Id - 1 AND n1.Num = n2.Num
JOIN Numbers n3 ON n1.Id = n3.Id - 2 AND n1.Num = n3.Num;

-- ==================================================================================================================================
