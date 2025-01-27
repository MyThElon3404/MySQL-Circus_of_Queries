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
-- 2. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================
