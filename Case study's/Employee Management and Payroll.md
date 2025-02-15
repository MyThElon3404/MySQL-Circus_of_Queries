## Case Study - Employee Management and Payroll

### TABLES:

### Employees

|Column Name |	Data Type	 | Remarks |
|------------|-------------|---------|
|EmployeeID	       |   Integer	 | Primary Key
|FirstName	 |  VARCHAR(50)|	NOT NULL 
|LastName	   |  VARCHAR(50)	   | NOT NULL
|Gender	       | VARCHAR(10)	 | NOT NULL
|HireDate	 |  DATE|	NOT NULL 
|DepartmentID	   |  Integer	   | NOT NULL

### Departments

|Column Name 	|Data Type	|Remarks|
|-------------|-----------|-------|
|DepartmentID	|TinyInt	|Primary Key
|DepartmentName	|Varchar(40)	|NOT NULL

### Salaries 

|Column Name 	|Data Type	|Remarks|
|-------------|-----------|-------|
|SalaryID	|Integer	|Primary Key
|EmployeeID	|Tinyint	|NOT NULL Foreign Key
|BaseSalary	|DECIMAL(10, 2)	|NOT NULL
|Bonus	|DECIMAL(10, 2)	|NOT NULL

### Schema is here: 

<details>
	<summary>Click here for solution</summary>
	
```sql
-- All tables and respective records for the tables

DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(15),
    LastName VARCHAR(15),
    Gender VARCHAR(6),
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
    DepartmentName VARCHAR(27)
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
```
</details>

-----------------------------------------------------------------------------------------------------------------

## Case Study Questions :

- Q1. Total Compensation by Department: Calculate the total compensation (Base Salary + Bonus) for each department.
```sql
select d.DepartmentName,
	SUM(s.BaseSalary + s.Bonus) as totla_compensation
from Departments as d
join Employees as e
	on d.DepartmentID = e.DepartmentID
join Salaries as s
	on e.EmployeeID = s.EmployeeID
group by d.DepartmentName;
```

- Q2. Top 3 Highest Paid Employees: Find the top 3 highest-paid employees based on their total compensation (Base Salary + Bonus).
```sql
select top 3 
	e.EmployeeID, e.FirstName, e.LastName,
	(s.BaseSalary + s.Bonus) as total_compensation
from Employees as e
join Salaries as s
	on e.EmployeeID = s.EmployeeID
order by total_compensation desc;
```

- Q3. Average Salary by Department: Retrieve the average base salary for each department.
```sql
select d.DepartmentName,
	ROUND(AVG(s.BaseSalary), 2) as salary_avg
from Departments as d
join Employees as e
	on d.DepartmentID = e.DepartmentID
join Salaries as s
	on e.EmployeeID = s.EmployeeID
group by d.DepartmentName;
```

- Q4. Gender-based Salary Insights: Calculate the total and average salary by gender.
```sql
select e.Gender,
	SUM(s.BaseSalary + s.Bonus) as total_salary,
	ROUND(AVG(s.BaseSalary + s.Bonus), 2) as avg_salary
from Employees as e
join Salaries as s
	on e.EmployeeID = s.EmployeeID
group by e.Gender;
```

- Q5. Employee Salary Percentile: Determine the salary percentile of each employee based on their total compensation.
```sql
select e.FirstName, e.LastName, 
	s.BaseSalary + s.Bonus as TotalCompensation,
	PERCENT_RANK() over (order by s.BaseSalary + s.Bonus desc) as SalaryPercentile
from Employees e
join Salaries s 
	on e.EmployeeID = s.EmployeeID
order by SalaryPercentile desc;
```

- Q6. Employees Hired in the Last 2 Years: List all employees who were hired in the last two years.
```sql
select FirstName, LastName, HireDate
from Employees
where HireDate >= DATEADD(YEAR, -2, GETDATE());
```

- Q7. Average Bonus by Department: Retrieve the average bonus for each department.
```sql
select d.DepartmentName,
	AVG(s.Bonus) AS AvgBonus
from Employees as e
join Salaries as s
	on e.EmployeeID = s.EmployeeID
join Departments as d
	on e.DepartmentID = d.DepartmentID
group by d.DepartmentName;
```

- Q8. Salary Comparison to Department Average: List all employees who earn more than the average salary in their respective departments.
```sql
select e.FirstName, e.LastName, s.BaseSalary, d.DepartmentName
from Employees as e
join Salaries as s
	on e.EmployeeID = s.EmployeeID
join Departments as d
	on e.DepartmentID = d.DepartmentID
where s.BaseSalary > (select AVG(s2.BaseSalary)
                      from Salaries as s2
                      join Employees as e2
				on s2.EmployeeID = e2.EmployeeID
                      where e2.DepartmentID = e.DepartmentID);
```

- Q9. Department with Most Employees: Find which department has the most employees.
```sql
select top 1
	d.DepartmentName,
	COUNT(e.EmployeeID) as EmployeeCount
from Employees as e
join Departments as d 
	on e.DepartmentID = d.DepartmentID
group by d.DepartmentName
order by EmployeeCount desc;
```
