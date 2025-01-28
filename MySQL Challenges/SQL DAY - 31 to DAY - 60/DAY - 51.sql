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
-- 2. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================
