-- ==========================================================================================
-- 			Basic SQL Queries for begineer - Fundamentals of SQL
-- ==========================================================================================
drop schema if exists Basic_SQL;

CREATE SCHEMA Basic_SQL;
use Basic_SQL;
-- ==========================================================================================

# before start with query execution 
# we need to drop existing table if any

drop table if exists employee;
drop table if exists department;
drop table if exists company;
-- ==========================================================================================

# primary key - A primary key is used to ensure that data in the specific column is unique. A column cannot have NULL values.
# foreign key - A foreign key is a column or group of columns in a relational database table that provides a link between data 
# in two tables. It is a column (or columns) that references a column (most often the primary key) of another table. 

# let's create some tables like ->
# 1. employee (id, name, city, department, salary)
# 2. department (id, name)
# 3. company (id, name, revenue)

create table if not exists department (
	id INT primary key auto_increment,
    name varchar(50) NOT NULL
);

create table if not exists employee (
	id INT primary key auto_increment,
    name varchar(150) NOT NULL,
    city varchar(150) NOT NULL,
    department_id INT NOT NULL,
    salary INT NOT NULL,
    foreign key (department_id) references department(id)
);

create table if not exists company (
	id INT primary key auto_increment,
    name varchar(150) NOT NULL,
    revenue INT NOT NULL
);
# note :- if you referencing any column of any table into another table then make sure you have created reference table first
-- ==========================================================================================

# inserting some rows (data) into the columns of tables -> 

insert into department (name)
values
('IT'),
('Management'),
('IT'),
('Support');

insert into employee (name, city, department_id, salary)
values
('David', 'London', 3, 80000),
('Emily', 'London', 3, 70000),
('Peter', 'Paris', 3, 60000),
('Ava', 'Paris', 3, 50000),
('Penny', 'London', 2, 110000),
('Jim', 'London', 2, 90000),
('Amy', 'Rome', 4, 30000),
('Cloe', 'London', 3, 110000);

insert into company (name, revenue)
values
('IBM', 2000000),
('GOOGLE', 9000000),
('Apple', 10000000);
-- ==========================================================================================

# table data -> 
select * from department;
select * from employee;
select * from company;
-- ==========================================================================================

# Query - Change the name of department with id =  1 to 'Management'
update department
set name = 'Management'
where id = 1;
select * from department;
-- ==========================================================================================

# Query - Delete employees with salary greater than 100 000
delete from employee
where salary > 100000;
select * from employee;
-- ==========================================================================================

# Query - Query the names of companies
select name from company;
-- ==========================================================================================

# Query - Query the name and city of every employee
select name, city from employee;
-- ==========================================================================================

# Query - Query all companies with revenue greater than 5 000 000
select * from company
where revenue > 5000000;
-- ==========================================================================================

# Query - Query all companies with revenue smaller than 5 000 000
select *  from company
where revenue < 5000000;
-- ==========================================================================================

# Query - Query all companies with revenue smaller than 5 000 000, but you cannot use the '<' operator
select * from company
order by revenue
limit 1;

/*version 2*/
SELECT * FROM company
WHERE NOT revenue >= 5000000;
-- ==========================================================================================

# Query - Query all employees with salary greater than 50 000 and smaller than 70 000
select * from employee
where salary >= 50000 AND salary <= 70000;

/*version 2*/
select * from employee
where salary between 50000 and 70000;
-- ==========================================================================================

# Query - Query all employees with salary greater than 50 000 and smaller than 70 000
select * from employee
where salary between 50000 and 70000;
-- ==========================================================================================

# Query - Query all employees with salary greater than 50 000 and smaller than 70 000, but you cannot use BETWEEN
select * from employee
where salary >= 50000 and salary <= 70000;
-- ==========================================================================================

# Query - Query all employees with salary equal to 80 000
select * from employee
where salary = 80000;
-- ==========================================================================================

# Query - Query all employees with salary NOT equal to 80 000
select * from employee
where NOT salary = 80000;

/*version 2*/
select * from employee
where salary <> 80000;

/*version 3*/
select * from employee
where salary != 80000;
-- ==========================================================================================

# Query - Query all names of employees with salary greater than 70 000 together with employees who work on the 'IT' department.
select name from employee
where salary > 70000 OR 
department_id IN (select id from department
				 where name = 'IT');
-- ==========================================================================================

# Query - Query all employees that work in city that starts with 'L'
select * from employee
where city like 'L%';
-- ==========================================================================================

# Query - Query all employees that work in city that starts with 'L' or ends with 's'
select * from employee
where city like 'L%' or city like '%s';
-- ==========================================================================================

# Query - Query all employees that  work in city with 'o' somewhere in the middle
select * from employee
where city like '%o%';

-- ==========================================================================================

# Query - Query all departments (each name only once)
select distinct name from department;

-- ==========================================================================================

# Query - Query names of all employees together with id of department they work in, but you cannot use JOIN
select e.name, d.id, d.name from employee e, department d
where e.department_id = d.id
order by e.name, d.id;
-- ==========================================================================================

# Query - Query names of all employees together with id of department they work in, but use JOIN
select e.name, d.id, d.name from employee e
join department d
where e.department_id = d.id
order by e.name, d.id;
-- ==========================================================================================

# Query - Query name of every company together with every department
# Personal thoughts: It is kinda weird question, as there is no relationship between company and departement
select c.name, d.name
from company c, department d;
-- ==========================================================================================

# Query - Query name of every company together with departments without the 'Support' department
select c.name, d.name
from company c, department d
where d.name not like 'Support'
order by c.name;
-- ==========================================================================================

# Query - Query employee name together with the department name that they are not working in
select e.name, d.name
from employee e, department d
where e.department_id <> d.id;
-- ==========================================================================================

# Query - Query all employees that work in same department as Peter
SELECT * FROM employee
WHERE department_id IN(
	SELECT department_id FROM employee
    WHERE name LIKE 'Peter'
)
AND name NOT LIKE 'Peter';
-- ==========================================================================================

# For more fundamental Queries - https://www.mysqltutorial.org/mysql-basics/

-- ==========================================================================================