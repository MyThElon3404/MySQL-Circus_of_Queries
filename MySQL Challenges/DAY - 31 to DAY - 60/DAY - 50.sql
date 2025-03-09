-- QUESTION : 1
-- 1. Write an SQL query to evaluate the boolean expressions in Expressions table.

CREATE TABLE Variables (
    name VARCHAR(50) PRIMARY KEY,
    value INT
);
INSERT INTO Variables (name, value)
VALUES
    ('x', 66),
    ('y', 77);

CREATE TABLE Expressions (
    left_operand VARCHAR(50),
    operator VARCHAR(1) CHECK (operator IN ('<', '>', '=')),
    right_operand VARCHAR(50),
    PRIMARY KEY (left_operand, operator, right_operand)
);
INSERT INTO Expressions (left_operand, operator, right_operand)
VALUES
    ('x', '>', 'y'),
    ('x', '<', 'y'),
    ('x', '=', 'y'),
    ('y', '>', 'x'),
    ('y', '<', 'x'),
    ('x', '=', 'x');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

select e.*,
	case
		when operator = '<' and v1.name < v2.name then 'TRUE'
		when operator = '>' and v1.name > v2.name then 'TRUE'
		when operator = '=' and v1.name = v2.name then 'TRUE'
		else 'FALSE'
	end as result
from Expressions e
inner join Variables v1
	on e.left_operand = v1.name
inner join Variables v2
	on e.right_operand = v2.name;

---------------------------------------- OR ------------------------------------------

SELECT e.*,
    IIF(
        (e.operator = '>' AND v1.value > v2.value) OR
        (e.operator = '<' AND v1.value < v2.value) OR
        (e.operator = '=' AND v1.value = v2.value),
        'TRUE', 
        'FALSE'
    ) AS result
FROM Expressions e
JOIN Variables v1 ON e.left_operand = v1.name
JOIN Variables v2 ON e.right_operand = v2.name;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Mary wants to change seats for the adjacent students.
-- Can you write a SQL query to output the result for Mary?
 
-- +---------+---------+
-- |    id   | student |
-- +---------+---------+
-- |    1    | Abbot   |
-- |    2    | Doris   |
-- |    3    | Emerson |
-- |    4    | Green   |
-- |    5    | Jeames  |
-- +---------+---------+
-- For the sample input, the output is:
-- +---------+---------+
-- |    id   | student |
-- +---------+---------+
-- |    1    | Doris   |
-- |    2    | Abbot   |
-- |    3    | Green   |
-- |    4    | Emerson |
-- |    5    | Jeames  |
-- +---------+---------+

CREATE TABLE Students (
    id INT PRIMARY KEY,
    student VARCHAR(50)
);
INSERT INTO Students (id, student)
VALUES
    (1, 'Abbot'),
    (2, 'Doris'),
    (3, 'Emerson'),
    (4, 'Green'),
    (5, 'Jeames');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

WITH SwappedStudents AS (
    SELECT 
        id, 
        student, 
        ROW_NUMBER() OVER (ORDER BY id) AS row_num
    FROM Students
)
SELECT 
    CASE
        WHEN s1.row_num % 2 = 1 THEN s2.id
        ELSE s1.id
    END AS id,
    CASE
        WHEN s1.row_num % 2 = 1 THEN s2.student
        ELSE s1.student
    END AS student
FROM SwappedStudents s1
JOIN SwappedStudents s2 
    ON s1.row_num = s2.row_num - 1
ORDER BY id;

------------------------------------------- OR --------------------------------------------------

SELECT 
    ROW_NUMBER() OVER (ORDER BY CASE 
                                    WHEN id % 2 = 1 THEN id + 1
                                    ELSE id - 1
                                 END) AS id,
    student
FROM Students;

-- ==================================================================================================================================
