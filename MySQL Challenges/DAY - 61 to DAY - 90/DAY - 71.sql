-- QUESTION : 1
-- 1. -- Best Selling Item
-- Find the best-selling item for each month (no need to separate months by year). 
-- The best-selling item is determined by the highest total sales amount, 
-- calculated as: total_paid = unitprice * quantity. Output the month, description of the item, and the total amount paid.

CREATE TABLE online_retail (
    invoiceno VARCHAR(20),
    stockcode VARCHAR(20),
    description TEXT,
    quantity INT,
    invoicedate DATE,
    unitprice DECIMAL(10, 2),
    customerid INT,
    country VARCHAR(100)
);
INSERT INTO online_retail (invoiceno, stockcode, description, quantity, invoicedate, unitprice, customerid, country) VALUES
('544586', '21890', 'S/6 WOODEN SKITTLES IN COTTON BAG', 3, '2011-02-21', 2.95, 17338, 'United Kingdom'),
('541104', '84509G', 'SET OF 4 FAIRY CAKE PLACEMATS', 3, '2011-01-13', 3.29, NULL, 'United Kingdom'),
('560772', '22499', 'WOODEN UNION JACK BUNTING', 3, '2011-07-20', 4.96, NULL, 'United Kingdom'),
('555150', '22488', 'NATURAL SLATE RECTANGLE CHALKBOARD', 5, '2011-05-31', 3.29, NULL, 'United Kingdom'),
('570521', '21625', 'VINTAGE UNION JACK APRON', 3, '2011-10-11', 6.95, 12371, 'Switzerland'),
('573511', '21871', 'SAVE THE PLANET MUG', 6, '2011-10-20', 1.95, 14688, 'United Kingdom'),
('559777', '22960', 'JAM MAKING SET PRINTED', 6, '2011-07-13', 4.25, 14911, 'United Kingdom'),
('537626', '23203', 'RIBBON REEL STRIPES DESIGN', 12, '2010-12-01', 1.65, 14196, 'United Kingdom'),
('563843', '22726', 'ALARM CLOCK BAKELIKE RED', 24, '2011-08-09', 3.75, 12921, 'United Kingdom'),
('552365', '22197', 'POPART WOODEN PENCILS ASST', 6, '2011-05-11', 1.25, 15862, 'United Kingdom'),
('574360', '22114', 'HOT WATER BOTTLE BABUSHKA', 3, '2011-10-24', 4.65, 16629, 'United Kingdom'),
('554432', '22662', 'LUNCH BOX WITH CUTLERY RETROSPOT', 3, '2011-05-25', 2.55, 12680, 'France'),
('565499', '22086', 'PAPER CHAIN KIT 50''S CHRISTMAS', 12, '2011-08-17', 2.95, 14688, 'United Kingdom'),
('575257', '22633', 'HAND WARMER SCOTTY DOG DESIGN', 12, '2011-10-27', 1.85, 17061, 'United Kingdom'),
('576628', '21166', 'COOKING SET RETROSPOT', 1, '2011-11-01', 7.65, 17450, 'United Kingdom'),
('558376', '85099B', 'JUMBO BAG RED RETROSPOT', 5, '2011-07-04', 1.65, 13079, 'United Kingdom'),
('572993', '22411', 'JUMBO SHOPPER VINTAGE RED PAISLEY', 2, '2011-10-19', 1.95, 16684, 'United Kingdom'),
('554036', '22835', '3 PIECE SPACEBOY COOKIE CUTTER SET', 12, '2011-05-24', 1.65, 16775, 'Germany'),
('543749', '23084', 'RABBIT NIGHT LIGHT', 12, '2011-02-03', 1.65, 14156, 'United Kingdom'),
('567992', '22666', 'LUNCH BAG SPACEBOY DESIGN', 8, '2011-09-07', 1.65, 16684, 'United Kingdom'),
('574379', '23199', 'SMALL HEART FLOWERS HOOK', 3, '2011-10-24', 2.95, 15157, 'United Kingdom'),
('538070', '84347', 'ROTATING SILVER ANGELS T-LIGHT HLDR', 36, '2010-12-02', 1.25, 16098, 'United Kingdom'),
('560146', '23144', 'MOODY GIRL DOOR HANGER', 48, '2011-07-18', 0.42, 17511, 'United Kingdom'),
('563978', '21984', 'PACK OF 12 RED RETROSPOT TISSUES', 24, '2011-08-09', 0.29, 15750, 'United Kingdom'),
('540569', '22909', 'SET/6 RED SPOTTY PAPER PLATES', 12, '2011-01-07', 0.85, 13448, 'United Kingdom'),
('570607', '21485', 'MULTICOLOUR SUNFLOWER CUSHION COVER', 2, '2011-10-11', 4.25, 12662, 'Belgium'),
('573610', '20966', 'SANDWICH BATH SPONGE', 4, '2011-10-20', 2.95, 16403, 'United Kingdom'),
('560027', '22960', 'JAM MAKING SET PRINTED', 1, '2011-07-15', 4.25, 14048, 'United Kingdom'),
('568296', '22666', 'LUNCH BAG SPACEBOY DESIGN', 24, '2011-09-08', 1.65, 13079, 'United Kingdom'),
('568299', '21232', 'STRAWBERRY CERAMIC TRINKET BOX', 6, '2011-09-08', 1.25, 13079, 'United Kingdom'),
('574379', '23199', 'SMALL HEART FLOWERS HOOK', 3, '2011-10-24', 2.95, 15157, 'United Kingdom');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

-- SOLUTION 1 - Using CTEs + DATEPART + FORMAT (SQL Server Style) + INNER JOIN
WITH montly_sales AS (
    SELECT 
        FORMAT(invoicedate, 'yyyy-MM') AS year_month,
        CAST(description AS NVARCHAR(MAX)) AS description,
        SUM(quantity * unitprice) AS total_amt_paid
    FROM online_retail
    GROUP BY FORMAT(invoicedate, 'yyyy-MM'), CAST(description AS NVARCHAR(MAX))
),
highest_amt AS (
    SELECT 
        year_month,
        MAX(total_amt_paid) AS max_paid
    FROM montly_sales
    GROUP BY year_month
)
SELECT 
    ms.year_month, 
    ms.description,
    ha.max_paid
FROM montly_sales ms
INNER JOIN highest_amt ha
    ON ms.year_month = ha.year_month
    AND ms.total_amt_paid = ha.max_paid;

-- SOLUTION 2 - Using ROW_NUMBER() + CTE
WITH montly_sales AS (
    SELECT 
        FORMAT(invoicedate, 'yyyy-MM') AS year_month,
        CAST(description AS NVARCHAR(MAX)) AS description,
        SUM(quantity * unitprice) AS total_amt_paid
    FROM online_retail
    GROUP BY FORMAT(invoicedate, 'yyyy-MM'), CAST(description AS NVARCHAR(MAX))
),
highest_amt AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY year_month ORDER BY total_amt_paid DESC) AS rn
    FROM montly_sales
)
SELECT 
    year_month, 
    description,
    total_amt_paid
FROM highest_amt
WHERE rn = 1;

-- ==================================================================================================================================

-- QUESTION : 2
-- 2. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================

-- QUESTION : 3
-- 3. 



-- SOLUTION :------------------------------------------------------------------------------------------------------------------------



-- ==================================================================================================================================
