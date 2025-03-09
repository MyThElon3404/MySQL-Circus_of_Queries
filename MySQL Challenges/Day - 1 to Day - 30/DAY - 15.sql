-- QUESTION : 1
-- 1. Find the top 10 users that have traveled the greatest distance. Output their id, name and a total distance traveled.

DROP TABLE IF EXISTS lyft_rides_log;
CREATE TABLE lyft_rides_log (
    id INT PRIMARY KEY,
    user_id INT,
    distance INT
);
INSERT INTO lyft_users (id, name) 
VALUES
(1, 'John Doe'),
(2, 'Jane Smith'),
(3, 'Alice Johnson'),
(4, 'Bob Brown'),
(5, 'Charlie Davis'),
(6, 'Emily White'),
(7, 'David Black'),
(8, 'Sophia Blue'),
(9, 'Michael Green'),
(10, 'Emma Red');

DROP TABLE IF EXISTS lyft_users;
CREATE TABLE lyft_users (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);
INSERT INTO lyft_rides_log (id, user_id, distance) 
VALUES
(1, 1, 10),
(2, 1, 15),
(3, 2, 5),
(4, 2, 20),
(5, 3, 25),
(6, 3, 30),
(7, 4, 10),
(8, 5, 5),
(9, 5, 10),
(10, 6, 40),
(11, 6, 35),
(12, 7, 50),
(13, 7, 20),
(14, 8, 10),
(15, 8, 15),
(16, 9, 30),
(17, 9, 25),
(18, 10, 5),
(19, 10, 10),
(20, 1, 20),
(21, 2, 25),
(22, 3, 35),
(23, 4, 45),
(24, 5, 50),
(25, 6, 55),
(26, 7, 60),
(27, 8, 65),
(28, 9, 70),
(29, 10, 75),
(30, 1, 80),
(31, 2, 85),
(32, 3, 90),
(33, 4, 95),
(34, 5, 100),
(35, 6, 105),
(36, 7, 110),
(37, 8, 115),
(38, 9, 120),
(39, 10, 125),
(40, 1, 130),
(41, 2, 135),
(42, 3, 140),
(43, 4, 145),
(44, 5, 150),
(45, 6, 155),
(46, 7, 160),
(47, 8, 165),
(48, 9, 170),
(49, 10, 175),
(50, 1, 180),
(51, 2, 185),
(52, 3, 190),
(53, 4, 195),
(54, 5, 200);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

SELECT u.id, u.name, 
  SUM(r.distance) AS total_distance
FROM lyft_rides_log as r
INNER JOIN lyft_users as u 
  ON r.user_id = u.id
GROUP BY u.id, u.name
ORDER BY total_distance DESC
LIMIT 10; -- or top 10 

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. You're tasked with analyzing a Spotify-like dataset that captures user listening habits.
-- For each user, calculate the total listening time and the count of unique songs they've listened to. In the database duration values are displayed in seconds. Round the total listening duration to the nearest whole minute.
--The output should contain three columns: 'user_id', 'total_listen_duration', and 'unique_song_count'.

DROP TABLE IF EXISTS listening_habits;
CREATE TABLE listening_habits (
    user_id INT,
    song_id INT,
    listen_duration FLOAT
);
INSERT INTO listening_habits (user_id, song_id, listen_duration) 
VALUES
(1, 101, 320.5), (1, 102, 180.0), (1, 103, 200.0),
(2, 101, 150.5), (2, 104, 250.0), (2, 105, 300.0),
(3, 106, 120.0), (3, 107, 180.0), (3, 108, 240.0),
(4, 109, 150.0), (4, 110, 210.0), (4, 111, 300.0),
(5, 112, 180.0), (5, 113, 200.5), (5, 114, 190.0),
(6, 115, 160.0), (6, 116, 220.0), (6, 117, 210.0),
(7, 118, 300.0), (7, 119, 180.5), (7, 120, 220.0),
(8, 121, 250.0), (8, 122, 300.0), (8, 123, 280.0),
(9, 124, 190.5), (9, 125, 200.0), (9, 126, 210.0),
(10, 127, 220.0), (10, 128, 240.0), (10, 129, 300.0),
(11, 130, 180.0), (11, 131, 200.0), (11, 132, 220.0),
(12, 133, 210.5), (12, 134, 230.0), (12, 135, 250.0),
(13, 136, 240.0), (13, 137, 260.0), (13, 138, 280.0),
(14, 139, 300.0), (14, 140, 180.0), (14, 141, 200.5),
(15, 142, 220.0), (15, 143, 240.0), (15, 144, 260.0),
(16, 145, 280.0), (16, 146, 300.0), (16, 147, 180.5),
(17, 148, 200.0), (17, 149, 220.0);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

select user_id, 
	round(sum(listen_duration)/60, 0) as total_listening_time,
	count(distinct song_id) as unique_song_count
from listening_habits
group by user_id;

-- ==================================================================================================================================
