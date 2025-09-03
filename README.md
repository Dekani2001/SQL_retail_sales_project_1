# 🛒 Retail Sales Analysis Project 1 

## Project Overview 

This project focuses on analyzing retail sales data using SQL. The goal is to clean, explore, and analyze transactional data to uncover sales patterns, customer behavior, and product performance. Through SQL queries, meaningful insights are derived to support data-driven business decisions.

## 2. Objectives

1. **Build and populate a retail sales database.**
2. **Perform data cleaning to remove missing or inconsistent records.**
3. **Explore the dataset to understand sales distribution and customer demographics.**
4. **Solve key business questions using SQL queries.**
5. **Summarize findings to highlight trends and actionable insights.**

## 3. Project Structure
### 🔹 Database Creation

- **Created a table retail_sales with fields like transactions_id, sale_date, customer_id, gender, age, category, quantity, cogs, and total_sale.**
``` sql
  CREATE DATABASE sql_project_p1
CREATE TABLE retail_sales(
			transactions_id	INT PRIMARY KEY,
			sale_date	DATE,
			sale_time	TIME,
			customer_id	INT,
			gender	VARCHAR(10),
			age	INT,
			category	VARCHAR(20),
			quantiy	INT,
			price_per_unit	FLOAT,
			cogs	FLOAT,
			total_sale	FLOAT
			);
   ```
- **Imported data from a CSV file into the database.**
``` sql
COPY retail_sales(transactions_id,sale_date,sale_time,customer_id,gender,age,category,quantiy,price_per_unit,cogs,total_sale
)
FROM 'D:/data analysis course/SQL/SQL series_basic_to_advanced/retail.csv'
CSV HEADER;
```

### 🔹 Data Exploration & Cleaning

- **Checked for missing values and deleted invalid records.**
```sql
--  Data Cleaning
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR 
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
```
```sql
DELETE FROM retail_sales
WHERE transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR 
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
```
- **Counted total sales transactions, unique customers, and product categories.**
```sql
-- Data Exploration
--how many sales we have
SELECT COUNT(*) AS total_sale FROM retail_sales;

-- how many unique customers we  have

SELECT count(DISTINCT customer_id) AS total_customer FROM retail_sales;


```
- **Verified data distribution across sales dates and categories.**
``` sql
SELECT DISTINCT category AS total_category FROM retail_sales;
```


### 🔹 Data Analysis & Findings
***The following key business questions were solved with SQL queries:***

1. **Retrieve all sales made on a specific date (e.g., 2022-11-05).**
```sql
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Find all Clothing category sales with quantity > 3 in Nov-2022.**
```sql
SELECT * FROM retail_sales
WHERE category = 'Clothing'
AND TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
AND quantiy >= 3;
```

3. **Calculate total sales and total orders per category.**
```sql

SELECT category,
		COUNT (*) AS total_orders,
		SUM(total_sale) AS net_sale 
		FROM retail_sales
GROUP BY category;
```
4. **Find the average age of customers buying from the Beauty category.**
```sql
SELECT ROUND(AVG(age),2) AS avg_age FROM retail_sales
WHERE category = 'Beauty';
```

5. **List transactions where total_sale > 1000.**
``` sql
SELECT * FROM retail_sales
WHERE total_sale > 1000;
```

6. **Count transactions by gender within each category.**
```sql
SELECT category,gender, COUNT(*) AS total_trans
FROM retail_sales
GROUP BY category,gender
ORDER BY 1;
```
7. **Find the best-selling month per year based on average sales.**
```sql
SELECT year,month,avg_sale
FROM
(
	SELECT 
		EXTRACT(YEAR FROM sale_date) AS year,
		EXTRACT(MONTH FROM sale_date) AS month,
		AVG(total_sale) AS avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
	FROM retail_sales
	GROUP BY 1,2
) AS t1
WHERE rank = 1;
```
8.**Identify the top 5 customers by total sales.**
```sql
SELECT customer_id,
		SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC LIMIT 5;
```
9.**Find the unique customers per product category.**
```sql
SELECT category,COUNT(DISTINCT customer_id) AS unique_customer
FROM retail_sales
GROUP BY category;
```
10.**Classify orders into Morning, Afternoon, Evening shifts and count sales per shift.**
```sql
WITH hourly_sale
AS
(
SELECT *,
	CASE 
		WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'Mornnig'
		WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
) 
SELECT shift,COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;
```


## 📊 Report & Insights

1.*Sales Volume & Customers → Large number of transactions, diverse customer base.*

2. *Category Analysis → Clothing & Beauty categories performed strongly; Beauty attracted younger customers.*

3.*High-Value Transactions → Multiple sales > 1000 units, major revenue drivers.*

4.*Customer Behavior → Top 5 customers made a big contribution to sales; category-wise customer preferences varied.*

5.*Time-Based Trends → Afternoon & Evening shifts showed higher sales; some months outperformed others due to seasonality.*

## ✅ Conclusion

***This SQL project demonstrated how raw retail data can be cleaned, explored, and analyzed to generate business insights. The analysis revealed product category strengths, high-value customers, and time-based sales trends, helping in strategic decision-making for sales, marketing, and operations.***
