-- QUESTION : 1
-- 1. Best Selling Item
-- Find the best-selling item for each month (no need to separate months by year). 
-- The best-selling item is determined by the highest total sales amount, 
-- calculated as: total_paid = unitprice * quantity. Output the month, description of the item, and the total amount paid.

CREATE TABLE online_retail (
    invoiceno VARCHAR(20),
    stockcode VARCHAR(20),
    description TEXT,
    quantity INT,
    invoicedate DATE,
    unitprice DECIMAL(10, 2),
    customerid INT,
    country VARCHAR(100)
);
INSERT INTO online_retail (invoiceno, stockcode, description, quantity, invoicedate, unitprice, customerid, country) VALUES
('544586', '21890', 'S/6 WOODEN SKITTLES IN COTTON BAG', 3, '2011-02-21', 2.95, 17338, 'United Kingdom'),
('541104', '84509G', 'SET OF 4 FAIRY CAKE PLACEMATS', 3, '2011-01-13', 3.29, NULL, 'United Kingdom'),
('560772', '22499', 'WOODEN UNION JACK BUNTING', 3, '2011-07-20', 4.96, NULL, 'United Kingdom'),
('555150', '22488', 'NATURAL SLATE RECTANGLE CHALKBOARD', 5, '2011-05-31', 3.29, NULL, 'United Kingdom'),
('570521', '21625', 'VINTAGE UNION JACK APRON', 3, '2011-10-11', 6.95, 12371, 'Switzerland'),
('573511', '21871', 'SAVE THE PLANET MUG', 6, '2011-10-20', 1.95, 14688, 'United Kingdom'),
('559777', '22960', 'JAM MAKING SET PRINTED', 6, '2011-07-13', 4.25, 14911, 'United Kingdom'),
('537626', '23203', 'RIBBON REEL STRIPES DESIGN', 12, '2010-12-01', 1.65, 14196, 'United Kingdom'),
('563843', '22726', 'ALARM CLOCK BAKELIKE RED', 24, '2011-08-09', 3.75, 12921, 'United Kingdom'),
('552365', '22197', 'POPART WOODEN PENCILS ASST', 6, '2011-05-11', 1.25, 15862, 'United Kingdom'),
('574360', '22114', 'HOT WATER BOTTLE BABUSHKA', 3, '2011-10-24', 4.65, 16629, 'United Kingdom'),
('554432', '22662', 'LUNCH BOX WITH CUTLERY RETROSPOT', 3, '2011-05-25', 2.55, 12680, 'France'),
('565499', '22086', 'PAPER CHAIN KIT 50''S CHRISTMAS', 12, '2011-08-17', 2.95, 14688, 'United Kingdom'),
('575257', '22633', 'HAND WARMER SCOTTY DOG DESIGN', 12, '2011-10-27', 1.85, 17061, 'United Kingdom'),
('576628', '21166', 'COOKING SET RETROSPOT', 1, '2011-11-01', 7.65, 17450, 'United Kingdom'),
('558376', '85099B', 'JUMBO BAG RED RETROSPOT', 5, '2011-07-04', 1.65, 13079, 'United Kingdom'),
('572993', '22411', 'JUMBO SHOPPER VINTAGE RED PAISLEY', 2, '2011-10-19', 1.95, 16684, 'United Kingdom'),
('554036', '22835', '3 PIECE SPACEBOY COOKIE CUTTER SET', 12, '2011-05-24', 1.65, 16775, 'Germany'),
('543749', '23084', 'RABBIT NIGHT LIGHT', 12, '2011-02-03', 1.65, 14156, 'United Kingdom'),
('567992', '22666', 'LUNCH BAG SPACEBOY DESIGN', 8, '2011-09-07', 1.65, 16684, 'United Kingdom'),
('574379', '23199', 'SMALL HEART FLOWERS HOOK', 3, '2011-10-24', 2.95, 15157, 'United Kingdom'),
('538070', '84347', 'ROTATING SILVER ANGELS T-LIGHT HLDR', 36, '2010-12-02', 1.25, 16098, 'United Kingdom'),
('560146', '23144', 'MOODY GIRL DOOR HANGER', 48, '2011-07-18', 0.42, 17511, 'United Kingdom'),
('563978', '21984', 'PACK OF 12 RED RETROSPOT TISSUES', 24, '2011-08-09', 0.29, 15750, 'United Kingdom'),
('540569', '22909', 'SET/6 RED SPOTTY PAPER PLATES', 12, '2011-01-07', 0.85, 13448, 'United Kingdom'),
('570607', '21485', 'MULTICOLOUR SUNFLOWER CUSHION COVER', 2, '2011-10-11', 4.25, 12662, 'Belgium'),
('573610', '20966', 'SANDWICH BATH SPONGE', 4, '2011-10-20', 2.95, 16403, 'United Kingdom'),
('560027', '22960', 'JAM MAKING SET PRINTED', 1, '2011-07-15', 4.25, 14048, 'United Kingdom'),
('568296', '22666', 'LUNCH BAG SPACEBOY DESIGN', 24, '2011-09-08', 1.65, 13079, 'United Kingdom'),
('568299', '21232', 'STRAWBERRY CERAMIC TRINKET BOX', 6, '2011-09-08', 1.25, 13079, 'United Kingdom'),
('574379', '23199', 'SMALL HEART FLOWERS HOOK', 3, '2011-10-24', 2.95, 15157, 'United Kingdom');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1 - Using CTEs + DATEPART + FORMAT (SQL Server Style) + INNER JOIN
WITH montly_sales AS (
    SELECT 
        FORMAT(invoicedate, 'yyyy-MM') AS year_month,
        CAST(description AS NVARCHAR(MAX)) AS description,
        SUM(quantity * unitprice) AS total_amt_paid
    FROM online_retail
    GROUP BY FORMAT(invoicedate, 'yyyy-MM'), CAST(description AS NVARCHAR(MAX))
),
highest_amt AS (
    SELECT 
        year_month,
        MAX(total_amt_paid) AS max_paid
    FROM montly_sales
    GROUP BY year_month
)
SELECT 
    ms.year_month, 
    ms.description,
    ha.max_paid
FROM montly_sales ms
INNER JOIN highest_amt ha
    ON ms.year_month = ha.year_month
    AND ms.total_amt_paid = ha.max_paid;

-- SOLUTION 2 - Using ROW_NUMBER() + CTE
WITH montly_sales AS (
    SELECT 
        FORMAT(invoicedate, 'yyyy-MM') AS year_month,
        CAST(description AS NVARCHAR(MAX)) AS description,
        SUM(quantity * unitprice) AS total_amt_paid
    FROM online_retail
    GROUP BY FORMAT(invoicedate, 'yyyy-MM'), CAST(description AS NVARCHAR(MAX))
),
highest_amt AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY year_month ORDER BY total_amt_paid DESC) AS rn
    FROM montly_sales
)
SELECT 
    year_month, 
    description,
    total_amt_paid
FROM highest_amt
WHERE rn = 1;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Customers Without Orders
-- Find customers who have never made an order.
-- Output the first name of the customer.

CREATE TABLE customers (
    id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    city VARCHAR(50),
    address VARCHAR(100),
    phone_number VARCHAR(20)
);
INSERT INTO customers (id, first_name, last_name, city, address, phone_number) 
    VALUES
(8, 'John', 'Joseph', 'San Francisco', '', '928-386-8164'),
(7, 'Jill', 'Michael', 'Austin', '', '813-297-0692'),
(4, 'William', 'Daniel', 'Denver', '', '813-368-1200'),
(5, 'Henry', 'Jackson', 'Miami', '', '808-601-7513'),
(13, 'Emma', 'Isaac', 'Miami', '', '808-690-5201'),
(14, 'Liam', 'Samuel', 'Miami', '', '808-555-5201'),
(15, 'Mia', 'Owen', 'Miami', '', '808-640-5201'),
(1, 'Mark', 'Thomas', 'Arizona', '4476 Parkway Drive', '602-993-5916'),
(12, 'Eva', 'Lucas', 'Arizona', '4379 Skips Lane', '301-509-8805'),
(6, 'Jack', 'Aiden', 'Arizona', '4833 Coplin Avenue', '480-303-1527'),
(2, 'Mona', 'Adrian', 'Los Angeles', '1958 Peck Court', '714-409-9432'),
(10, 'Lili', 'Oliver', 'Los Angeles', '3832 Euclid Avenue', '530-695-1180'),
(3, 'Farida', 'Joseph', 'San Francisco', '3153 Rhapsody Street', '813-368-1200'),
(9, 'Justin', 'Alexander', 'Denver', '4470 McKinley Avenue', '970-433-7589'),
(11, 'Frank', 'Jacob', 'Miami', '1299 Randall Drive', '808-590-5201');

CREATE TABLE orders (
    id INT PRIMARY KEY,
    cust_id INT,
    order_date DATE,
    order_details VARCHAR(50),
    total_order_cost DECIMAL(10, 2),
    FOREIGN KEY (cust_id) REFERENCES customers(id)
);
INSERT INTO orders (id, cust_id, order_date, order_details, total_order_cost) 
    VALUES
(1, 3, '2019-03-04', 'Coat', 100),
(2, 3, '2019-03-01', 'Shoes', 80),
(3, 3, '2019-03-07', 'Skirt', 30),
(4, 7, '2019-02-01', 'Coat', 25),
(5, 7, '2019-03-10', 'Shoes', 80),
(6, 15, '2019-02-01', 'Boats', 100),
(7, 15, '2019-01-11', 'Shirts', 60),
(8, 15, '2019-03-11', 'Slipper', 20),
(9, 15, '2019-03-01', 'Jeans', 80),
(10, 15, '2019-03-09', 'Shirts', 50),
(11, 5, '2019-02-01', 'Shoes', 80),
(12, 12, '2019-01-11', 'Shirts', 60),
(13, 12, '2019-03-11', 'Slipper', 20),
(14, 4, '2019-02-01', 'Shoes', 80),
(15, 4, '2019-01-11', 'Shirts', 60),
(16, 3, '2019-04-19', 'Shirts', 50),
(17, 7, '2019-04-19', 'Suit', 150),
(18, 15, '2019-04-19', 'Skirt', 30),
(19, 15, '2019-04-20', 'Dresses', 200),
(20, 12, '2019-01-11', 'Coat', 125),
(21, 7, '2019-04-01', 'Suit', 50),
(22, 7, '2019-04-02', 'Skirt', 30),
(23, 7, '2019-04-03', 'Dresses', 50),
(24, 7, '2019-04-04', 'Coat', 25),
(25, 7, '2019-04-19', 'Coat', 125);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1 - LEFT JOIN + IS NULL
select c.id,
	CONCAT(c.first_name, ' ', c.last_name) as full_name
from customers c
left join orders o
	on c.id = o.cust_id
where o.id is null;

-- SOLUTION 2 - NOT IN Subquery
select id, first_name, last_name
from customers
where id not in (
	select cust_id from orders
);

-- ==================================================================================================================================

-- QUESTION : 3
-- 3. 

CREATE TABLE fct_customer_sales (
    cust_id VARCHAR(10),
    prod_sku_id VARCHAR(10),
    order_date DATE,
    order_value INT,
    order_id VARCHAR(10)
);
INSERT INTO fct_customer_sales (cust_id, prod_sku_id, order_date, order_value, order_id) 
	VALUES
('C274', 'P474', '2021-06-28', 1500, 'O110'), ('C285', 'P472', '2021-06-28', 899, 'O118'),
('C282', 'P487', '2021-06-30', 500, 'O125'), ('C282', 'P476', '2021-07-02', 999, 'O146'),
('C284', 'P487', '2021-07-07', 500, 'O149'), ('C285', 'P478', '2021-07-12', 700, 'O150'),
('C287', 'P489', '2021-07-13', 189, 'O151'), ('C284', 'P482', '2021-07-15', 725, 'O156'),
('C281', 'P482', '2021-07-19', 725, 'O164'), ('C282', 'P480', '2021-07-22', 300, 'O172'),
('C281', 'P477', '2021-07-23', 1400, 'O174'), ('C273', 'P487', '2021-07-26', 500, 'O181'),
('C287', 'P482', '2021-07-27', 725, 'O186'), ('C280', 'P482', '2021-07-30', 725, 'O190'),
('C282', 'P482', '2021-08-09', 725, 'O202'), ('C280', 'P475', '2021-08-10', 1200, 'O203'),
('C285', 'P487', '2021-08-11', 500, 'O219'), ('C282', 'P486', '2021-08-12', 420, 'O228'),
('C285', 'P479', '2021-08-12', 1020, 'O242'), ('C276', 'P477', '2021-08-13', 1400, 'O244'),
('C283', 'P476', '2021-08-18', 999, 'O246'), ('C285', 'P474', '2021-08-18', 1500, 'O275'),
('C273', 'P482', '2021-08-19', 725, 'O276'), ('C280', 'P474', '2020-08-19', 1500, 'O290'),
('C277', 'P480', '2021-08-23', 300, 'O293'), ('C284', 'P482', '2021-08-30', 725, 'O313'),
('C287', 'P479', '2021-08-31', 1020, 'O315'), ('C277', 'P484', '2021-09-08', 899, 'O322'),
('C275', 'P479', '2021-09-10', 1020, 'O336'), ('C275', 'P475', '2021-09-13', 1200, 'O337'),
('C283', 'P482', '2021-09-13', 725, 'O368'), ('C283', 'P486', '2021-09-14', 420, 'O371'),
('C282', 'P482', '2021-09-20', 725, 'O381'), ('C273', 'P487', '2021-09-23', 500, 'O385'),
('C285', 'P472', '2021-10-01', 899, 'O398'), ('C283', 'P475', '2021-10-04', 1200, 'O399'),
('C279', 'P479', '2021-10-04', 1020, 'O423'), ('C273', 'P472', '2021-10-06', 899, 'O430'),
('C274', 'P476', '2021-10-06', 999, 'O438'), ('C278', 'P478', '2021-10-08', 700, 'O445'),
('C278', 'P472', '2021-10-11', 899, 'O487'), ('C285', 'P486', '2021-10-12', 420, 'O500'),
('C273', 'P487', '2021-10-15', 500, 'O513'), ('C284', 'P489', '2021-10-18', 189, 'O518'),
('C283', 'P486', '2021-10-19', 420, 'O523'), ('C283', 'P477', '2021-10-22', 1400, 'O566'),
('C284', 'P472', '2021-10-25', 899, 'O567'), ('C277', 'P482', '2021-10-29', 725, 'O571'),
('C280', 'P482', '2021-11-03', 725, 'O599'), ('C278', 'P480', '2021-11-04', 300, 'O618'),
('C277', 'P489', '2021-11-05', 189, 'O620'), ('C281', 'P482', '2021-11-09', 725, 'O626'),
('C283', 'P480', '2021-11-11', 300, 'O645'), ('C284', 'P487', '2021-11-15', 500, 'O657'),
('C275', 'P479', '2021-11-19', 1020, 'O680'), ('C281', 'P479', '2021-11-22', 1020, 'O681'),
('C285', 'P480', '2021-11-22', 300, 'O713'), ('C284', 'P476', '2021-11-23', 999, 'O728'),
('C274', 'P485', '2011-11-24', 629, 'O745'), ('C286', 'P474', '2021-11-25', 1500, 'O747'),
('C286', 'P484', '2021-11-26', 899, 'O752'), ('C277', 'P472', '2021-11-29', 899, 'O776'),
('C281', 'P484', '2021-11-30', 899, 'O788'), ('C275', 'P474', '2021-12-01', 1500, 'O796'),
('C280', 'P475', '2021-12-03', 1200, 'O831'), ('C285', 'P480', '2021-12-10', 300, 'O834'),
('C286', 'P487', '2021-12-13', 500, 'O835'), ('C281', 'P476', '2021-12-15', 999, 'O844'),
('C284', 'P486', '2021-12-15', 420, 'O853'), ('C283', 'P478', '2021-12-16', 700, 'O858'),
('C285', 'P489', '2021-12-16', 189, 'O881'), ('C285', 'P484', '2021-12-20', 899, 'O887'),
('C286', 'P489', '2021-12-20', 189, 'O893'), ('C287', 'P485', '2021-12-24', 629, 'O906'),
('C280', 'P477', '2021-12-24', 1400, 'O922'), ('C276', 'P478', '2021-12-31', 700, 'O951'),
('C283', 'P486', '2022-01-03', 420, 'O963'), ('C281', 'P489', '2022-01-11', 189, 'O991');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1 - Using FORMAT() and GROUP BY with TOP
SELECT TOP 3 
    FORMAT(order_date, 'yyyy-MM') AS YearMonth,
    SUM(order_value) AS TotalSales
FROM fct_customer_sales
GROUP BY FORMAT(order_date, 'yyyy-MM')
ORDER BY TotalSales DESC;

-- ==================================================================================================================================
