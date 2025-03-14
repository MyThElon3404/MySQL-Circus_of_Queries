-- QUESTION : 1
-- 1. Write an SQL query to find the countries where this company can invest.

CREATE TABLE Person (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    phone_number VARCHAR(15)
);
CREATE TABLE Country (
    name VARCHAR(100),
    country_code VARCHAR(3) PRIMARY KEY
);
CREATE TABLE Calls (
    caller_id INT,
    callee_id INT,
    duration INT,
    FOREIGN KEY (caller_id) REFERENCES Person(id),
    FOREIGN KEY (callee_id) REFERENCES Person(id)
);

INSERT INTO Person (id, name, phone_number) 
  VALUES
(3, 'Jonathan', '051-1234567'),
(12, 'Elvis', '051-7654321'),
(1, 'Moncef', '212-1234567'),
(2, 'Maroua', '212-6523651'),
(7, 'Meir', '972-1234567'),
(9, 'Rachel', '972-0011100');

INSERT INTO Country (name, country_code) 
  VALUES
('Peru', '051'),
('Israel', '972'),
('Morocco', '212'),
('Germany', '049'),
('Ethiopia', '251');

INSERT INTO Calls (caller_id, callee_id, duration) 
  VALUES
(1, 9, 33),
(2, 9, 4),
(1, 2, 59),
(3, 12, 102),
(3, 12, 330),
(12, 3, 5),
(7, 9, 13),
(7, 1, 3),
(9, 7, 1),
(1, 7, 7);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- Solution 1 - Using JOIN and GROUP BY
WITH GlobalAvg AS (
    SELECT AVG(duration) AS global_avg
    FROM Calls
),
CountryAvg AS (
    SELECT c.country_code, co.name, AVG(cl.duration) AS avg_duration
    FROM Calls cl
    JOIN Person p ON cl.caller_id = p.id
    JOIN Country co ON LEFT(p.phone_number, 3) = co.country_code
    GROUP BY c.country_code, co.name
)
SELECT name 
FROM CountryAvg, GlobalAvg 
WHERE CountryAvg.avg_duration > GlobalAvg.global_avg;

-- Solution 2 - Using HAVING Clause
SELECT co.name
FROM Calls cl
JOIN Person p ON cl.caller_id = p.id
JOIN Country co ON LEFT(p.phone_number, 3) = co.country_code
GROUP BY co.name
HAVING AVG(cl.duration) > (SELECT AVG(duration) FROM Calls);


-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Write an SQL query to report the customer_id and customer_name of customers 
-- who bought products "A", "B" but did not buy the product "C" since we want to recommend them buy this product.
-- Return the result table ordered by customer_id.

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Customers (customer_id, customer_name) 
  VALUES
(1, 'Daniel'),
(2, 'Diana'),
(3, 'Elizabeth'),
(4, 'Jhon');

INSERT INTO Orders (order_id, customer_id, product_name) 
  VALUES
(10, 1, 'A'),
(20, 1, 'B'),
(30, 1, 'D'),
(40, 1, 'C'),
(50, 2, 'A'),
(60, 3, 'A'),
(70, 3, 'B'),
(80, 3, 'D'),
(90, 4, 'C');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- Solution 1 - Using GROUP BY and HAVING (Optimized Aggregation)
SELECT c.customer_id, c.customer_name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING 
    SUM(CASE WHEN o.product_name = 'A' THEN 1 ELSE 0 END) > 0 
    AND SUM(CASE WHEN o.product_name = 'B' THEN 1 ELSE 0 END) > 0
    AND SUM(CASE WHEN o.product_name = 'C' THEN 1 ELSE 0 END) = 0
ORDER BY c.customer_id;

-- Solution 2 - Using EXISTS and NOT EXISTS (Optimized Set-Based Approach)
SELECT c.customer_id, c.customer_name
FROM Customers c
WHERE EXISTS (
    SELECT 1 FROM Orders o 
    WHERE o.customer_id = c.customer_id AND o.product_name = 'A'
)
AND EXISTS (
    SELECT 1 FROM Orders o 
    WHERE o.customer_id = c.customer_id AND o.product_name = 'B'
)
AND NOT EXISTS (
    SELECT 1 FROM Orders o 
    WHERE o.customer_id = c.customer_id AND o.product_name = 'C'
)
ORDER BY c.customer_id;

-- Solution 3 - Using INTERSECT and EXCEPT (Optimized Set Operations)
SELECT customer_id, customer_name 
FROM Customers 
WHERE customer_id IN (
    SELECT customer_id FROM Orders WHERE product_name = 'A'
    INTERSECT
    SELECT customer_id FROM Orders WHERE product_name = 'B'
)
AND customer_id NOT IN (
    SELECT customer_id FROM Orders WHERE product_name = 'C'
)
ORDER BY customer_id;

-- ==================================================================================================================================

-- QUESTION : 3
-- 3. Write a SQL query to find employees who have the highest salary in each of the departments. 
-- For the above tables, your SQL query should return the following rows (order of rows does not matter).

CREATE TABLE Department (
    Id INT PRIMARY KEY,
    Name VARCHAR(50)
);
CREATE TABLE Employee (
    Id INT PRIMARY KEY,
    Name VARCHAR(50),
    Salary INT,
    DepartmentId INT,
    FOREIGN KEY (DepartmentId) REFERENCES Department(Id)
);

INSERT INTO Department (Id, Name) 
  VALUES 
(1, 'IT'), 
(2, 'Sales');

INSERT INTO Employee (Id, Name, Salary, DepartmentId) 
  VALUES 
(1, 'Joe', 70000, 1),
(2, 'Jim', 90000, 1),
(3, 'Henry', 80000, 2),
(4, 'Sam', 60000, 2),
(5, 'Max', 90000, 1);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- Solution 1 - Using JOIN with MAX() in a Subquery (Optimized)
SELECT d.Name AS Department, e.Name AS Employee, e.Salary
FROM Employee e
JOIN Department d ON e.DepartmentId = d.Id
WHERE e.Salary = (SELECT MAX(Salary) 
                  FROM Employee 
                  WHERE DepartmentId = e.DepartmentId);

-- Solution 2 - Using DENSE_RANK() (Window Function)
SELECT Department, Employee, Salary
FROM (
    SELECT d.Name AS Department, e.Name AS Employee, e.Salary,
           DENSE_RANK() OVER (PARTITION BY e.DepartmentId ORDER BY e.Salary DESC) AS rnk
    FROM Employee e
    JOIN Department d ON e.DepartmentId = d.Id
) ranked
WHERE rnk = 1;

-- Solution 3 - Using INNER JOIN with MAX() (Derived Table)
SELECT d.Name AS Department, e.Name AS Employee, e.Salary
FROM Employee e
JOIN Department d ON e.DepartmentId = d.Id
JOIN (SELECT DepartmentId, MAX(Salary) AS MaxSalary
      FROM Employee
      GROUP BY DepartmentId) max_salaries 
ON e.DepartmentId = max_salaries.DepartmentId AND e.Salary = max_salaries.MaxSalary;

-- ==================================================================================================================================
