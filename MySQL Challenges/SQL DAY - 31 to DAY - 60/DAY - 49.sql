-- QUESTION : 1
-- 1. Write an SQL query for a report that provides the customer ids from the Customer table that bought all the products in the Product table.

CREATE TABLE Product (
    product_key INT PRIMARY KEY
);
CREATE TABLE Customer (
    customer_id INT,
    product_key INT,
    FOREIGN KEY (product_key) REFERENCES Product(product_key)
);

INSERT INTO Product (product_key)
VALUES (5), (6);

INSERT INTO Customer (customer_id, product_key)
VALUES 
    (1, 5),
    (2, 6),
    (3, 5),
    (3, 6),
    (1, 6);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

select c.customer_id
from Customer c
inner join Product p
	on c.product_key = p.product_key
group by c.customer_id
having count(distinct c.product_key) = 
	(select count(*) from Product);

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. -- Write a SQL query to find employees who have the highest salary in each of the departments.

CREATE TABLE Department (
    Id INT PRIMARY KEY,
    Name VARCHAR(50)
);
INSERT INTO Department (Id, Name)
VALUES 
    (1, 'IT'),
    (2, 'Sales');

CREATE TABLE Employee (
    Id INT PRIMARY KEY,
    Name VARCHAR(50),
    Salary INT,
    DepartmentId INT,
    FOREIGN KEY (DepartmentId) REFERENCES Department(Id)
);
INSERT INTO Employee (Id, Name, Salary, DepartmentId)
VALUES
    (1, 'Joe', 70000, 1),
    (2, 'Jim', 90000, 1),
    (3, 'Henry', 80000, 2),
    (4, 'Sam', 60000, 2),
    (5, 'Max', 90000, 1);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with emp_dept_cte as (
	select d.name as dept_name, e.name as emp_name,
		e.salary,
		DENSE_RANK() over(partition by d.name order by e.salary desc) drn
	from Employee e
	inner join Department d
		on e.DepartmentId = d.Id
)
select dept_name, emp_name,
	salary
from emp_dept_cte
where drn = 1;

-- ==================================================================================================================================
