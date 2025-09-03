-- Sql Retail sales Analysis -P1
--create table
DROP TABLE IF EXISTS retail_sales;
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



SELECT * FROM retail_sales;

COPY retail_sales(transactions_id,sale_date,sale_time,customer_id,gender,age,category,quantiy,price_per_unit,cogs,total_sale
)
FROM 'D:/data analysis course/SQL/SQL series_basic_to_advanced/retail.csv'
CSV HEADER;


SELECT * FROM retail_sales;
LIMIT 10;


SELECT COUNT(*) FROM retail_sales;


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

-- Data Exploration
--how many sales we have
SELECT COUNT(*) AS total_sale FROM retail_sales;

-- how many unique customers we  have

SELECT count(DISTINCT customer_id) AS total_customer FROM retail_sales;

SELECT DISTINCT category AS total_category FROM retail_sales;



SELECT * FROM retail_sales;
-- Data analysis problems & business key problems and answers
--1) write a sql query to retrive all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';


--2) write the sql query to retrive all trasactions where the category is 'Clothing' and the quantity sold is
--more than 3 the month of Nov-2022
SELECT * FROM retail_sales
WHERE category = 'Clothing'
AND TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
AND quantiy >= 3;


--3)Write the SQl querry to calculate the total sales (total_sales) for each category

SELECT category,
		COUNT (*) AS total_orders,
		SUM(total_sale) AS net_sale 
		FROM retail_sales
GROUP BY category;


--4) write the Sql query to find the average age of customers who purchased items from the 'beauty' category
SELECT ROUND(AVG(age),2) AS avg_age FROM retail_sales
WHERE category = 'Beauty';

--5) write the sql querry to find all transactions where the total_sale is grater than 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000;


--6) write a sql querry to find the total no. of transaction (transaction_id) made by each gander in each category
SELECT category,gender, COUNT(*) AS total_trans
FROM retail_sales
GROUP BY category,gender
ORDER BY 1;


--7) write the sql querry to calculate the average sale for each month, Find out the best selling month in each year

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

--8) write the sql querry to find the top 5 customers based on the heighest total_sales
SELECT customer_id,
		SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC LIMIT 5;


--9) write the sql querry to find the no. of unique customers who purchased items form each category.
SELECT category,COUNT(DISTINCT customer_id) AS unique_customer
FROM retail_sales
GROUP BY category;

--10) write a sql querry to create each shift and number of orders 
--	(Example morning <=12,afternoon between 12 to 17, evening>=17)

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


--END OF PROJECT	