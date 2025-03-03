-- QUESTION : 1
-- 1. select rows where char 'A' is present

drop table if exists tb;
create table tb (
	s_no int,
	col1 char(1),
	col2 char(2),
	col3 char(3),
	col4 char(4)
);
insert into tb
values
(1, 'A', 'B', 'C', null),
(2, 'C', 'B', null, 'A'),
(3, 'B', null, 'C', null),
(4, null, 'A', 'B', 'C');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1: Using OR statement
select s_no
from tb
where col1 = 'A'
	or col2 = 'A'
	or col3 = 'A'
	or col4 = 'A';

-- SOLUTION 2: Using IN 
SELECT * 
FROM tb
WHERE 'A' IN (col1, col2, col3, col4);

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Person and type is the column names and it is the input table
-- We need output as pair table
-- Like these are adult and child in the table and they are going for a fair and they have a ride on some jhoola, 
-- so one adult can go with one child and is last one adult will be alone

create table family (
	person varchar(5),
	type varchar(10),
	age int
);

insert into family 
values 
('A1','Adult',54),('A2','Adult',53),
('A3','Adult',52),('A4','Adult',58),
('A5','Adult',54),('C1','Child',20),
('C2','Child',19),('C3','Child',22),
('C4','Child',15);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with adult_cte as (
	SELECT Person AS Adult, 
		ROW_NUMBER() OVER (ORDER BY Person) AS RowNum
	FROM family
	WHERE Type = 'Adult'
),
	child_cte as (
		SELECT Person AS Child, 
			ROW_NUMBER() OVER (ORDER BY Person) AS RowNum
		FROM family
		WHERE Type = 'Child'
	)
select a.Adult, COALESCE(c.Child, '') as Child 
from adult_cte a
left join child_cte c
	on a.RowNum = c.RowNum;

-- ==================================================================================================================================
