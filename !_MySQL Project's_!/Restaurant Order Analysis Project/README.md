# Restaurant Order Analysis
## Overview
The Restaurant Analytics System is a data analytics project designed to provide insights and analysis for a restaurant business. It leverages data stored in MySQL databases and utilizes Jupyter Notebook as the primary analytical tool. The goal is to uncover valuable business insights, identify trends, and make data-driven decisions to enhance overall restaurant performance.

## Features
Sales and Revenue Analysis: Understand sales patterns, revenue generation, and identify top-selling items.
Customer Behavior Analysis: Analyze customer preferences, ordering habits, and identify popular menu categories.
Order Fulfillment Efficiency: Evaluate order processing times, peak hours, and identify areas for operational improvement.
Menu Optimization: Determine the most and least popular menu items to optimize the menu for better profitability.
Top Orders Analysis: Identify high-value orders and customer segments contributing significantly to revenue.
Performance Monitoring: Monitor the performance of the restaurant over time and identify areas for improvement.

## OBJECTIVES
### OBJECTIVE 1
#### Explore the items table
The first objective is to better understand the items table by finding the number of rows in the table, the least and most expensive items, and the item prices within each category.

1. View the menu_items table and write a query to find the number of items on the menu
2. What are the least and most expensive items on the menu?
3. How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu?
4. How many dishes are in each category? What is the average dish price within each category?

### OBJECTIVE 2
#### Explore the orders table
The second objective is to better understand the orders table by finding the date range, the number of items within each order, and the orders with the highest number of items.

1. View the order_details table. What is the date range of the table?
2. How many orders were made within this date range? How many items were ordered within this date range?
3. Which orders had the most number of items?
4. How many orders had more than 12 items?

### OBJECTIVE 3
#### Analyze customer behavior
The final objective is to combine the items and orders tables, find the least and most ordered categories, and dive into the details of the highest spend orders.

1. Combine the menu_items and order_details tables into a single table
2. What were the least and most ordered items? What categories were they in?
3. What were the top 5 orders that spent the most money?
4. View the details of the highest spend order. Which specific items were purchased?
5. BONUS: View the details of the top 5 highest spend orders

### FINAL QUESTION (Included in OBJECTIVE 3)
1. how much was the most expensive order in the dataset?
