- Mastering MySQL Queries: A Comprehensive Guide -> https://medium.com/@gayankurukulasooriya/mastering-mysql-queries-a-comprehensive-guide-bce3ab06f2ad

- MySQL Best Practices: 🚀 Optimizing Performance and Reliability with Advanced Concepts -> https://smit90.medium.com/mysql-best-practices-optimizing-performance-and-reliability-with-advanced-concepts-c4f5ebedbcbe

- MySQL Performance Optimizations -> https://medium.com/@rjmascolo/mysql-performance-optimizations-13a14b12a092

- MySQL Data Types for Optimal Performance -> https://medium.com/@ganeshchamp39/mysql-data-types-for-optimal-performance-404313179d60

- SQL Ques. - https://www.youtube.com/watch?v=cIyqUG17REA

- LeetCode Ques. - https://github.com/mrinal1704/SQL-Leetcode-Challenge/tree/master/Easy

- Case Study - https://www.analyticsvidhya.com/blog/2025/01/sql-query-interview-questions/

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentID INT,
    Salary DECIMAL(10,2),
    HireDate DATE,
    ManagerID INT NULL,
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    EmployeeID INT,
    ProductID INT,
    Quantity INT,
    OrderDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10,2),
    Category VARCHAR(50)
);

-- Insert data into Employees table
INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary, HireDate, ManagerID) VALUES
(1, 'Alice', 'Johnson', 101, 60000, '2018-01-15', 3),
(2, 'Bob', 'Smith', 102, 75000, '2017-05-20', 3),
(3, 'Charlie', 'Brown', 101, 90000, '2015-09-30', NULL),
(4, 'David', 'Williams', 103, 55000, '2019-07-11', 3),
(5, 'Eva', 'Davis', 102, 65000, '2020-03-25', 2);

-- Insert data into Products table
INSERT INTO Products (ProductID, ProductName, Price, Category) VALUES
(201, 'Laptop', 1200, 'Electronics'),
(202, 'Smartphone', 800, 'Electronics'),
(203, 'Office Chair', 150, 'Furniture'),
(204, 'Desk', 300, 'Furniture'),
(205, 'Monitor', 200, 'Electronics');

-- Insert data into Orders table
INSERT INTO Orders (OrderID, EmployeeID, ProductID, Quantity, OrderDate) VALUES
(1001, 1, 201, 10, '2022-01-15'),
(1002, 2, 202, 5, '2022-01-16'),
(1003, 3, 203, 20, '2022-01-17'),
(1004, 4, 202, 15, '2022-01-18'),
(1005, 5, 204, 25, '2022-01-19');

