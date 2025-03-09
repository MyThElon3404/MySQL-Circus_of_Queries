-- QUESTION : 1
-- 1. Find the email activity rank for each user. Email activity rank is defined by the total number of emails sent. The user with the highest number of emails sent will have a rank of 1, and so on. Output the user, total emails, and their activity rank. Order records by the total emails in descending order. Sort users with the same number of emails in alphabetical order.
--In your rankings, return a unique value (i.e., a unique rank) even if multiple users have the same number of emails. For tie breaker use alphabetical order of the user usernames.
DROP TABLE IF EXISTS google_gmail_emails;
CREATE TABLE google_gmail_emails (
    id INT,
    from_user VARCHAR(255),
    to_user VARCHAR(255),
    day INT
);
INSERT INTO google_gmail_emails (id, from_user, to_user, day) VALUES
(0, '6edf0be4b2267df1fa', '75d295377a46f83236', 10),
(1, '6edf0be4b2267df1fa', '32ded68d89443e808', 6),
(2, '6edf0be4b2267df1fa', '55e60cfcc9dc49c17e', 10),
(3, '6edf0be4b2267df1fa', 'e0e0defbb9ec47f6f7', 6),
(4, '6edf0be4b2267df1fa', '47be2887786891367e', 1),
(5, '6edf0be4b2267df1fa', '2813e59cf6c1ff698e', 6),
(6, '6edf0be4b2267df1fa', 'a84065b7933ad01019', 8),
(7, '6edf0be4b2267df1fa', '850badf89ed8f06854', 1),
(8, '6edf0be4b2267df1fa', '6b503743a13d778200', 1),
(9, '6edf0be4b2267df1fa', 'd63386c884aeb9f71d', 3),
(10, '6edf0be4b2267df1fa', '5b8754928306a18b68', 2),
(11, '6edf0be4b2267df1fa', '6edf0be4b2267df1fa', 8),
(12, '6edf0be4b2267df1fa', '406539987dd9b679c0', 9),
(13, '6edf0be4b2267df1fa', '114bafadff2d882864', 5),
(14, '6edf0be4b2267df1fa', '157e3e9278e32aba3e', 2),
(15, '75d295377a46f83236', '75d295377a46f83236', 6),
(16, '75d295377a46f83236', 'd63386c884aeb9f71d', 8),
(17, '75d295377a46f83236', '55e60cfcc9dc49c17e', 3),
(18, '75d295377a46f83236', '47be2887786891367e', 10),
(19, '75d295377a46f83236', '5b8754928306a18b68', 10),
(20, '75d295377a46f83236', '850badf89ed8f06854', 7),
(21, '75d295377a46f83236', '5eff3a5bfc0687351e', 2),
(22, '75d295377a46f83236', '5dc768b2f067c56f77', 8),
(23, '75d295377a46f83236', '114bafadff2d882864', 3),
(24, '75d295377a46f83236', 'e0e0defbb9ec47f6f7', 3),
(25, '75d295377a46f83236', '7cfe354d9a64bf8173', 10),
(26, '5dc768b2f067c56f77', '114bafadff2d882864', 3),
(27, '5dc768b2f067c56f77', '2813e59cf6c1ff698e', 5),
(28, '5dc768b2f067c56f77', '91f59516cb9dee1e88', 6),
(29, '5dc768b2f067c56f77', '5b8754928306a18b68', 6),
(30, '5dc768b2f067c56f77', '6b503743a13d778200', 5),
(31, '5dc768b2f067c56f77', 'aa0bd72b729fab6e9e', 10),
(32, '5dc768b2f067c56f77', '850badf89ed8f06854', 1),
(33, '5dc768b2f067c56f77', '406539987dd9b679c0', 7),
(34, '5dc768b2f067c56f77', '75d295377a46f83236', 2),
(35, '5dc768b2f067c56f77', 'd63386c884aeb9f71d', 8),
(36, '5dc768b2f067c56f77', 'ef5fe98c6b9f313075', 9),
(37, '32ded68d89443e808', '55e60cfcc9dc49c17e', 10),
(38, '32ded68d89443e808', 'e0e0defbb9ec47f6f7', 6),
(39, '32ded68d89443e808', '850badf89ed8f06854', 4),
(40, '32ded68d89443e808', '5eff3a5bfc0687351e', 8),
(41, '32ded68d89443e808', '8bba390b53976da0cd', 6),
(42, '32ded68d89443e808', '91f59516cb9dee1e88', 1),
(43, '32ded68d89443e808', '6edf0be4b2267df1fa', 7),
(44, '32ded68d89443e808', 'd63386c884aeb9f71d', 3),
(45, '32ded68d89443e808', '32ded68d89443e808', 7),
(46, '32ded68d89443e808', '5dc768b2f067c56f77', 9),
(47, '32ded68d89443e808', '406539987dd9b679c0', 3),
(48, '32ded68d89443e808', 'a84065b7933ad01019', 10),
(49, '32ded68d89443e808', '2813e59cf6c1ff698e', 9),
(50, '32ded68d89443e808', 'cbc4bd40cd1687754', 10);
-- SOLUTION :------------------------------------------------------------------------------------------------------------------------
-- Method 1: Using Window Functions
SELECT from_user AS user,
    COUNT(*) AS total_emails,
    row_number() OVER (ORDER BY COUNT(*) DESC, from_user ASC) AS activity_rank
FROM google_gmail_emails
GROUP BYfrom_user
ORDER BYtotal_emails DESC, from_user ASC;

-- Method 2: Using Common Table Expressions (CTEs)
WITH email_counts AS (
    SELECT from_user AS user,
        COUNT(*) AS total_emails
    FROM google_gmail_emails
    GROUP BY from_user
), ranked_users AS (
    SELECT user, total_emails,
        row_number() OVER (ORDER BY total_emails DESC, user ASC) AS activity_rank
    FROM email_counts
)
SELECT user, total_emails,activity_rank
FROM ranked_users
ORDER BY total_emails DESC, user ASC;
-- ==================================================================================================================================

-- QUESTION : 2
-- 2. You are given a table of product launches by company by year. Write a query to count the net difference between the number of products companies launched in 2020 with the number of products companies launched in the previous year. Output the name of the companies and a net difference of net products released for 2020 compared to the previous year.

CREATE TABLE car_launches (
    year INT,
    company_name VARCHAR(255),
    product_name VARCHAR(255)
);

INSERT INTO car_launches (year, company_name, product_name) VALUES
(2019, 'Toyota', 'Avalon'), (2019, 'Toyota', 'Camry'), (2020, 'Toyota', 'Corolla'),(2019, 'Honda', 'Accord'), 
    (2019, 'Honda', 'Passport'), (2019, 'Honda', 'CR-V'),(2020, 'Honda', 'Pilot'), (2019, 'Honda', 'Civic'),
    (2020, 'Chevrolet', 'Trailblazer'), (2020, 'Chevrolet', 'Trax'), (2019, 'Chevrolet', 'Traverse'), 
    (2020, 'Chevrolet', 'Blazer'),(2019, 'Ford', 'Figo'), (2020, 'Ford', 'Aspire'), (2019, 'Ford', 'Endeavour'), 
    (2020, 'Jeep', 'Wrangler'), (2020, 'Jeep', 'Cherokee'), (2020, 'Jeep', 'Compass'), (2019, 'Jeep', 'Renegade'), 
    (2019, 'Jeep', 'Gladiator');
-- SOLUTION :------------------------------------------------------------------------------------------------------------------------
-- Method 1: CASE method
select company_name, 
  count(case when (year = 2020) then 1  end) - count(case when (year = 2019) then 1 end ) as total_launch 
from car_launches
group by company_name;

-- Method 2: Using Common Table Expressions (CTEs)
WITH products_2019 AS (
    SELECT company,
        COUNT(*) AS num_products
    FROM product_launches
    WHERE year = 2019
    GROUP BY company
),
products_2020 AS (
    SELECT company,
        COUNT(*) AS num_products
    FROM product_launches
    WHERE year = 2020
    GROUP BY company
)
SELECT p2020.company,
    p2020.num_products - COALESCE(p2019.num_products, 0) AS net_difference
FROM products_2020 p2020
LEFT JOIN products_2019 p2019
  ON p2020.company = p2019.company
ORDER BY p2020.company;
-- ==================================================================================================================================
