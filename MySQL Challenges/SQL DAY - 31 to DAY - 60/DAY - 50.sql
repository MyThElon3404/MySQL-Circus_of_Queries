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

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================
