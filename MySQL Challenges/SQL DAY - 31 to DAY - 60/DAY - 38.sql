-- QUESTION : 1
-- 1. You’re a data analyst at Airbnb and you’ve been tasked with retrieving housing data from specific cities. 
-- You want to find all Airbnb listings in San Francisco and New York that have at least 10 reviews and 
-- an average rating equal to or above 4.5.

DROP TABLE IF EXISTS listings;
CREATE TABLE listings (
    listing_id INTEGER PRIMARY KEY,
    name VARCHAR(30),
    city VARCHAR(30),
    reviews_count INTEGER
);
INSERT INTO listings (listing_id, name, city, reviews_count)
VALUES
(1, 'Modern Apartment', 'San Francisco', 15),
(2, 'Cozy Studio', 'San Francisco', 8),
(3, 'Luxury Condo', 'New York', 25),
(4, 'Budget Room', 'New York', 12),
(5, 'Family Suite', 'New York', 30),
(6, 'Beachfront Villa', 'Los Angeles', 18),
(7, 'Downtown Loft', 'San Francisco', 5),
(8, 'Penthouse Suite', 'New York', 20),
(9, 'Urban Escape', 'San Francisco', 10);


DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews (
    listing_id INTEGER,
    review_id INTEGER PRIMARY KEY,
    stars INTEGER,
    submit_date DATE,
    FOREIGN KEY (listing_id) REFERENCES listings(listing_id)
);
INSERT INTO reviews (listing_id, review_id, stars, submit_date)
VALUES
(1, 101, 5, '2024-01-01'),
(1, 102, 4, '2024-01-02'),
(3, 103, 5, '2024-01-05'),
(3, 104, 5, '2024-01-10'),
(4, 105, 4, '2024-01-12'),
(5, 106, 5, '2024-01-15'),
(5, 107, 5, '2024-01-20'),
(9, 108, 4, '2024-01-22'),
(9, 109, 5, '2024-01-25');

select * from listings;
select * from reviews;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- 1. Using CTE
WITH AverageRatings AS (
    SELECT listing_id, AVG(stars) AS avg_rating
    FROM reviews
    GROUP BY listing_id
)
SELECT l.listing_id, l.name, l.city, a.avg_rating
FROM listings l
JOIN AverageRatings a ON l.listing_id = a.listing_id
WHERE l.city IN ('San Francisco', 'New York')
  AND l.reviews_count >= 10
  AND a.avg_rating >= 4.5;

-- 2. Simple and direct
SELECT l.listing_id, l.name, l.city, AVG(r.stars) AS avg_rating
FROM listings l
JOIN reviews r ON l.listing_id = r.listing_id
WHERE l.city IN ('San Francisco', 'New York')
  AND l.reviews_count >= 10
GROUP BY l.listing_id, l.name, l.city
HAVING AVG(r.stars) >= 4.5;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Write an SQL query to calculate the total transaction amount for each customer for the current year. 
-- The output should contain Customer_Name and the total amount.

drop table if exists Customers;
CREATE TABLE Customers (
    Customer_id INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    Registration_Date DATE
);
-- Insert records into Customer table
INSERT INTO Customers (Customer_id, Customer_Name, Registration_Date)
VALUES (1, 'John Doe', '2023-01-15'),
    (2, 'Jane Smith', '2023-02-20'), (3, 'Michael Johnson', '2023-03-10');

drop table if exists Transactions;
CREATE TABLE Transactions (
    Transaction_id INT PRIMARY KEY,
    Customer_id INT,
    Transaction_Date DATE,
    Amount DECIMAL(10, 2),
    FOREIGN KEY (Customer_id) REFERENCES Customers(Customer_id)
);
-- Insert records into Transaction table
INSERT INTO Transactions (Transaction_id, Customer_id, Transaction_Date, Amount)
VALUES (201, 1, '2024-01-20', 50.00),
	(202, 1, '2024-02-05', 75.50), (203, 2, '2023-02-22', 100.00),
    (204, 3, '2022-03-15', 200.00), (205, 2, '2024-03-20', 120.75),
	(301, 1, '2024-01-20', 50.00), (302, 1, '2024-02-05', 75.50),
    (403, 2, '2023-02-22', 100.00), (304, 3, '2022-03-15', 200.00),
    (505, 2, '2024-03-20', 120.75);

SELECT * FROM customers;
SELECT * FROM transactions;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with product_supplier_cte as (
	select sp.country, pt.product_name, pt.price,
		row_number() over(partition by sp.country order by pt.price desc) as product_rn
	from suppliers as sp
	inner join products as pt
	on sp.supplier_id = pt.supplier_id
)
select country, product_name
from product_supplier_cte
where product_rn = 1;

-- ==================================================================================================================================
