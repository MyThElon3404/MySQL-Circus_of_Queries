-- Case Study - Employee Management and Payroll
-- Let's Practice SQL

-- All tables and respective records for the tables

DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Gender VARCHAR(10),
    HireDate DATE,
    DepartmentID INT
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Gender, HireDate, DepartmentID) 
	VALUES
(1, 'John', 'Doe', 'Male', '2020-01-15', 1),
(2, 'Jane', 'Smith', 'Female', '2019-07-23', 2),
(3, 'Robert', 'Johnson', 'Male', '2018-03-12', 3),
(4, 'Emily', 'Davis', 'Female', '2021-09-05', 1),
(5, 'Michael', 'Wilson', 'Male', '2020-11-11', 2),
(6, 'Sophia', 'Martinez', 'Female', '2022-04-17', 3),
(7, 'David', 'Lee', 'Male', '2020-02-20', 1),
(8, 'Laura', 'Walker', 'Female', '2019-11-30', 2),
(9, 'James', 'Brown', 'Male', '2018-07-15', 3);

DROP TABLE IF EXISTS Departments;
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

INSERT INTO Departments (DepartmentID, DepartmentName) 
	VALUES
(1, 'Human Resources'),
(2, 'Finance'),
(3, 'IT'),
(4, 'Marketing'),
(5, 'Sales'),
(6, 'Operations'),
(7, 'Legal'),
(8, 'Customer Support'),
(9, 'R&D');

DROP TABLE IF EXISTS Salaries;
CREATE TABLE Salaries (
    SalaryID INT PRIMARY KEY,
    EmployeeID INT,
    BaseSalary DECIMAL(10, 2),
    Bonus DECIMAL(10, 2),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

INSERT INTO Salaries (SalaryID, EmployeeID, BaseSalary, Bonus) 
	VALUES
(1, 1, 55000.00, 5000.00),
(2, 2, 60000.00, 7000.00),
(3, 3, 75000.00, 8000.00),
(4, 4, 52000.00, 4000.00),
(5, 5, 58000.00, 6000.00),
(6, 6, 72000.00, 7500.00),
(7, 7, 50000.00, 3000.00),
(8, 8, 62000.00, 6500.00),
(9, 9, 68000.00, 7000.00);

select * from Employees;
select * from Departments;
select * from Salaries;
