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
-- 2. As an analyst at Airbnb, one of the most useful insights you could provide would be to understand the 
-- average number of guests per booking across locations. For this question, 
-- we would like you to write a SQL query that will find the average number of guests per booking in each city.

DROP TABLE IF EXISTS bookings;
CREATE TABLE bookings (
    booking_id INTEGER PRIMARY KEY,
    property_id INTEGER,
    guests INTEGER,
    booking_date DATE
);
INSERT INTO bookings (booking_id, property_id, guests, booking_date) 
VALUES
(1, 101, 2, '2024-11-01'),
(2, 102, 4, '2024-11-02'),
(3, 103, 1, '2024-11-03'),
(4, 104, 3, '2024-11-04'),
(5, 105, 5, '2024-11-05'),
(6, 101, 2, '2024-11-06'),
(7, 102, 4, '2024-11-07'),
(8, 103, 1, '2024-11-08'),
(9, 104, 3, '2024-11-09');


DROP TABLE IF EXISTS properties;
CREATE TABLE properties (
    property_id INTEGER PRIMARY KEY,
    city VARCHAR(50)
);
INSERT INTO properties (property_id, city) 
VALUES
(101, 'New York'),
(102, 'Los Angeles'),
(103, 'Chicago'),
(104, 'New York'),
(105, 'Los Angeles'),
(106, 'Chicago'),
(107, 'New York'),
(108, 'Los Angeles'),
(109, 'Chicago');

select * from bookings;
select * from properties;

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

select p.city as city,
	AVG(guests) as avg_guests
from bookings as b
join properties as p
	on b.property_id = p.property_id
group by p.city;

-- ==================================================================================================================================
