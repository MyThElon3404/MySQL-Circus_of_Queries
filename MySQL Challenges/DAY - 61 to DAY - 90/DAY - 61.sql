-- QUESTION : 1
-- 1. Write a query to find the top 5 artists whose songs appear most frequently in the Top 10 of the global_song_rank table. 
-- Display the top 5 artist names in ascending order, along with their song appearance ranking.

CREATE TABLE artists (
    artist_id INTEGER PRIMARY KEY,
    artist_name VARCHAR(255),
    label_owner VARCHAR(255)
);
CREATE TABLE songs (
    song_id INTEGER PRIMARY KEY,
    artist_id INTEGER,
    name VARCHAR(255),
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id)
);
CREATE TABLE global_song_rank (
    day INTEGER CHECK (day BETWEEN 1 AND 52),
    song_id INTEGER,
    rank INTEGER CHECK (rank BETWEEN 1 AND 1000000),
    FOREIGN KEY (song_id) REFERENCES songs(song_id)
);

INSERT INTO artists (artist_id, artist_name, label_owner) 
	VALUES
(101, 'Ed Sheeran', 'Warner Music Group'),
(120, 'Drake', 'Warner Music Group'),
(125, 'Bad Bunny', 'Rimas Entertainment'),
(130, 'Taylor Swift', 'Republic Records'),
(140, 'Ariana Grande', 'Republic Records'),
(150, 'The Weeknd', 'XO/Republic'),
(160, 'Billie Eilish', 'Interscope Records'),
(170, 'Post Malone', 'Republic Records'),
(180, 'Dua Lipa', 'Warner Music Group');

INSERT INTO songs (song_id, artist_id, name) 
	VALUES
(55511, 101, 'Perfect'),
(45202, 101, 'Shape of You'),
(22222, 120, 'One Dance'),
(19960, 120, 'Hotline Bling'),
(33333, 125, 'Dakiti'),
(44444, 130, 'Lover'),
(66666, 140, '7 rings'),
(77777, 150, 'Blinding Lights'),
(88888, 160, 'Bad Guy');

INSERT INTO global_song_rank (day, song_id, rank) 
	VALUES
(1, 45202, 5),
(3, 45202, 2),
(1, 19960, 3),
(9, 19960, 15),
(5, 55511, 9),
(7, 55511, 7),
(10, 33333, 8),
(15, 77777, 4),
(20, 88888, 6);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1 - Using CTE & DENSE_RANK function
WITH artist_songs_apperance_cte AS (
    SELECT 
        a.artist_id, 
        a.artist_name,
        COUNT(*) AS top_10_cnt  -- Count number of times an artist's songs appear in the Top 10
    FROM global_song_rank gs
    JOIN songs s ON gs.song_id = s.song_id
    JOIN artists a ON s.artist_id = a.artist_id
    WHERE gs.rank <= 10
    GROUP BY a.artist_id, a.artist_name  -- Group by artist_id and artist_name to count appearances
),
ranked_artist_cte AS (
    SELECT 
        artist_id, 
        artist_name,
        DENSE_RANK() OVER (ORDER BY top_10_cnt DESC) AS ranking  -- Rank artists by highest count first
    FROM artist_songs_apperance_cte
)
SELECT artist_name, ranking
FROM ranked_artist_cte
WHERE ranking <= 5  -- Get only the top 5 ranked artists
ORDER BY ranking, artist_name;  -- Order by ranking first, then alphabetically by artist_name

-- SOLUTION 2 - Using sub-query
SELECT artist_name, ranking
FROM (
    SELECT 
        a.artist_name,
        COUNT(1) AS top_10_appearances,
        DENSE_RANK() OVER (ORDER BY COUNT(1) DESC) AS ranking
    FROM global_song_rank gs
    JOIN songs s ON gs.song_id = s.song_id
    JOIN artists a ON s.artist_id = a.artist_id
    WHERE gs.rank <= 10  -- Filter only relevant rows early for efficiency
    GROUP BY a.artist_id, a.artist_name  -- Group by artist to count appearances
) ranked_artists
WHERE ranking <= 5  -- Only fetch the top 5 ranked artists
ORDER BY ranking, artist_name;  -- Sort the final results by rank, then artist name

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Write a SQL query to find duplicate values from the table

CREATE TABLE EmployeeData (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);

INSERT INTO EmployeeData (EmpID, EmpName, Department, Salary) 
	VALUES
(1, 'John', 'HR', 50000),
(2, 'Alice', 'IT', 70000),
(3, 'Bob', 'Finance', 60000),
(4, 'John', 'HR', 50000),
(5, 'Emma', 'IT', 75000),
(6, 'David', 'HR', 52000),
(7, 'Alice', 'IT', 70000),
(8, 'Sophia', 'Finance', 62000),
(9, 'Bob', 'Finance', 60000),
(10, 'Liam', 'IT', 68000),
(11, 'Olivia', 'HR', 55000),
(12, 'Emma', 'IT', 75000);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1 - Using GROUP BY with HAVING
SELECT EmpName, Department, COUNT(*) AS DuplicateCount
FROM EmployeeData
GROUP BY EmpName, Department
HAVING COUNT(*) > 1;

-- SOLUTION 2 - Using ROW_NUMBER()
WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY EmpName, Department ORDER BY EmpID) AS RowNum
    FROM EmployeeData
)
SELECT * FROM CTE WHERE RowNum > 1;

-- SOLUTION 3 - Using EXISTS
SELECT * FROM EmployeeData E1
WHERE EXISTS (
    SELECT 1 FROM EmployeeData E2
    WHERE E1.EmpName = E2.EmpName
    AND E1.Department = E2.Department
    AND E1.EmpID <> E2.EmpID
);

-- SOLUTION 4 - Using DISTINCT and JOIN
SELECT DISTINCT E1.*
FROM EmployeeData E1
JOIN EmployeeData E2
ON E1.EmpName = E2.EmpName
AND E1.Department = E2.Department
AND E1.EmpID <> E2.EmpID;

-- ==================================================================================================================================

-- QUESTION : 3
-- 3. Write an SQL query to find all active businesses.
-- An active business is a business that has more than one event type with occurences greater than the average occurences of that event type among all businesses.

CREATE TABLE Events (
    business_id INT,
    event_type VARCHAR(50),
    occurences INT
);

INSERT INTO Events (business_id, event_type, occurences) 
	VALUES
(1, 'reviews', 7),
(3, 'reviews', 3),
(1, 'ads', 11),
(2, 'ads', 7),
(3, 'ads', 6),
(1, 'page views', 3),
(2, 'page views', 12);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1 - Using CTE, Group BY, Having
WITH AvgOccurrences AS (
    -- Calculate the average occurrences for each event type
    SELECT event_type, AVG(occurences) AS avg_occurences
    FROM Events
    GROUP BY event_type
),
FilteredEvents AS (
    -- Find businesses where an event type's occurrences exceed its average
    SELECT E.business_id, E.event_type
    FROM Events E
    JOIN AvgOccurrences A 
    ON E.event_type = A.event_type
    WHERE E.occurences > A.avg_occurences
)
-- Find businesses that have more than one qualifying event type
SELECT business_id
FROM FilteredEvents
GROUP BY business_id
HAVING COUNT(DISTINCT event_type) > 1;

-- SOLUTION 2 - Using JOIN with a Derived Table
select e.business_id
from events e
join (
	select event_type,
		avg(occurences) as avg_occurences
	from events
	group by event_type
) av
on e.event_type = av.event_type
	and e.occurences > av.avg_occurences
group by e.business_id
having count(distinct e.event_type) > 1;

-- ==================================================================================================================================
