
-- QUESTION : 1
-- 1. You are given two tables: EmployeeInfo and EmployeePosition.
-- 🧩 Question: Find the count of employees holding the positions Manager, Executive, and Lead in each department, 
-- and calculate the average salary for each position in each department.

drop table if exists EmployeeInfo;
CREATE TABLE EmployeeInfo(
 EmpID INT,
 EmpFname VARCHAR(50),
 EmpLname VARCHAR(50),
 Department VARCHAR(50),
 Project VARCHAR(10),
 Address VARCHAR(50),
 DOB DATE,
 Gender CHAR(1)
);
INSERT INTO EmployeeInfo (EmpID, EmpFname, EmpLname, Department, Project, Address, DOB, Gender) 
VALUES 
(1, 'Sanjay', 'Mehra', 'HR', 'P1', 'Hyderabad(HYD)', '1976-12-01', 'M'),
(2, 'Ananya', 'Mishra', 'Admin', 'P2', 'Delhi(DEL)', '1968-05-02', 'F'),
(3, 'Rohan', 'Diwan', 'Account', 'P3', 'Mumbai(BOM)', '1980-01-01', 'M'),
(4, 'Sonia', 'Kulkarni', 'HR', 'P1', 'Hyderabad(HYD)', '1992-05-02', 'F'),
(5, 'Ankit', 'Kapoor', 'Admin', 'P2', 'Delhi(DEL)', '1994-07-03', 'M');

drop table if exists EmployeePosition;
CREATE TABLE EmployeePosition (
 EmpID INT,
 EmpPosition VARCHAR(50),
 DateOfJoining DATE,
 Salary INT
);
INSERT INTO EmployeePosition (EmpID, EmpPosition, DateOfJoining, Salary)
VALUES 
(1, 'Manager', '2024-05-01', 500000),
(2, 'Executive', '2024-05-02', 75000),
(3, 'Manager', '2024-05-01', 90000),
(2, 'Lead', '2024-05-02', 85000),
(1, 'Executive', '2024-05-01', 300000);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

WITH WindowedData AS (
    SELECT EI.Department, EP.EmpPosition,
        EP.EmpID, EP.Salary,
        COUNT(*) OVER (PARTITION BY EI.Department) AS TotalEmployeesInDept,
        AVG(EP.Salary) OVER (PARTITION BY EI.Department) AS AvgSalaryInDept
    FROM EmployeeInfo EI
    JOIN EmployeePosition EP
    ON EI.EmpID = EP.EmpID
    WHERE EP.EmpPosition IN ('Manager', 'Executive', 'Lead')
)
SELECT Department, EmpPosition,
    TotalEmployeesInDept, AvgSalaryInDept
FROM WindowedData;

-- ==================================================================================================================================

-- QUESTION : 2 

-- 2. -- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================
