# Credit Card Transaction Analysis of Indian Customer

- Dataset for this case study download from here - [Dataset](https://www.kaggle.com/datasets/thedevastator/analyzing-credit-card-spending-habits-in-india)

## Dataset Schema information - 
- city(String) - City name where transaction took place
- date(Date) - Transaction date
- card_type(String) - Type of card used for transaction
- exp_type(String) - Type of expence associated with transaction
- gender(String) - Gender of card holder
- amount(number) - Amount of transaction

----------------------------------------------------------------------------------------------------------------------------

## EDA of Transaction data
<details>
	<summary>✅check null values per column</summary>
	
```sql
select
	sum(case when "index" is null then 1 else 0 end) as index_null_cnt,
	sum(case when City is null then 1 else 0 end) as city_null_cnt,
	sum(case when "Date" is null then 1 else 0 end) as date_null_cnt,
	sum(case when Card_Type is null then 1 else 0 end) as card_type_null_cnt,
	sum(case when Exp_Type is null then 1 else 0 end) as exp_type_null_cnt,
	sum(case when Gender is null then 1 else 0 end) as gender_null_cnt,
	sum(case when Amount is null then 1 else 0 end) as amount_null_cnt
from cct;
```
</details>
<details>
	<summary>✅first transaction date in dataset</summary>
	
```sql
select TOP 1 "Date"
from cct
order by "Date" asc;
```
</details>
<details>
	<summary>✅last transaction date in dataset</summary>
	
```sql
select TOP 1 "Date"
from cct
order by "Date" desc;
```
</details>
<details>
	<summary>✅total number of records in the dataset</summary>
	
```sql
select count(*) as total_records
from cct;
```
</details>
<details>
	<summary>✅order the cities accordingly to usage of credit cards</summary>
	
```sql
select City, count(1) as card_used_frequecy
from cct
group by City
order by 2 desc;
```
</details>
<details>
	<summary>✅different card_type used by female and male</summary>
	
```sql
select Card_Type, Gender,
	count(1) as card_usage_freq
from cct
group by Card_Type, Gender
order by card_usage_freq desc;
```
</details>
<details>
	<summary>✅total spend of each card type by gender like male and female</summary>
	
```sql
select Card_Type, Gender,
	sum(Amount) as total_amount_spend
from cct
group by Card_Type, Gender
order by total_amount_spend desc;
```
</details>
<details>
	<summary>✅card usage by different expence type by gender like male and female</summary>
	
```sql
select Card_Type, Exp_Type,
	count(1) as total_amount_spend
from cct
group by Card_Type, Exp_Type
order by total_amount_spend desc;
```
</details>
<details>
	<summary>✅total spend of expence type by gender like male and female</summary>
	
```sql
select Card_Type, Exp_Type,
	sum(Amount) as total_amount_spend
from cct
group by Card_Type, Exp_Type
order by total_amount_spend desc;
```
</details>

------------------------------------------------------------------------------------------------------------------------

## Question & Answer for case study

- #### Q1. write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends
<details>
	<summary> Click Here for Answer </summary>
	
```sql
with total_spent_cte as (
	select sum(Amount) as total_amount_spend
	from cct
), top_5_highest_spend_cities as (
	select TOP 5 City,
		sum(Amount) as spent_amount
	from cct
	group by City
	order by spent_amount desc
)
select tc.City, tc.spent_amount,
	ts.total_amount_spend,
	ROUND((100.0*tc.spent_amount) / ts.total_amount_spend, 2) as contribute_perc
from top_5_highest_spend_cities as tc
join total_spent_cte as ts
	on 1=1;
```
</details>


- #### Q2. write a query to print highest spend month and amount spent in that month for each card type
<details>
	<summary> Click Here for Answer </summary>
	
```sql
select TOP 1 Card_Type, 
	DATEPART(YEAR, "Date") as date_year,
	DATENAME(MONTH, "Date") as date_month,
	sum(Amount) as amount_spend
from cct
group by Card_Type, DATEPART(YEAR, "Date"), DATENAME(MONTH, "Date")
order by amount_spend desc;
```
</details>


- #### Q3. write a query to print the transaction details(all columns from the table) for each card type. when it reaches a cumulative of 10,00,000 total spends(We should have 4 rows in the o/p one for each card type)
<details>
	<summary> Click Here for Answer </summary>
	
```sql
-- SOLUTION 1 : 
with cumulative_sum_cte as (
	select *,
		SUM(Amount) over(partition by Card_Type order by "Date", Amount) as cumulative_sum
	from cct
), rank_cs_cte as (
	select *,
		DENSE_RANK() over(partition by Card_Type order by cumulative_sum) as drnk
	from cumulative_sum_cte
	where cumulative_sum >= 1000000
)
select *
from rank_cs_cte
where drnk = 1;

-- SOLUTION 2:
WITH cumulative_sum_cte AS (
    SELECT Card_Type, Date, Amount,
        SUM(Amount) OVER (PARTITION BY Card_Type ORDER BY "Date", Amount) AS cumulative_sum
    FROM cct
), threshold_cte AS (
    SELECT Card_Type, Date, Amount, cumulative_sum,
        LAG(cumulative_sum, 1, 0) OVER (PARTITION BY Card_Type ORDER BY "Date", Amount) AS prev_cumulative_sum
    FROM cumulative_sum_cte
)
SELECT Card_Type, Date, Amount,cumulative_sum
FROM threshold_cte
WHERE cumulative_sum >= 1000000 
	AND prev_cumulative_sum < 1000000;
```
</details>


- #### Q4. write a query to find city which had lowest percentage spend for gold card type
<details>
	<summary> Click Here for Answer </summary>
	
```sql
-- SOLUTION 1:
with gold_ts_cte as (
	select City,
		SUM(Amount) as citywise_total_gold_spend
	from cct
	where Card_Type = 'Gold'
	group by City
), city_gold_cte as (
	select City,
		SUM(Amount) as city_amount_spend
	from cct
	group by City
)
select TOP 1 a.City,
	ROUND((100*a.citywise_total_gold_spend*1.0/b.city_amount_spend*1.0), 2) as gold_percentage
from gold_ts_cte as a
join city_gold_cte as b
	on a.City = b.City
order by gold_percentage asc;

-- SOLUTION 2:
WITH city_spend_cte AS (
    SELECT City,
        SUM(CASE WHEN Card_Type = 'Gold' THEN Amount ELSE 0 END) AS citywise_total_gold_spend,
        SUM(Amount) AS city_amount_spend
    FROM cct
    GROUP BY City
)
SELECT TOP 1 City,
    ROUND(100.0 * citywise_total_gold_spend / city_amount_spend, 2) AS gold_percentage
FROM city_spend_cte
ORDER BY gold_percentage ASC;

```
</details>


- #### Q5. write a query to print 3 columns: city, highest_expense_type , lowest_expense_type 
<details>
	<summary> Click Here for Answer </summary>
	
```sql
-- SOLUTION 1:
WITH city_exp_cte AS (
    SELECT City, Exp_Type,
        SUM(Amount) AS spend_amount
    FROM cct
    GROUP BY City, Exp_Type
), min_max_exp_cte AS (
    SELECT City,
        MIN(spend_amount) AS min_spend,
        MAX(spend_amount) AS max_spend
    FROM city_exp_cte
    GROUP BY City
)
SELECT 
    a.City,
    MAX(CASE WHEN b.spend_amount = a.min_spend THEN b.Exp_Type END) AS lowest_expense_type,
    MAX(CASE WHEN b.spend_amount = a.max_spend THEN b.Exp_Type END) AS highest_expense_type
FROM min_max_exp_cte AS a
JOIN city_exp_cte AS b
    ON a.City = b.City
GROUP BY a.City;

-- SOLUTION 2:
SELECT 
    City,
    MAX(CASE WHEN spend_amount = MIN(spend_amount) OVER (PARTITION BY City) THEN Exp_Type END) AS lowest_expense_type,
    MAX(CASE WHEN spend_amount = MAX(spend_amount) OVER (PARTITION BY City) THEN Exp_Type END) AS highest_expense_type
FROM (
    SELECT City, Exp_Type,
        SUM(Amount) AS spend_amount
    FROM cct
    GROUP BY City, Exp_Type
) AS city_exp
GROUP BY City;

```
</details>


- #### Q6. Write a query to find percentage contribution of spends by females for each expense type.
<details>
	<summary> Click Here for Answer </summary>
	
```sql
-- SOLUTION 1:
with cte_1 as (
	select  Exp_Type , 
		sum(Amount) as Exp_type_spent_amount
	from cct
	where Gender = 'F'
	group by Exp_Type
), cte_2 as (
	select sum(Amount) as total_spent
	from cct
	where Gender = 'F'
)
select Exp_Type,
	Exp_type_spent_amount,
	total_spent,
	format(100.0* Exp_type_spent_amount / total_spent ,'N2') as perc_contribution_spent_female
from  cte_1 inner join cte_2 on 1=1;

-- SOLUTION 2:
WITH cte AS (
    SELECT Exp_Type,
        SUM(Amount) AS Exp_type_spent_amount,
        SUM(SUM(Amount)) OVER () AS total_spent
    FROM cct
    WHERE Gender = 'F'
    GROUP BY Exp_Type
)
SELECT Exp_Type,
    Exp_type_spent_amount,
    total_spent,
    FORMAT(100.0 * Exp_type_spent_amount / total_spent, 'N2') AS perc_contribution_spent_female
FROM cte;
```
</details>


- #### Q7. which card and expense type combination saw highest month over month growth in january 2014
<details>
	<summary> Click Here for Answer </summary>
	
```sql
-- SOLUTION 1:
with cte1 as (
	select Card_Type, Exp_Type,
		DATEPART(YEAR, Date) as year,
		DATEPART(MONTH, Date) as Month,
		sum(Amount) as total_amount
	from cct
	group by Card_Type, Exp_Type, 
		DATEPART(YEAR, Date), DATEPART(MONTH, Date)
), cte2 as (
	select *,
		LAG(total_amount, 1) over(partition by Card_Type, Exp_Type order by year, Month) as prev_month_total_amount
	from cte1
), cte3 as (
	select *,
		100.0*(total_amount - prev_month_total_amount) / prev_month_total_amount as growth_per_month
	from cte2
	where year = 2014
		and Month = 1
)
select TOP 1 *
from cte3
order by growth_per_month desc;

-- SOLUTION 2:
WITH cte AS (
    SELECT Card_Type, Exp_Type,
        DATEPART(YEAR, Date) AS year, DATEPART(MONTH, Date) AS Month,
        SUM(Amount) AS total_amount,
        LAG(SUM(Amount), 1) OVER (PARTITION BY Card_Type, Exp_Type ORDER BY DATEPART(YEAR, Date), DATEPART(MONTH, Date))
			AS prev_month_total_amount
    FROM cct
    GROUP BY Card_Type, Exp_Type, DATEPART(YEAR, Date), DATEPART(MONTH, Date)
)
SELECT TOP 1 Card_Type, Exp_Type, year, Month, total_amount, prev_month_total_amount,
    100.0 * (total_amount - prev_month_total_amount) / prev_month_total_amount AS growth_per_month
FROM cte
WHERE year = 2014 AND Month = 1
ORDER BY growth_per_month DESC;

```
</details>


- #### Q8. during weekends which city has highest total spend to total no of transcations ratio 
<details>
	<summary> Click Here for Answer </summary>
	
```sql
-- SOLUTION 1:
select TOP 1 City,
	SUM(Amount) as total_spend,
	COUNT(1) as transaction_cnt,
	ration = SUM(Amount) / COUNT(1)
from cct
where DATEPART(WEEKDAY, Date) in (7, 1)
group by City
order by ration desc;

```
</details>


- #### Q9. which city took least number of days to reach its 500th transaction after first transaction in that city 
<details>
	<summary> Click Here for Answer </summary>
	
```sql
-- SOLUTION 1:
with cte1 as (
	select City,
		count(1) as transaction_cnt,
		MIN(Date) as min_trans_date,
		MAX(Date) as max_trans_date
	from cct
	group by City
	having count(1) >= 500
), cte2 as (
	select City, Date,
		ROW_NUMBER() over(partition by city order by Date) as rn
	from cct
	where City in (select City from cte1)
), cte3 as (
	select a.City, a.min_trans_date, a.max_trans_date,
		a.transaction_cnt, b.Date
	from cte1 as a
	join cte2 as b
		on a.City = b.City
	where b.rn = 500
)
select City, min_trans_date, Date as "500th_trans_date",
	DATEDIFF(DAY, min_trans_date, Date) as day_to_reach_500th_trans
from cte3
order by day_to_reach_500th_trans;

-- SOLUTION 2:
WITH cte AS (
    SELECT City,
        COUNT(1) AS transaction_cnt,
        MIN(Date) AS min_trans_date,
        MAX(Date) AS max_trans_date,
        ROW_NUMBER() OVER(PARTITION BY City ORDER BY Date) AS rn
    FROM cct
    GROUP BY City
    HAVING COUNT(1) >= 500
)
SELECT City, min_trans_date, 
    MAX(CASE WHEN rn = 500 THEN Date END) AS "500th_trans_date",
    DATEDIFF(DAY, min_trans_date, MAX(CASE WHEN rn = 500 THEN Date END)) AS day_to_reach_500th_trans
FROM cte
GROUP BY City, min_trans_date, max_trans_date, transaction_cnt
ORDER BY day_to_reach_500th_trans;

```
</details>

