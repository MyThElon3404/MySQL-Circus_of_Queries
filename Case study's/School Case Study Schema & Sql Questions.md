## School Case Study

### TABLES :

### CourseMaster

|Column Name |	Data Type	 | Remarks |
|------------|-------------|---------|
|CID	       |   Integer	 | Primary Key
|CourseName	 |  Varchar(40)|	NOT NULL 
|Category	   |  Char(1)	   | NULL, Basic/Medium/Advanced
|Fee	       | Smallmoney	 | NOT NULL; Fee can’t be negative

### StudentMaster

|Column Name 	|Data Type	|Remarks|
|-------------|-----------|-------|
|SID	|TinyInt	|Primary Key
|StudentName	|Varchar(40)	|NOT NULL
|Origin	|Char(1)	|NOT NULL, Local/Foreign
|Type	|Char(1)	|NOT NULL, UnderGraduate/Graduate

### EnrollmentMaster 

|Column Name 	|Data Type	|Remarks|
|-------------|-----------|-------|
|CID	|Integer	|NOT NULL Foreign Key
|SID	|Tinyint	|NOT NULL Foreign Key
|DOE	|DateTime	|NOT NULL
|FWF (Fee Waiver Flag)	|Bit	|NOT NULL
|Grade	|Char(1)	|O/A/B/C

### Schema is here: 

<details>
	<summary>Click here for solution</summary>
	
```sql
DROP TABLE IF EXISTS CourseMaster;
CREATE TABLE CourseMaster (
    CID INT PRIMARY KEY,
    CourseName VARCHAR(40) NOT NULL,
    Category CHAR(1) NULL CHECK (Category IN ('B', 'M', 'A')),
    Fee SMALLMONEY NOT NULL CHECK (Fee > 0)
);
-- Inserting data into CourseMaster
INSERT INTO CourseMaster VALUES (10, 'Java', 'B', 5000);
INSERT INTO CourseMaster VALUES (20, 'Adv Java', 'A', 25000);
INSERT INTO CourseMaster VALUES (30, 'Big Data', 'A', 40000);
INSERT INTO CourseMaster VALUES (40, 'Sql Server', 'M', 20000);
INSERT INTO CourseMaster VALUES (50, 'Oracle', 'M', 15000);
INSERT INTO CourseMaster VALUES (60, 'Phthon', 'M', 15000);
INSERT INTO CourseMaster VALUES (70, 'MSBI', 'A', 35000);
INSERT INTO CourseMaster VALUES (80, 'Data Science', 'A', 90000);
INSERT INTO CourseMaster VALUES (90, 'Data Analyst', 'A', 120000);
INSERT INTO CourseMaster VALUES (100, 'Machine Learning', 'A', 125000);
INSERT INTO CourseMaster VALUES (110, 'Basic C++', 'B', 10000);
INSERT INTO CourseMaster VALUES (120, 'Intermediate C++', 'M', 15000);
INSERT INTO CourseMaster VALUES (130, 'Dual C & C++', 'M', 20000);
INSERT INTO CourseMaster VALUES (140, 'Azure', 'B', 35000);
INSERT INTO CourseMaster VALUES (150, 'Microsoft Office Intermediate', 'B', 22000);

DROP TABLE IF EXISTS StudentMaster;
CREATE TABLE StudentMaster (
    SID TINYINT PRIMARY KEY,
    Name VARCHAR(40) NOT NULL,
    Origin CHAR(1) NOT NULL CHECK (Origin IN ('L', 'F')),
    Type CHAR(1) NOT NULL CHECK (Type IN ('U', 'G'))
);
-- Inserting data into StudentMaster
INSERT INTO StudentMaster VALUES (1, 'Bilen Haile', 'F', 'G');
INSERT INTO StudentMaster VALUES (2, 'Durga Prasad', 'L', 'U');
INSERT INTO StudentMaster VALUES (3, 'Geni', 'F', 'U');
INSERT INTO StudentMaster VALUES (4, 'Gopi Krishna', 'L', 'G');
INSERT INTO StudentMaster VALUES (5, 'Hemanth', 'L', 'G');
INSERT INTO StudentMaster VALUES (6, 'K Nitish', 'L', 'G');
INSERT INTO StudentMaster VALUES (7, 'Amit', 'L', 'G');
INSERT INTO StudentMaster VALUES (8, 'Aman', 'L', 'U');
INSERT INTO StudentMaster VALUES (9, 'Halen', 'F', 'G');
INSERT INTO StudentMaster VALUES (10, 'John', 'F', 'U');
INSERT INTO StudentMaster VALUES (11, 'Anil', 'L', 'U');
INSERT INTO StudentMaster VALUES (12, 'Mike', 'F', 'G');
INSERT INTO StudentMaster VALUES (13, 'Suman', 'L', 'U');
INSERT INTO StudentMaster VALUES (14, 'Angelina', 'F', 'G');
INSERT INTO StudentMaster VALUES (15, 'Bhavik', 'L', 'U');
INSERT INTO StudentMaster VALUES (16, 'Bob Tyson', 'F', 'G');
INSERT INTO StudentMaster VALUES (17, 'Salman', 'L', 'U');
INSERT INTO StudentMaster VALUES (18, 'Selina', 'F', 'G');
INSERT INTO StudentMaster VALUES (19, 'Rajkummar', 'L', 'U');
INSERT INTO StudentMaster VALUES (20, 'Pooja', 'L', 'U');

DROP TABLE IF EXISTS EnrollmentMaster;
CREATE TABLE EnrollmentMaster (
    CID INT NOT NULL FOREIGN KEY REFERENCES CourseMaster(CID),
    SID TINYINT NOT NULL FOREIGN KEY REFERENCES StudentMaster(SID),
    DOE DATE NOT NULL,
    FWF BIT NOT NULL,
    Grade CHAR(1) NULL CHECK (Grade IN ('O', 'A', 'B', 'C'))
);
-- Inserting data into EnrollmentMaster
INSERT INTO EnrollmentMaster VALUES (40, 1, '2020-11-19', 0, 'O');
INSERT INTO EnrollmentMaster VALUES (70, 1, '2020-11-21', 0, 'O');
INSERT INTO EnrollmentMaster VALUES (30, 2, '2020-11-22', 1, 'A');
INSERT INTO EnrollmentMaster VALUES (60, 4, '2020-11-25', 1, 'O');
INSERT INTO EnrollmentMaster VALUES (40, 5, '2020-12-02', 1, 'C');
INSERT INTO EnrollmentMaster VALUES (50, 7, '2020-12-05', 0, 'B');
INSERT INTO EnrollmentMaster VALUES (50, 4, '2020-12-10', 0, 'A');
INSERT INTO EnrollmentMaster VALUES (80, 3, '2020-11-11', 1, 'O');
INSERT INTO EnrollmentMaster VALUES (80, 4, '2020-12-22', 0, 'B');
INSERT INTO EnrollmentMaster VALUES (70, 6, '2020-12-25', 0, 'A');
INSERT INTO EnrollmentMaster VALUES (60, 7, '2021-01-01', 0, 'A');
INSERT INTO EnrollmentMaster VALUES (40, 8, '2021-01-02', 1, 'O');
INSERT INTO EnrollmentMaster VALUES (80, 9, '2021-01-03', 0, 'B');
INSERT INTO EnrollmentMaster VALUES (20, 4, '2021-01-04', 0, 'A');
INSERT INTO EnrollmentMaster VALUES (40, 9, '2021-04-01', 1, 'O');
INSERT INTO EnrollmentMaster VALUES (90, 4, '2021-04-05', 0, 'A');
INSERT INTO EnrollmentMaster VALUES (30, 11, '2021-04-08', 0, 'A');
INSERT INTO EnrollmentMaster VALUES (110, 11, '2021-04-11', 1, 'B');
INSERT INTO EnrollmentMaster VALUES (30, 18, '2021-04-12', 1, 'A');
INSERT INTO EnrollmentMaster VALUES (130, 12, '2021-04-13', 0, 'B');
INSERT INTO EnrollmentMaster VALUES (40, 10, '2021-04-18', 1, 'O');
INSERT INTO EnrollmentMaster VALUES (150, 12, '2021-04-22', 1, 'A');
INSERT INTO EnrollmentMaster VALUES (70, 17, '2021-04-25', 0, 'B');
INSERT INTO EnrollmentMaster VALUES (120, 1, '2021-04-30', 0, 'O');
INSERT INTO EnrollmentMaster VALUES (90, 8, '2021-05-02', 0, 'A');
INSERT INTO EnrollmentMaster VALUES (100, 18, '2021-05-05', 0, 'B');
INSERT INTO EnrollmentMaster VALUES (90, 10, '2021-05-12', 1, 'O');
INSERT INTO EnrollmentMaster VALUES (110, 15, '2021-05-15', 0, 'B');
INSERT INTO EnrollmentMaster VALUES (120, 5, '2021-05-20', 1, 'A');
INSERT INTO EnrollmentMaster VALUES (130, 6, '2021-05-25', 1, 'O');
INSERT INTO EnrollmentMaster VALUES (140, 15, '2021-05-28', 0, 'A');
INSERT INTO EnrollmentMaster VALUES (120, 6, '2021-05-31', 0, 'B');
INSERT INTO EnrollmentMaster VALUES (150, 5, '2021-06-12', 1, 'A');
INSERT INTO EnrollmentMaster VALUES (80, 8, '2021-06-15', 1, 'B');
INSERT INTO EnrollmentMaster VALUES (140, 14, '2021-06-20', 0, 'O');
INSERT INTO EnrollmentMaster VALUES (90, 3, '2021-06-23', 1, 'O');
INSERT INTO EnrollmentMaster VALUES (100, 3, '2021-07-02', 0, 'A');
INSERT INTO EnrollmentMaster VALUES (40, 13, '2021-07-22', 0, 'B');
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
