-- List of MySQL date and time functions commonly used for dealing with real-time data, along with examples and potential real-time use cases:

-- 1. CURRENT_DATE() / GETDATE()
MySQL: SELECT CURRENT_DATE();
SQL Server: SELECT GETDATE();

-- 2. DATE() / CAST(GETDATE() AS DATE)
MySQL: SELECT DATE(NOW());
SQL Server: SELECT CAST(GETDATE() AS DATE);

-- 3. DATE_ADD() / DATEADD()
MySQL: SELECT DATE_ADD(NOW(), INTERVAL 7 DAY);
SQL Server: SELECT DATEADD(DAY, 7, GETDATE());

-- 4. DATE_SUB() / DATEADD()
MySQL: SELECT DATE_SUB(NOW(), INTERVAL 7 DAY);
SQL Server: SELECT DATEADD(DAY, -7, GETDATE());

-- 5. DATEDIFF()
MySQL: SELECT DATEDIFF('2024-07-10', '2024-07-01');
SQL Server: SELECT DATEDIFF(DAY, '2024-07-01', '2024-07-10');

-- 6. DATE_FORMAT() / FORMAT()
MySQL: SELECT DATE_FORMAT(NOW(), '%Y-%m-%d');
SQL Server: SELECT FORMAT(GETDATE(), 'yyyy-MM-dd');

-- 7. DAY() / DAY()
MySQL: SELECT DAY(NOW());
SQL Server: SELECT DAY(GETDATE())

-- 8. MONTH() / MONTH()
MySQL: SELECT MONTH(NOW());
SQL Server: SELECT MONTH(GETDATE());

-- 9. YEAR() / YEAR()
MySQL: SELECT YEAR(NOW());
SQL Server: SELECT YEAR(GETDATE());

-- 10. TIME() / CAST(GETDATE() AS TIME)
MySQL: SELECT TIME(NOW());
SQL Server: SELECT CAST(GETDATE() AS TIME);

-- 11. HOUR() / DATEPART(HOUR, ...)
MySQL: SELECT HOUR(NOW());
SQL Server: SELECT DATEPART(HOUR, GETDATE());

-- 12. MINUTE() / DATEPART(MINUTE, ...)
MySQL: SELECT MINUTE(NOW());
SQL Server: SELECT DATEPART(MINUTE, GETDATE());

-- 13. SECOND() / DATEPART(SECOND, ...)
MySQL: SELECT SECOND(NOW());
SQL Server: SELECT DATEPART(SECOND, GETDATE());


