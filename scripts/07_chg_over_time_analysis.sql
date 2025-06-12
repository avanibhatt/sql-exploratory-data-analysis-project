--Analyze Sales performance over time
	-- BY YEAR
SELECT
YEAR(order_date) AS order_year,
SUM(sales_amount) as total_sales,
COUNT(DISTINCT customer_key)AS total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)

	-- BY MONTH
SELECT
MONTH(order_date) AS order_month,
SUM(sales_amount) as total_sales,
COUNT(DISTINCT customer_key)AS total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date)

--BY Month and Year
SELECT
YEAR(order_date) AS order_year,
MONTH(order_date) AS order_month,
SUM(sales_amount) as total_sales,
COUNT(DISTINCT customer_key)AS total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date)

--USING DATE TRUNC TO COMBINE MONTH AND YEAR
/*
SELECT
DATETRUNC('MONTH',order_date) AS order_date,
SUM(sales_amount) as total_sales,
COUNT(DISTINCT customer_key)AS total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC('MONTH',order_date)
ORDER BY DATETRUNC('MONTH',order_date)
*/

-- Format the date as per your requirements

SELECT
FORMAT(order_date,'yyyy-MMM') AS order_date,
SUM(sales_amount) as total_sales,
COUNT(DISTINCT customer_key)AS total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date,'yyyy-MMM')
ORDER BY FORMAT(order_date,'yyyy-MMM')
