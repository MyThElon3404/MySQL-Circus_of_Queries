-- QUESTION : 1
-- 1. Write an SQL query that reports the fraction of players that logged in again 
-- on the day after the day they first logged in, rounded to 2 decimal places. 
-- In other words, you need to count the number of players that logged in for at least two consecutive 
-- days starting from their first login date, then divide that number by the total number of players.

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

WITH cte AS (
    SELECT 
        player_id,
        MIN(event_date) OVER (PARTITION BY player_id) AS min_event_date,
        CASE 
            WHEN event_date = DATEADD(DAY, 1, MIN(event_date) OVER (PARTITION BY player_id)) THEN 1 
            ELSE 0 
        END AS sum_cnt
    FROM Activity
)

SELECT ROUND(SUM(sum_cnt) / COUNT(DISTINCT player_id), 2) AS fraction 
FROM cte;

-------------------------------------------------- OR ----------------------------------------------------

SELECT 
    ROUND(
        CAST(COUNT(DISTINCT a1.player_id) AS FLOAT) / COUNT(DISTINCT a2.player_id), 2
    ) AS fraction
FROM Activity a1
JOIN Activity a2 
    ON a1.player_id = a2.player_id 
    AND a1.event_date = DATEADD(DAY, 1, a2.event_date);


-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Write a sql query to identify the question which has the highest answer rate.

DROP TABLE IF EXISTS survey_log;
CREATE TABLE survey_log (
    id INT,
    action VARCHAR(10),
    question_id INT,
    answer_id INT,
    q_num INT,
    timestamp INT
);
INSERT INTO survey_log (id, action, question_id, answer_id, q_num, timestamp) 
VALUES 
(5, 'show', 285, NULL, 1, 123),
(5, 'answer', 285, 124124, 1, 124),
(5, 'show', 369, NULL, 2, 125),
(5, 'skip', 369, NULL, 2, 126),
(6, 'show', 285, NULL, 1, 130),
(6, 'answer', 285, 124125, 1, 131),
(6, 'answer', 369, 124126, 2, 132);


-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

WITH action_counts AS (
    SELECT 
        question_id,
        COUNT(CASE WHEN action = 'answer' THEN 1 END) AS answer_count,
        COUNT(*) AS total_count
    FROM survey_log
    GROUP BY question_id
)

SELECT 
    question_id, 
    answer_count * 1.0 / total_count AS answer_rate
FROM action_counts
ORDER BY answer_rate DESC
LIMIT 1;

-------------------------------------------------- OR ----------------------------------------------------

select a.question_id as survey_log
from (
  select t1.question_id,
    rank() over(order by rate desc) as rk
  from t1
) a
where a.rk = 1

-- ==================================================================================================================================
