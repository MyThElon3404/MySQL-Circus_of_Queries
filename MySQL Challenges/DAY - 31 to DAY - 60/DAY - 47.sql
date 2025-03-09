-- QUESTION : 1
-- 1. Write a SQL query to find all numbers that appear at least three times consecutively.

CREATE TABLE Logs (
    Id INT,
    Num INT
);
INSERT INTO Logs (Id, Num) VALUES
    (1, 1),
    (2, 1),
    (3, 1),
    (4, 2),
    (5, 1),
    (6, 2),
    (7, 2);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

SELECT DISTINCT Num AS ConsecutiveNums
FROM Logs
WHERE Id + 1 IN (SELECT Id FROM Logs WHERE Num = Logs.Num)
  AND Id + 2 IN (SELECT Id FROM Logs WHERE Num = Logs.Num);

-- ----------------------------------------- OR ---------------------------------------

SELECT DISTINCT Num AS ConsecutiveNums
FROM (
    SELECT 
        Num,
        LAG(Num, 1) OVER (ORDER BY Id) AS PrevNum,
        LAG(Num, 2) OVER (ORDER BY Id) AS Prev2Num
    FROM Logs
) AS Subquery
WHERE Num = PrevNum AND Num = Prev2Num;

-- ----------------------------------------- OR ---------------------------------------

SELECT DISTINCT Num AS ConsecutiveNums
FROM (
    SELECT 
        Num,
        ROW_NUMBER() OVER (PARTITION BY Num ORDER BY Id) AS RowNum
    FROM Logs
) AS Subquery
WHERE RowNum >= 3;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Write a query to print the respective department name and number of students majoring in each
-- department for all departments in the department table (even ones with no current students).
-- Sort your results by descending number of students; if two or more departments have the same number of students, 
-- then sort those departments alphabetically by department name.

CREATE TABLE department (
    dept_id INTEGER PRIMARY KEY,
    dept_name VARCHAR(50)
);
INSERT INTO department (dept_id, dept_name) 
VALUES
(1, 'Engineering'),
(2, 'Science'),
(3, 'Law');

CREATE TABLE student (
    student_id INTEGER PRIMARY KEY,
    student_name VARCHAR(50),
    gender CHAR(1),
    dept_id INTEGER,
    FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);
INSERT INTO student (student_id, student_name, gender, dept_id) 
VALUES
(1, 'Jack', 'M', 1),
(2, 'Jane', 'F', 1),
(3, 'Mark', 'M', 2);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

select dept_name,
	count(student_id) as student_num
from department d
left join student s
	on d.dept_id = s.dept_id
group by dept_name
order by student_num desc, dept_name asc;

-- ==================================================================================================================================
