-- BANK LOAN DATA ANALYSIS - 
-- "In order to monitor and assess our bank's lending activities and performance, we need to create a comprehensive Bank Loan Report. 
-- This report aims to provide insights into key loan-related metrics and their changes over time. The report will help us make 
-- data-driven decisions, track our loan portfolio's health, and identify trends that can inform our lending strategies.

-- Import file to SSMS (Flat File) - SQL Server Management Studio

-- =================================================================================================================================

-- Basic Key Performance Indicators (KPIs)

-- =================================================================================================================================

-- Query - Total Loan Applications
select count(id) as total_loan_application 
from bank_loan_data; -- 38576

-- Query - Month wise Applications
select MONTH(issue_date) as Month,
	count(id) as total_loan_application
from bank_loan_data
group by MONTH(issue_date)
order by Month asc;

--  if years are more than one then use below query
select Year(issue_date)as year,
	MONTH(issue_date) as Month,
	count(id) as total_loan_application
from bank_loan_data
group by Year(issue_date), MONTH(issue_date)
order by Year asc, Month asc;

-- Query - Month-over-Month (MoM) Total Loan Applications


-- ---------------------------------------------------------------------------------------------------------------------------------

-- Query - Total Funded Amount (Total loaned Amount)
select sum(loan_amount) as total_funded_amount
from bank_loan_data;

-- Query - Month wise Total Funded Amount (Total loaned Amount)
select MONTH(issue_date) as Month,
	sum(loan_amount) as total_funded_amount
from bank_loan_data
group by MONTH(issue_date)
order by Month asc;

--  if years are more than one then use below query
select YEAR(issue_date) as Year,
	MONTH(issue_date) as Month,
	sum(loan_amount) as total_funded_amount
from bank_loan_data
group by YEAR(issue_date), MONTH(issue_date)
order by Year asc, Month asc;

-- ---------------------------------------------------------------------------------------------------------------------------------

-- Query - Total Amount Received
select sum(total_payment) as total_amount_received
from bank_loan_data;

-- Query - Month Wise Total Amount Received
select MONTH(issue_date) as Month,
	sum(total_payment) as total_amount_received
from bank_loan_data
group by MONTH(issue_date)
order by Month asc;

--  if years are more than one then use below query
select YEAR(issue_date) as Year,
	MONTH(issue_date) as Month,
	sum(total_payment) as total_funded_amount
from bank_loan_data
group by YEAR(issue_date), MONTH(issue_date)
order by Year asc, Month asc;

-- ---------------------------------------------------------------------------------------------------------------------------------

-- Query - Average Interest Rate
select CONCAT(ROUND(avg(int_rate)*100, 2), ' ', '%') as avg_int_rate
from bank_loan_data;

-- Query - Month Wise Average Interest Rate
select MONTH(issue_date) as Month,
	CONCAT(ROUND(avg(int_rate)*100, 2), ' ', '%') as avg_int_rate
from bank_loan_data
group by MONTH(issue_date)
order by Month asc;

--  if years are more than one then use below query
select YEAR(issue_date) as Year,
	MONTH(issue_date) as Month,
	CONCAT(ROUND(avg(int_rate)*100, 2), ' ', '%') as avg_int_rate
from bank_loan_data
group by YEAR(issue_date), MONTH(issue_date)
order by Year asc, Month asc;

-- ---------------------------------------------------------------------------------------------------------------------------------

-- Query - Monthly Trends by Issue Date
select DATEPART(MONTH, issue_date) as month_number,
	DATENAME(MONTH, issue_date) as month_name,
	COUNT(id) as total_applications,
	SUM(loan_amount) as total_funded_amount,
	SUM(total_payment) as total_received_amount
from bank_loan_data
group by DATEPART(MONTH, issue_date), DATENAME(MONTH, issue_date)
order by month_number;

-- Query - Regional Analysis by State
select address_state,
	COUNT(id) as total_applications,
	SUM(loan_amount) as total_funded_amount,
	SUM(total_payment) as total_received_amount
from bank_loan_data
group by address_state
order by SUM(loan_amount) desc;

-- Query - Loan Term Analysis
select term,
	COUNT(id) as total_applications,
	SUM(loan_amount) as total_funded_amount,
	SUM(total_payment) as total_received_amount
from bank_loan_data
group by term
order by term;

-- Query - Employee Length Analysis
select emp_length,
	COUNT(id) as total_applications,
	SUM(loan_amount) as total_funded_amount,
	SUM(total_payment) as total_received_amount
from bank_loan_data
group by emp_length
order by emp_length;

-- Query - Loan Purpose Breakdown
select purpose,
	COUNT(id) as total_applications,
	SUM(loan_amount) as total_funded_amount,
	SUM(total_payment) as total_received_amount
from bank_loan_data
group by purpose
order by purpose;

-- Query - Home Ownership Analysis
select home_ownership,
	COUNT(id) as total_applications,
	SUM(loan_amount) as total_funded_amount,
	SUM(total_payment) as total_received_amount
from bank_loan_data
group by home_ownership
order by total_applications desc;

-- ---------------------------------------------------------------------------------------------------------------------------------

-- =================================================================================================================================

-- Month-over-Month (MoM) Return Query (Sample Query)
SELECT 
    FORMAT(SaleDate, 'yyyy-MM') AS Month,
    SUM(Amount) AS TotalSales,
    LAG(SUM(Amount)) OVER (ORDER BY FORMAT(SaleDate, 'yyyy-MM')) AS PreviousMonthSales,
    (CAST(SUM(Amount) AS DECIMAL(10, 2)) - CAST(LAG(SUM(Amount)) OVER (ORDER BY FORMAT(SaleDate, 'yyyy-MM')) AS DECIMAL(10, 2))) /
    CAST(LAG(SUM(Amount)) OVER (ORDER BY FORMAT(SaleDate, 'yyyy-MM')) AS DECIMAL(10, 2)) * 100 AS MoMReturn
FROM Sales
GROUP BY FORMAT(SaleDate, 'yyyy-MM')
ORDER BY Month;

-- Using Common Table Expressions (CTEs)
WITH MonthlySales AS (
    SELECT FORMAT(SaleDate, 'yyyy-MM') AS Month,
        SUM(Amount) AS TotalSales
    FROM Sales
    GROUP BY FORMAT(SaleDate, 'yyyy-MM')
), MoM_Calculation AS (
    SELECT Month, TotalSales,
        LAG(TotalSales) OVER (ORDER BY Month) AS PreviousMonthSales
    FROM MonthlySales
)
SELECT Month, TotalSales, PreviousMonthSales,
    CASE 
        WHEN PreviousMonthSales IS NULL THEN NULL
        ELSE (TotalSales - PreviousMonthSales) / PreviousMonthSales * 100 
    END AS MoMReturn
FROM MoM_Calculation
ORDER BY Month;

-- ---------------------------------------------------------------------------------------------------------------------------------

-- Year-over-Year (YoY) Return Query (Sample Query)
SELECT 
    FORMAT(SaleDate, 'yyyy-MM') AS Month,
    SUM(Amount) AS TotalSales,
    LAG(SUM(Amount)) OVER (PARTITION BY FORMAT(SaleDate, 'MM') ORDER BY FORMAT(SaleDate, 'yyyy-MM')) AS PreviousYearSales,
    (CAST(SUM(Amount) AS DECIMAL(10, 2)) - CAST(LAG(SUM(Amount)) OVER (PARTITION BY FORMAT(SaleDate, 'MM') ORDER BY FORMAT(SaleDate, 'yyyy-MM')) AS DECIMAL(10, 2))) /
    CAST(LAG(SUM(Amount)) OVER (PARTITION BY FORMAT(SaleDate, 'MM') ORDER BY FORMAT(SaleDate, 'yyyy-MM')) AS DECIMAL(10, 2)) * 100 AS YoYReturn
FROM Sales
GROUP BY FORMAT(SaleDate, 'yyyy-MM')
ORDER BY Month;

-- Using Common Table Expressions (CTEs)
WITH MonthlySales AS (
    SELECT FORMAT(SaleDate, 'yyyy-MM') AS Month,
        SUM(Amount) AS TotalSales
    FROM Sales
    GROUP BY FORMAT(SaleDate, 'yyyy-MM')
), YoY_Calculation AS (
    SELECT Month, TotalSales,
        LAG(TotalSales, 12) OVER (ORDER BY Month) AS PreviousYearSales
    FROM MonthlySales
)
SELECT Month, TotalSales, PreviousYearSales,
    CASE 
        WHEN PreviousYearSales IS NULL THEN NULL
        ELSE (TotalSales - PreviousYearSales) / PreviousYearSales * 100 
    END AS YoYReturn
FROM YoY_Calculation
ORDER BY Month;

-- =================================================================================================================================

-- Good Loan and Bad Loan Key Performance Indicators (KPIs)

-- =================================================================================================================================

-- Query - Good Loan Application Percentage
select (
	count(
	case when loan_status='Fully Paid' 
		or loan_status='Current' then id
	end) * 100 /
	count(id)
) as good_loan_apps_percentage
from bank_loan_data;

-- Query - Total Good Loan Application Count
select count(id) as total_GL_apps
from bank_loan_data
where loan_status='Fully Paid'
	or loan_status='Current';

-- Query - Good Loan Receivec Amount
select sum(total_payment) as GL_received_amount
from bank_loan_data
where loan_status='Fully Paid'
	or loan_status='Current';
-- ---------------------------------------------------------------------------------------------------------------------------------

-- Query - Bad Loan Application Percentage
select (
	count(
	case when loan_status='Charged Off' then id
	end) * 100 /
	count(id)
) as good_loan_apps_percentage
from bank_loan_data;

-- Query - Total Bad Loan Application Count
select count(id) as total_GL_apps
from bank_loan_data
where loan_status='Charged Off';

-- Query - Bad Loan Receivec Amount
select sum(total_payment) as GL_received_amount
from bank_loan_data
where loan_status='Charged Off';

-- =================================================================================================================================

-- All summary by Loan Status

-- =================================================================================================================================

select loan_status,
	count(id) as total_loan_applications,
	sum(total_payment) as total_amount_received,
	sum(loan_amount) as total_funded_amount,
	ROUND(AVG(int_rate * 100), 2) as interest_rate,
	ROUND(AVG(dti * 100), 2) as IDT
from bank_loan_data
group by loan_status;

-- ---------------------------------------------------------------------------------------------------------------------------------
