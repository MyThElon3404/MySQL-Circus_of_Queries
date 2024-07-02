-- CTE (Common Table Expression) - A Common Table Expression (CTE) is a temporary result set that you can reference within a 
-- SELECT, INSERT, UPDATE, or DELETE statement. A CTE is defined using the WITH keyword, 
-- followed by the CTE name and the query that defines the CTE.

-- Benefits of Using CTEs
-- Improved Readability: CTEs can make complex queries easier to read and maintain by breaking them down into simpler parts.
-- Modularity: CTEs allow you to reference the same result set multiple times within a query.
-- Recursion: CTEs support recursion, which is useful for hierarchical or tree-structured data.

-- Syntax of a CTE ------------------------------------------------------------------
WITH cte_name AS (
    -- CTE query
    SELECT column1, column2, ...
    FROM table
    WHERE condition
)
-- Main query
SELECT column1, column2, ...
FROM cte_name
WHERE condition;

-- Example of a Simple CTE =----------------------------------------------------------
-- Create Sales Table
CREATE TABLE Sales (
    SalesID INT PRIMARY KEY,
    SalespersonID INT,
    Amount DECIMAL(10, 2)
);

-- Insert Sample Data
INSERT INTO Sales (SalesID, SalespersonID, Amount) VALUES
(1, 101, 500.00),
(2, 102, 700.00),
(3, 101, 300.00),
(4, 103, 900.00),
(5, 102, 400.00);

-- CTE to calculate total sales per salesperson
WITH SalesTotals AS (
    SELECT SalespersonID, SUM(Amount) AS TotalSales
    FROM Sales
    GROUP BY SalespersonID
)
SELECT SalespersonID, TotalSales
FROM SalesTotals;

-- Use Case: Calculating Average Sales per Salesperson -------------------------------------------

-- Create Sales Table
CREATE TABLE Sales (
    SalesID INT PRIMARY KEY,
    SalespersonID INT,
    Amount DECIMAL(10, 2)
);

-- Insert Sample Data
INSERT INTO Sales (SalesID, SalespersonID, Amount) VALUES
(1, 101, 500.00),
(2, 102, 700.00),
(3, 101, 300.00),
(4, 103, 900.00),
(5, 102, 400.00);

-- Define and Use the CTE
-- CTE to calculate total sales and count of sales per salesperson
WITH SalesSummary AS (
    SELECT SalespersonID, SUM(Amount) AS TotalSales, COUNT(SalesID) AS SalesCount
    FROM Sales
    GROUP BY SalespersonID
)
-- Main query to calculate average sales per salesperson
SELECT SalespersonID, TotalSales / SalesCount AS AverageSales
FROM SalesSummary;

-- result -------------------------------------------------------------------------------
SalespersonID | AverageSales
--------------|--------------
101           | 400.00
102           | 550.00
103           | 900.00

-- ================================================================================================================================

-- Recursive Common Table Expressions (CTEs) in SQL
-- Recursive CTEs are used to perform a recursive query, which is a query that refers to itself. They are useful for querying hierarchical data, such as organizational charts, bill of materials, and tree structures.

-- Basic Structure of a Recursive CTE
-- A recursive CTE has two parts:

-- Anchor Member: This part defines the base result set.
-- Recursive Member: This part references the CTE itself to produce additional result sets, recursively.

WITH cte_name AS (
    -- Anchor Member
    SELECT columns
    FROM table
    WHERE condition

    UNION ALL

    -- Recursive Member
    SELECT columns
    FROM table
    JOIN cte_name ON table.column = cte_name.column
)
SELECT * FROM cte_name;

-- UNION: ------------------------------------------------------------------------------------------------
-- Combines the results of two queries and removes duplicate rows from the result set.
-- Performs an implicit DISTINCT operation, meaning it checks for and eliminates duplicate rows.
-- Syntax: SELECT ... UNION SELECT ....

-- UNION ALL: -------------------------------------------------------------------------------------------
-- Combines the results of two queries and includes all rows, including duplicates.
-- Does not perform a DISTINCT operation, so it's generally faster than UNION.
-- Syntax: SELECT ... UNION ALL SELECT ....

-- Example: Hierarchical Employee Structure ---------------------------------------------------------------

-- Create Employee Table
CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    ManagerID INT
);

-- Insert Sample Data
INSERT INTO Employee (EmpID, EmpName, ManagerID) VALUES
(1, 'Alice', NULL),
(2, 'Bob', 1),
(3, 'Charlie', 1),
(4, 'David', 2),
(5, 'Eve', 2);

-- Recursive CTE to Find Employee Hierarchy
WITH EmployeeHierarchy AS (
    -- Anchor Member
    SELECT EmpID, EmpName, ManagerID, 0 AS Level
    FROM Employee
    WHERE ManagerID IS NULL

    UNION ALL

    -- Recursive Member
    SELECT e.EmpID, e.EmpName, e.ManagerID, eh.Level + 1
    FROM Employee e
    JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmpID
)
SELECT EmpID, EmpName, ManagerID, Level
FROM EmployeeHierarchy;

-- =============================================================================================================================

-- Practice Problems with Tables and Sample Data

-- Problem 1: Organizational Chart
-- Task: Write a recursive CTE to list all employees along with their hierarchy levels.

-- Create Employees Table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(50),
    ManagerID INT
);

-- Insert Sample Data
INSERT INTO Employees (EmployeeID, EmployeeName, ManagerID) VALUES
(1, 'CEO', NULL),
(2, 'CTO', 1),
(3, 'CFO', 1),
(4, 'Lead Engineer', 2),
(5, 'Senior Engineer', 4),
(6, 'Junior Engineer', 5);

-- Solution:
-- Execution Steps
-- Anchor Member: Selects the root employee (CEO).
-- Output:
EmployeeID | EmployeeName | ManagerID | HierarchyLevel
-----------|--------------|-----------|---------------
1          | CEO          | NULL      | 0

-- First Recursive Step:
-- Finds employees reporting directly to the CEO.
-- Output:
EmployeeID | EmployeeName | ManagerID | HierarchyLevel
-----------|--------------|-----------|---------------
2          | CTO          | 1         | 1
3          | CFO          | 1         | 1

-- Second Recursive Step:
-- Finds employees reporting to the CTO.
-- Output:
EmployeeID | EmployeeName | ManagerID | HierarchyLevel
-----------|--------------|-----------|---------------
4          | Lead Engineer| 2         | 2

-- Third Recursive Step:
-- Finds employees reporting to the Lead Engineer.
-- Output:
EmployeeID | EmployeeName  | ManagerID | HierarchyLevel
-----------|---------------|-----------|---------------
5          | Senior Engineer| 4         | 3

-- Fourth Recursive Step:
-- Finds employees reporting to the Senior Engineer.
-- Output:
EmployeeID | EmployeeName  | ManagerID | HierarchyLevel
-----------|---------------|-----------|---------------
6          | Junior Engineer| 5         | 4

-- Final Result
-- Combining all these results, the final result set ordered by HierarchyLevel and EmployeeID is:
EmployeeID | EmployeeName   | ManagerID | HierarchyLevel
-----------|----------------|-----------|---------------
1          | CEO            | NULL      | 0
2          | CTO            | 1         | 1
3          | CFO            | 1         | 1
4          | Lead Engineer  | 2         | 2
5          | Senior Engineer| 4         | 3
6          | Junior Engineer| 5         | 4
-- ============================================================================================================================

-- Problem 2: Threaded Comments
-- Task: threaded discussion forum where comments are stored in a table with a parent-child relationship to represent the threading. We'll design a query to retrieve comments in a threaded format.

CREATE TABLE Comments (
    CommentID INT PRIMARY KEY,
    CommentText TEXT,
    ParentCommentID INT
);

INSERT INTO Comments (CommentID, CommentText, ParentCommentID) VALUES
(1, 'First comment', NULL),
(2, 'Reply to first comment', 1),
(3, 'Another reply to first comment', 1),
(4, 'Reply to second comment', 2),
(5, 'Second comment', NULL),
(6, 'Reply to third comment', 3),
(7, 'Third comment', NULL);

-- Solution :
WITH RECURSIVE ThreadedComments AS (
    SELECT CommentID, CommentText, ParentCommentID, 0 AS Level
    FROM Comments
    WHERE ParentCommentID IS NULL

    UNION ALL

    SELECT c.CommentID, c.CommentText, c.ParentCommentID, tc.Level + 1
    FROM Comments c
    JOIN ThreadedComments tc ON c.ParentCommentID = tc.CommentID
)
SELECT CommentID, CommentText, ParentCommentID, Level
FROM ThreadedComments
ORDER BY CommentID; -- Order by CommentID for simplicity, can be adjusted as needed

-- Result:
| CommentID | CommentText                      | ParentCommentID | Level |
|-----------|----------------------------------|-----------------|-------|
| 1         | First comment                    | NULL            | 0     |
| 2         | Reply to first comment           | 1               | 1     |
| 4         | Reply to second comment          | 2               | 2     |
| 3         | Another reply to first comment   | 1               | 1     |
| 6         | Reply to third comment           | 3               | 2     |
| 5         | Second comment                   | NULL            | 0     |
| 7         | Third comment                    | NULL            | 0     |
--------------------------------------------------------------------------
