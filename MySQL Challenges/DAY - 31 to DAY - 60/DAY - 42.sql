
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
-- 2. You are given a table called EmployeeIncentives with columns: Name, Age, Incentive Band, and Amount.
-- 🧩 Question:Find the Name, Age, Incentive Band, and Amount from the EmployeeIncentives table, 
-- calculate the minimum incentive for each Name and Age, 
-- and the maximum incentive for Incentive Band 1 for each Name and Age, sorted by Name, Age, and Incentive Band.

DROP TABLE IF EXISTS EmployeeIncentives;
CREATE TABLE EmployeeIncentives (
	Name VARCHAR(50), 
	Age INT, 
	IncentiveBand INT, 
	Amount INT);

INSERT INTO EmployeeIncentives (Name, Age, IncentiveBand, Amount) 
	VALUES 
('John Doe', 30, 1, 150), ('John Doe', 30, 2, 250), 
('Jane Smith', 25, 1, 300), ('Jane Smith', 25, 3, 450), 
('Alice Brown', 35, 1, 180), ('Alice Brown', 35, 2, 350);

-- 2. -- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1 - with case and basic SQL statements
select Name, Age, IncentiveBand, Amount,
	min(Amount) over(partition by Name, Age) as MinIncentive,
	max(
		case
			when IncentiveBand = 1 then Amount 
			else NULL
		end
	) over (partition by Name, Age) as Band1Incentive
from EmployeeIncentives;

-- SOLUTION 2 - Use a CTE or subquery to calculate the required fields
WITH MinIncentives AS (
    SELECT Name, Age,
        MIN(Amount) AS MinIncentive
    FROM EmployeeIncentives
    GROUP BY Name, Age
),
MaxIncentivesBand1 AS (
    SELECT Name, Age,
        MAX(Amount) AS MaxIncentiveBand1
    FROM EmployeeIncentives
    WHERE IncentiveBand = 1
    GROUP BY Name, Age
)
SELECT EI.Name,EI.Age, EI.IncentiveBand,
    EI.Amount, MI.MinIncentive,
    COALESCE(MB1.MaxIncentiveBand1, 0) AS MaxIncentiveBand1
FROM EmployeeIncentives EI
LEFT JOIN MinIncentives MI
    ON EI.Name = MI.Name AND EI.Age = MI.Age
LEFT JOIN MaxIncentivesBand1 MB1
    ON EI.Name = MB1.Name AND EI.Age = MB1.Age
ORDER BY EI.Name, EI.Age, EI.IncentiveBand;

-- ==================================================================================================================================
