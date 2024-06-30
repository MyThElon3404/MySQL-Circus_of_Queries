-- QUESTION : 1
-- 1. As a data scientist at Amazon Prime Video, you are tasked with enhancing the in-flight entertainment experience for 
-- Amazon’s airline partners. Your challenge is to develop a feature that suggests individual movies from Amazon's 
-- content database that fit within a given flight's duration. For flight 101, find movies whose runtime is less than or 
-- equal to the flight's duration.
-- The output should list suggested movies for the flight, including 'flight_id', 'movie_id', and 'movie_duration'."
DROP TABLE IF EXISTS entertainment_catalog;
CREATE TABLE entertainment_catalog (
    movie_id INT,
    title VARCHAR(100),
    duration INT
);
INSERT INTO entertainment_catalog (movie_id, title, duration)
VALUES
(1, 'The Great Adventure', 120),
(2, 'Space Journey', 90),
(3, 'Ocean Mystery', 60),
(4, 'The Lost City', 150),
(5, 'Mountain Quest', 110),
(6, 'Time Travels', 95),
(7, 'Desert Mirage', 100),
(8, 'Sky High', 85),
(9, 'Deep Sea', 75),
(10, 'City Lights', 105);

DROP TABLE IF EXISTS flight_schedule;
CREATE TABLE flight_schedule (
    flight_id INT,
    flight_duration INT,
    flight_date DATETIME
);
INSERT INTO flight_schedule (flight_id, flight_duration, flight_date)
VALUES
(101, 240, '2024-01-01'),
(102, 180, '2024-01-02'),
(103, 240, '2024-01-03'),
(104, 150, '2024-01-04'),
(105, 300, '2024-01-05'),
(106, 200, '2024-01-06'),
(107, 180, '2024-01-07'),
(108, 270, '2024-01-08'),
(109, 220, '2024-01-09'),
(110, 190, '2024-01-10');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

SELECT fs.flight_id, ec.movie_id, ec.title,
  ec.duration AS movie_duration,
  fs.flight_duration
FROM flight_schedule fs
JOIN entertainment_catalog ec 
	ON ec.duration <= fs.flight_duration
WHERE fs.flight_id = 101;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Find the total number of housing units completed for each year. 
-- Output the year along with the total number of housings. Order the result by year in ascending order.
drop table if exists housing_units_completed_us;
CREATE TABLE housing_units_completed_us (
    year INT,
    month INT,
    south FLOAT,
    west FLOAT,
    midwest FLOAT,
    northeast FLOAT
);
INSERT INTO housing_units_completed_us (year, month, south, west, midwest, northeast) 
VALUES
(2006, 1, 69.8, 35.8, 23.5, 13.3),
(2006, 2, 68.5, 38.0, 21.3, 14.0),
(2006, 3, 87.6, 42.8, 26.1, 12.7),
(2006, 4, 77.9, 38.6, 26.6, 17.2),
(2006, 5, 78.0, 41.7, 25.5, 13.7),
(2006, 6, 86.5, 48.2, 29.3, 15.5),
(2006, 7, 85.1, 36.6, 27.2, 14.8),
(2006, 8, 82.1, 41.9, 30.4, 16.1),
(2006, 9, 86.2, 46.1, 30.5, 18.0),
(2006, 10, 87.9, 40.8, 29.4, 14.4),
(2006, 11, 82.6, 35.8, 26.4, 14.0),
(2006, 12, 94.5, 42.3, 29.0, 15.3),
(2007, 1, 67.7, 30.0, 17.7, 11.9),
(2007, 2, 62.3, 25.2, 15.3, 9.7),
(2007, 3, 64.3, 31.9, 17.0, 9.7),
(2007, 4, 63.7, 28.3, 17.7, 9.2),
(2007, 5, 66.1, 32.9, 19.4, 11.2),
(2007, 6, 67.1, 30.4, 19.1, 14.5),
(2007, 7, 67.3, 31.5, 19.3, 11.0),
(2007, 8, 70.0, 36.2, 16.6, 14.1),
(2007, 9, 57.2, 30.9, 22.9, 12.2),
(2007, 10, 62.1, 28.0, 19.4, 16.6),
(2007, 11, 56.6, 31.3, 19.9, 10.9),
(2007, 12, 61.8, 32.7, 18.4, 13.8),
(2008, 1, 48.4, 23.6, 12.9, 8.7),
(2008, 2, 48.1, 16.5, 15.2, 7.2),
(2008, 3, 47.1, 23.1, 12.6, 7.0),
(2008, 4, 40.6, 19.0, 11.2, 8.6),
(2008, 5, 48.5, 21.3, 15.2, 11.5),
(2008, 6, 51.4, 23.4, 17.3, 7.6),
(2008, 7, 45.7, 23.0, 11.6, 11.1),
(2008, 8, 50.0, 19.6, 16.0, 8.9),
(2008, 9, 47.2, 24.5, 22.1, 10.4),
(2008, 10, 48.0, 22.8, 15.6, 7.8),
(2008, 11, 43.3, 22.5, 16.2, 9.4),
(2008, 12, 49.0, 25.1, 12.3, 11.4),
(2009, 1, 27.8, 12.6, 8.0, 6.2),
(2009, 2, 26.9, 14.8, 7.8, 6.9),
(2009, 3, 32.2, 16.8, 8.3, 4.8),
(2009, 4, 31.7, 13.8, 9.1, 10.9),
(2009, 5, 35.0, 16.4, 10.0, 6.7),
(2009, 6, 34.3, 16.4, 10.3, 9.4),
(2009, 7, 31.4, 17.0, 9.4, 8.6),
(2009, 8, 41.3, 14.5, 11.9, 6.3),
(2009, 9, 29.8, 15.9, 9.9, 8.9),
(2009, 10, 32.3, 17.2, 9.0, 9.0),
(2009, 11, 33.7, 17.3, 13.1, 8.5),
(2009, 12, 37.2, 14.8, 12.3, 8.1),
(2010, 1, 21.2, 13.9, 5.5, 5.8),
(2010, 2, 23.0, 11.2, 5.7, 5.6),
(2010, 3, 26.0, 12.5, 5.7, 4.4),
(2010, 4, 32.1, 10.5, 7.9, 7.2),
(2010, 5, 26.2, 14.9, 10.0, 7.5),
(2010, 6, 33.9, 21.2, 14.8, 7.7),
(2010, 7, 23.8, 9.8, 8.8, 5.8),
(2010, 8, 26.6, 10.9, 9.3, 7.9),
(2010, 9, 26.7, 13.2, 8.8, 7.9),
(2010, 10, 25.9, 10.0, 10.7, 8.2),
(2010, 11, 22.4, 8.4, 11.0, 6.5),
(2010, 12, 28.9, 11.2, 8.7, 5.9);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

select year,
	sum(south + west + midwest + northeast) as total_housing_unit
from housing_units_completed_us
group by year
order by year asc;

-- ==================================================================================================================================
