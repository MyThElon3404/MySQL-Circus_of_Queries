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

- ## Question & Answer for case study

- ### Q1. write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends

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


- ### Q2. write a query to print highest spend month and amount spent in that month for each card type
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


- Q1. write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends
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
