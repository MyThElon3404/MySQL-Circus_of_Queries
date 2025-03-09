-- QUESTION : 1
-- 1. Since some IDs have been removed from Logs. 
-- Write an SQL query to find the start and end number of continuous ranges in table Logs.
-- Order the result table by start_id.

CREATE TABLE Logs (
    log_id INT PRIMARY KEY
);
INSERT INTO Logs (log_id) 
VALUES 
(1), (2), (3), (7), (8), (10);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

with cte as (
  select log_id,
  log_id - row_number() over(order by log_id) as rn
  from Logs
)
select min(log_id) as start_num,
  max(log_id) as end_num
from cte
group by rn;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Write an SQL query that reports for each player and date, how many games played so far by the player. 
-- That is, the total number of games played by the player until that date. Check the example for clarity.

-- For the player with id 1, 5 + 6 = 11 games played by 2016-05-02, and 5 + 6 + 1 = 12 games played by 2017-06-25.
-- For the player with id 3, 0 + 5 = 5 games played by 2018-07-03.
-- Note that for each player we only care about the days when the player logged in.

DROP TABLE IF EXISTS Activity;
CREATE TABLE Activity (
    player_id INT,
    device_id INT,
    event_date DATE,
    games_played INT,
    PRIMARY KEY (player_id, event_date)
);

INSERT INTO Activity (player_id, device_id, event_date, games_played) 
VALUES
(1, 2, '2016-03-01', 5),
(1, 2, '2016-05-02', 6),
(1, 3, '2017-06-25', 1),
(3, 1, '2016-03-02', 0),
(3, 4, '2018-07-03', 5);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

SELECT 
    player_id, 
    event_date, 
    SUM(games_played) OVER (
        PARTITION BY player_id 
        ORDER BY event_date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS total_games_played
FROM Activity
ORDER BY player_id, event_date;

---------------------------------------------------- OR ---------------------------------------------------

SELECT 
    a1.player_id, 
    a1.event_date, 
    SUM(a2.games_played) AS total_games_played
FROM Activity a1
JOIN Activity a2 
    ON a1.player_id = a2.player_id 
    AND a2.event_date <= a1.event_date
GROUP BY a1.player_id, a1.event_date
ORDER BY a1.player_id, a1.event_date;

-- ==================================================================================================================================
