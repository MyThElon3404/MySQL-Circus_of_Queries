-- QUESTION : 1
-- 1. You have a table called "website_traffic" with columns "date", "page_views", and "unique_visitors". 
-- Write a query to find the days where the page views increased by more than 20% compared to the previous day, 
-- and the unique visitors also increased by more than 15% compared to the previous day.

drop table if exists website_traffic;
CREATE TABLE website_traffic (
    date DATE,
    page_views INT,
    unique_visitors INT
);

-- Insert 30 rows of modified sample data
INSERT INTO website_traffic (date, page_views, unique_visitors) VALUES
('2024-10-01', 100, 80),
('2024-10-02', 125, 95),  -- 25% increase in page_views, 18.75% in unique_visitors
('2024-10-03', 110, 88),
('2024-10-04', 130, 95),
('2024-10-05', 160, 110), -- 23.1% increase in page_views, 15.8% in unique_visitors
('2024-10-06', 140, 100),
('2024-10-07', 175, 120), -- 25% increase in page_views, 20% in unique_visitors
('2024-10-08', 150, 105),
('2024-10-09', 180, 125), -- 20% increase in page_views, 19% in unique_visitors
('2024-10-10', 200, 140), -- 11.1% increase in page_views, 12% increase in unique_visitors (not meeting conditions)
('2024-10-11', 250, 170), -- 25% increase in page_views, 21.4% in unique_visitors
('2024-10-12', 205, 135);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

WITH website_traffic_cte AS (
    SELECT date,
        page_views AS curr_pv,
        LAG(page_views) OVER w AS prev_pv,
        unique_visitors AS curr_uv,
        LAG(unique_visitors) OVER w AS prev_uv
    FROM website_traffic
    WINDOW w AS (ORDER BY date ASC)
)
SELECT date
FROM website_traffic_cte
WHERE prev_pv IS NOT NULL
    AND prev_uv IS NOT NULL
	  AND curr_pv > 1.2 * prev_pv
	  AND curr_uv > 1.15 * prev_uv;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. Write a SQL query to retrieve the managers who oversee at least five employees within the same department, along with the department name and the total number of direct reports, 
-- but only if the department has more than ten employees in total.

CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    managerId INT
);

INSERT INTO Employee (id, name, department, managerId) 
	VALUES 
(1, 'John', 'HR', NULL),
(2, 'Bob', 'HR', 1),
(3, 'Olivia', 'HR', 1),
(4, 'Emma', 'Finance', NULL),
(5, 'Sophia', 'HR', 1),
(6, 'Mason', 'Finance', 4),
(7, 'Ethan', 'HR', 1),
(8, 'Ava', 'HR', 1),
(9, 'Lucas', 'HR', 1),
(10, 'Isabella', 'Finance', 4),
(11, 'Harper', 'Finance', 4),
(12, 'Hemla', 'HR', 3),
(13, 'Aisha', 'HR', 2),
(14, 'Himani', 'HR', 2),
(15, 'Lily', 'HR', 2);

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================
