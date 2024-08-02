## School Case Study
#### TABLES
CREATE THE FOLLOWING THREE TABLES WITH SAME NAMES AND DATA TYPES AS PROVIDED BELOW:

|Column Name |	Data Type	 | Remarks |
|------------|-------------|---------|
|CID	       |   Integer	 | Primary Key
|CourseName	 |  Varchar(40)|	NOT NULL 
|Category	   |  Char(1)	   | NULL, Basic/Medium/Advanced
|Fee	       | Smallmoney	 | NOT NULL; Fee can’t be negative

#### StudentMaster

|Column Name 	|Data Type	|Remarks|
|-------------|-----------|-------|
|SID	|TinyInt	|Primary Key
|StudentName	|Varchar(40)	|NOT NULL
|Origin	|Char(1)	|NOT NULL, Local/Foreign
|Type	|Char(1)	|NOT NULL, UnderGraduate/Graduate

#### EnrollmentMaster 

|Column Name 	|Data Type	|Remarks|
|-------------|-----------|-------|
|CID	|Integer	|NOT NULL Foreign Key
|SID	|Tinyint	|NOT NULL Foreign Key
|DOE	|DateTime	|NOT NULL
|FWF (Fee Waiver Flag)	|Bit	|NOT NULL
|Grade	|Char(1)	|O/A/B/C
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
-- Q1. 




















