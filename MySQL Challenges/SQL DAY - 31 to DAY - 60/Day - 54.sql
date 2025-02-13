-- QUESTION : 1
-- 1. In a Football tournament, some data is recorded. Every winning team gets a point and the losing team loses a point.
-- At the end of the tournament, a ranking is given to all the teams based on their total points. 
-- The total points of a team can go be negative. You are given tables: matches_record and team_details.

-- The ranking should be calculated according to the following rules:
-- The total points should be ranked from the highest to the lowest.
-- If two teams have the same total points, then the team with the higher number of winning goals would be ranked higher.

-- Task:
-- Write a query to find the rank of all the teams.

CREATE TABLE matches_record (
    match_id INT PRIMARY KEY,
    winning_team_id INT,
    losing_team_id INT,
    winning_goals INT,
    losing_goals INT
);

CREATE TABLE team_details (
    team_id INT PRIMARY KEY,
    team_name VARCHAR(255)
);

INSERT INTO team_details (team_id, team_name) VALUES
(1, 'Philippines Pirates'),
(2, 'Nickmiesters'),
(3, 'Smashers'),
(4, 'Sunrisers');

INSERT INTO matches_record (match_id, winning_team_id, losing_team_id, winning_goals, losing_goals) VALUES
(1, 1, 2, 3, 1),
(2, 3, 4, 2, 0),
(3, 1, 4, 4, 2),
(4, 2, 3, 2, 1),
(5, 1, 3, 1, 0);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

WITH team_points AS (
    SELECT winning_team_id AS team_id, COUNT(*) AS wins, SUM(winning_goals) AS total_winning_goals, COUNT(*) AS points
    FROM matches_record
    GROUP BY winning_team_id
    UNION ALL
    SELECT losing_team_id AS team_id, 0 AS wins, 0 AS total_winning_goals, -COUNT(*) AS points
    FROM matches_record
    GROUP BY losing_team_id
), 
aggregated_points AS (
    SELECT team_id, SUM(points) AS total_points, SUM(total_winning_goals) AS total_goals
    FROM team_points
    GROUP BY team_id
)
SELECT RANK() OVER (ORDER BY total_points DESC, total_goals DESC) AS rank, td.team_name
FROM aggregated_points ap
JOIN team_details td ON ap.team_id = td.team_id
ORDER BY rank;

----------------------------------------------- OR -----------------------------------------------

SELECT 
    RANK() OVER (ORDER BY total_points DESC, total_winning_goals DESC) AS rank, 
    td.team_name
FROM (
    -- Aggregating total points and total winning goals for each team
    SELECT 
        team_id, 
        SUM(points) AS total_points, 
        SUM(winning_goals) AS total_winning_goals
    FROM (
        -- Assigning points to winning and losing teams
        SELECT 
            winning_team_id AS team_id, 
            1 AS points, 
            winning_goals
        FROM matches_record
        UNION ALL
        SELECT 
            losing_team_id AS team_id, 
            -1 AS points, 
            0 AS winning_goals 
        FROM matches_record
    ) AS team_stats
    GROUP BY team_id
) AS aggregated_stats
JOIN team_details td ON aggregated_stats.team_id = td.team_id
ORDER BY rank;


-- ==================================================================================================================================

-- QUESTION : 2
-- 2. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================
