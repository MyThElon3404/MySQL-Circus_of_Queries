## Case Study - Employee Management and Payroll
-----------------------------------------------------------------------------------------------------------------

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

- Q1. List the names of the Students who have not enrolled for Java course.
```sql
select name
from StudentMaster
where SID not in (
	select distinct SID
	from EnrollmentMaster
	where CID in (
		select SID
		from CourseMaster
		where CourseName = 'Java'
	)
);
        -- OR --

select s.Name as student_name
from StudentMaster as s
left join EnrollmentMaster as e
	on s.SID = e.SID
	and e.CID = (
		select distinct cid
		from CourseMaster
		where CourseName = 'Java'
	)
where e.CID is null;
```
- Q2. List the name of the advanced course where the enrollment by foreign students is the highest.
``` sql
SELECT TOP 1 cm.CourseName
FROM CourseMaster cm
inner JOIN EnrollmentMaster em 
	ON cm.CID = em.CID
inner JOIN StudentMaster sm 
	ON em.SID = sm.SID
WHERE cm.Category = 'A' 
	AND sm.Origin = 'F'
GROUP BY cm.CourseName
ORDER BY COUNT(*) DESC;

	-- OR --

WITH ForeignStudentEnrollments AS (
    SELECT cm.CourseName, 
		COUNT(*) AS EnrollmentCount
    FROM CourseMaster cm
    inner JOIN EnrollmentMaster em 
		ON cm.CID = em.CID
    inner JOIN StudentMaster sm 
		ON em.SID = sm.SID
    WHERE cm.Category = 'A' 
		AND sm.Origin = 'F'
    GROUP BY cm.CourseName
)
SELECT CourseName
FROM ForeignStudentEnrollments
WHERE EnrollmentCount = (
    SELECT MAX(EnrollmentCount)
    FROM ForeignStudentEnrollments
);
```
- Q3. List the names of the Undergraduate, local students who have got a “B” grade in any basic course.
``` sql
-- Type - 'U'
-- Origin - 'L'
-- Grade - 'B'

select sm.Name as student_name
from StudentMaster as sm
inner join EnrollmentMaster as em
	on sm.sid = em.sid
where sm.Type='U'
	and sm.Origin='L'
	and em.Grade='B';
```
- Q4. List the names of the courses for which no student has enrolled in the month of APRIL 2021.
``` sql
select cm.CourseName,
	CONCAT(DATENAME(MONTH, em.DOE), 
		' ', YEAR(em.DOE)) as enrolled_MMYY
from CourseMaster as cm
inner join EnrollmentMaster as em
	on cm.CID = em.CID
where YEAR(DOE)=2021
	and MONTH(DOE)=04;
```
- Q5. List name, Number of Enrollments and Popularity for all Courses. Popularity has to be displayed as “High” if number of enrollments is higher than 5,
“Medium” if greater than or equal to 3 and less than or equal to 5, and “Low” if the no. is less than 3.
``` sql
select cm.CourseName,
	count(em.CID) as num_of_enrollment,
	case
		when count(em.CID) > 5 then 'High'
		when count(em.CID) >= 3 and count(em.CID) <= 5 then 'Medium'
		when count(em.CID) < 3 then 'Low'
	end as Popularity
from CourseMaster as cm
inner join EnrollmentMaster as em
	on cm.CID = em.CID
group by cm.CourseName;

	-- OR -- Using CTE

WITH EnrollmentCount AS (
    SELECT cm.CourseName,
        COUNT(em.CID) AS num_of_enrollment
    FROM CourseMaster AS cm
    INNER JOIN EnrollmentMaster AS em
        ON cm.CID = em.CID
    GROUP BY cm.CourseName
)
SELECT 
    CourseName,
    num_of_enrollment,
    CASE
        WHEN num_of_enrollment > 5 THEN 'High'
        WHEN num_of_enrollment >= 3 AND num_of_enrollment <= 5 THEN 'Medium'
        WHEN num_of_enrollment < 3 THEN 'Low'
    END AS Popularity
FROM EnrollmentCount;
```
- Q6. List the names of the Local students who have enrolled for exactly 2 basic courses.
``` sql
select sm.Name,
	count(*) as enrolled_count
from StudentMaster as sm
inner join EnrollmentMaster as em
	on sm.SID = em.SID
inner join CourseMaster as cm
	on em.CID = cm.CID
where sm.Origin = 'L'
	and cm.Category = 'B'
group by sm.Name
having count(*) = 2;

	-- OR -- USING CTE
WITH LocalBasicEnrollments AS (
    SELECT sm.SID, sm.Name,
        COUNT(sm.SID) AS EnrolledCount
    FROM StudentMaster AS sm
    INNER JOIN EnrollmentMaster AS em
		ON sm.SID = em.SID
    INNER JOIN CourseMaster AS cm 
		ON em.CID = cm.CID
    WHERE sm.Origin = 'L' AND cm.Category = 'B'
    GROUP BY sm.SID, sm.Name
)
-- Select from the CTE where the enrollment count is exactly 2
SELECT Name
FROM LocalBasicEnrollments
WHERE EnrolledCount = 2;
```
- Q7. List the names of the Courses enrolled by all (every) students.
``` sql
SELECT cm.CourseName
FROM CourseMaster AS cm
WHERE cm.CID NOT IN (
        SELECT cm.CID
        FROM CourseMaster AS cm
        EXCEPT -- distinct values as result
        SELECT em.CID
        FROM EnrollmentMaster AS em
    );

	-- OR --

select distinct cm.CourseName
from CourseMaster as cm
left join EnrollmentMaster as em
	on cm.CID = em.CID
where em.CID is not null;
```
- Q8. For those enrollments for which fee have been waived, when fwf = 1 means yes ,provide the names of students who have got ‘O’ grade.
``` sql
select distinct sm.SID,
	sm.Name
from StudentMaster as sm
inner join EnrollmentMaster as em
	on sm.SID = em.SID
where em.FWF = 1
	and em.Grade = 'O';

	-- OR --

select SID, Name
from StudentMaster
where SID in (
	select distinct SID
	from EnrollmentMaster
	where FWF = 1 and Grade = 'O'
);
```
- Q9. List the names of the foreign, undergraduate students who have got grade ‘O’ in any Advanced course.
``` sql
select distinct sm.SID,
	sm.Name
from StudentMaster as sm
inner join EnrollmentMaster as em
	on sm.SID = em.SID
inner join CourseMaster as cm
	on em.CID = cm.CID
where sm.Origin = 'F'
	and sm.Type = 'U'
	and em.Grade = 'O'
	and cm.Category = 'A';
```
- Q10. List the course name, total no. of enrollments in each month of 2020, 2021.
``` sql
select cm.CourseName,
	count(cm.CID) as enrollment_count,
	DATENAME(MONTH, em.DOE) as month_name,
	year(em.DOE) as year
from CourseMaster as cm
inner join EnrollmentMaster as em
	on cm.CID = em.CID
group by cm.CourseName, DATENAME(MONTH, em.DOE), year(em.DOE)
order by year(em.DOE),
	CASE DATENAME(month, em.DOE) -- this is for order by month name like Jan, Feb, march etc.
        WHEN 'January' THEN 1
        WHEN 'February' THEN 2
        WHEN 'March' THEN 3
        WHEN 'April' THEN 4
        WHEN 'May' THEN 5
        WHEN 'June' THEN 6
        WHEN 'July' THEN 7
        WHEN 'August' THEN 8
        WHEN 'September' THEN 9
        WHEN 'October' THEN 10
        WHEN 'November' THEN 11
        WHEN 'December' THEN 12
    END;
```



















