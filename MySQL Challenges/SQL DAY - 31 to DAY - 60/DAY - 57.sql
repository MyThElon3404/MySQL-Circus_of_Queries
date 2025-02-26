-- QUESTION : 1
-- 1. write sql query to find busiest route along with total ticket count
-- oneway_round = 'O' -> One way trip
-- oneway_round = 'R' -> Return trip
-- NOTE: DEL -> BOM and BOM -> DEL diff route type

CREATE TABLE tickets (
    airline_number VARCHAR(10),
    origin VARCHAR(3),
    destination VARCHAR(3),
    oneway_round CHAR(1),
    ticket_count INT
);

INSERT INTO tickets (airline_number, origin, destination, oneway_round, ticket_count)
VALUES
    ('DEF456', 'BOM', 'DEL', 'O', 150),
    ('GHI789', 'DEL', 'BOM', 'R', 50),
    ('JKL012', 'BOM', 'DEL', 'R', 75),
    ('MNO345', 'DEL', 'NYC', 'O', 200),
    ('PQR678', 'NYC', 'DEL', 'O', 180),
    ('STU901', 'NYC', 'DEL', 'R', 60),
    ('ABC123', 'DEL', 'BOM', 'O', 100),
    ('VWX234', 'DEL', 'NYC', 'R', 90);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1: Using CTE and UNION ALL
with route_cte as (
	select origin, destination, oneway_round, ticket_count
	from tickets
	UNION ALL
	select destination, origin, oneway_round, ticket_count
	from tickets
	where oneway_round = 'R'
)
select TOP 1
	origin, destination,
	sum(ticket_count) as tc
from route_cte
group by origin, destination
order by tc desc;

-- SOLUTION 2: Using sub-query
SELECT TOP 1 
    origin, destination, 
    SUM(ticket_count) AS tc
FROM (
    SELECT origin, destination, oneway_round, ticket_count 
    FROM tickets
    UNION ALL
    SELECT destination, origin, oneway_round, ticket_count 
    FROM tickets 
    WHERE oneway_round = 'R'
) AS route_cte
GROUP BY origin, destination
ORDER BY tc DESC;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================
