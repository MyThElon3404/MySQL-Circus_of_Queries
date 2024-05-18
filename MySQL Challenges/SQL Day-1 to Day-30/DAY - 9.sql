-- QUESTION : 1
-- 1. write a query in SQL to find the highest daily total order for an item between 2019-07-01 to 2019-12-31. Return item description, order date and the total order quantity.

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
	ORDER_ID int NOT NULL,
	CUSTOMER_ID int NOT NULL,
	ITEM_DESC varchar(30) NOT NULL,
	ORDER_DATE date NOT NULL,
	order_qty int not null,
	PRIMARY KEY (ORDER_ID)
);

insert into orders
values
(101	,2109	,'juice		','2019-07-21',	50), (102	,2139	,'chocolate	','2019-05-17',	40),
(103	,2120	,'juice		','2019-05-17',	40), (104	,2108	,'cookies		','2019-05-17',	50),
(105	,2130	,'juice		','2019-10-18',	45), (106	,2103	,'cake		','2019-07-21',	35),
(107	,2122	,'cookies		','2019-12-17',	40), (108	,2125	,'cake		','2019-12-17',	38),
(109	,2139	,'cake		','2019-07-21',	40), (110	,2141	,'cookies		','2019-05-17',	60),
(111	,2116	,'cake		','2019-10-18',	45), (112	,2128	,'cake		','2019-10-18',	38),
(113	,2146	,'chocolate	','2019-10-18',	55), (114	,2119	,'cookies		','2019-10-18',	30),
(115	,2142	,'cake		','2019-03-05',	26), (116	,2122	,'cake		','2019-03-05',	59),
(117	,2128	,'chocolate	','2019-06-19',	45), (118	,2112	,'cookies		','2019-06-19',	28),
(119	,2149	,'cookies		','2019-10-18',	49), (120	,2100	,'cookies		','2020-03-14',	76),
(121	,2130	,'juice		','2020-03-14',	20), (122	,2103	,'juice		','2019-07-21',	27),
(123	,2112	,'cookies		','2019-06-19',	52), (124	,2102	,'cake		','2019-07-21',	14),
(125	,2120	,'chocolate	','2019-07-21',	85), (126	,2109	,'cake		','2019-06-19',	18),
(127	,2101	,'juice		','2019-10-18',	64), (128	,2138	,'juice		','2019-06-19',	55),
(129	,2100	,'juice		','2019-07-21',	45), (130	,2129	,'juice		','2019-10-18',	35);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

SELECT TOP 1
	item_desc,
	order_date,
	SUM(order_qty) dayorder 
FROM orders
WHERE order_date BETWEEN '2019-07-01' AND '2019-12-31'
GROUP BY item_desc,order_date
ORDER BY dayorder DESC;
--limit 1;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. A company's executives are interested in seeing who earns the most money in each of the company's departments. 

DROP TABLE IF EXISTS Department;
CREATE TABLE Department (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

INSERT INTO Department (id, name) VALUES
(1, 'IT'),
(2, 'Sales');

DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    salary INT,
    deptId INT,
    FOREIGN KEY (deptId) REFERENCES Department(id)
);

-- Insert additional records into Employee table
INSERT INTO Employee (id, name, salary, deptId) 
VALUES
(8, 'Alice', 75000, 2), (9, 'Bob', 82000, 2), (10, 'Carol', 78000, 1),
(11, 'David', 70000, 1), (12, 'Eva', 85000, 2), (13, 'Frank', 72000, 1),
(14, 'Gina', 83000, 1), (15, 'Hank', 68000, 1), (16, 'Irene', 76000, 2),
(17, 'Jack', 74000, 2), (18, 'Kelly', 79000, 1), (19, 'Liam', 71000, 1),
(20, 'Molly', 77000, 2), (21, 'Nathan', 81000, 1), (22, 'Olivia', 73000, 2),
(23, 'Peter', 78000, 1), (24, 'Quinn', 72000, 1), (25, 'Rachel', 80000, 2),
(26, 'Steve', 75000, 2),(27, 'Tina', 79000, 1);

select * from Department;
select * from Employee;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with emp_dept_cte as (
	select em.name as employee_name,
	em.salary as employee_salary,
	dt.name as department_name,
	DENSE_RANK() over(partition by dt.name order by em.salary desc) as emp_dept_dn
from Department as dt
inner join Employee as em
	on dt.id = em.deptId
)
select employee_name, employee_salary, department_name
from emp_dept_cte
where emp_dept_dn = 1;

-- ==================================================================================================================================
