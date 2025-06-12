/*
===============================================================================================================
Customer Report
===============================================================================================================
Purpose:
	- This report consolidates key customer metrics and behaviors

Highlights:
	1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
	3. Aggregates customer- level metrics:
		-  total orders
		-  total sales
		-  total quantity purchased
		-  total products
		-  lifespan (in months)
	4. Caculates valuable KPIs:
		-  recency (months since last order)
		-  average order value
		-  average monthly spend
================================================================================================================
*/

CREATE VIEW gold.report_customers AS
WITH base_query AS(
/*
-----------------------------------------------------------------------------
1) Base query : Retrieves core columns from tables
-----------------------------------------------------------------------------
*/
SELECT 
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_number,
CONCAT(c.first_name,' ',c.last_name) AS customer_name,
DATEDIFF(YEAR,c.birthdate, GETDATE()) AS age
FROM
gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
WHERE order_date IS NOT NULL
)
, customer_aggregation AS(
/*
-----------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
-----------------------------------------------------------------------------
*/
SELECT 
	customer_key,
	customer_number,
	customer_name,
	age,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_qty,
	COUNT(DISTINCT product_key) AS total_products,
	MAX(order_date) AS last_order_date,
	DATEDIFF(MONTH,  min(order_date), max(order_date)) as life_span
FROM base_query
GROUP BY
	
customer_key,
	customer_number,
	customer_name,
	age
)
/*
-----------------------------------------------------------------------------
3) Final Query : Combines all customer results into one output
-----------------------------------------------------------------------------
*/
SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	CASE WHEN age <20 THEN 'Under 20'
		 WHEN age between 20 AND 29 THEN '20-29'
		 WHEN age between 30 AND 39 THEN '30-39'
		 WHEN age between 40 AND 49 THEN '40-49'
		ELSE '50 and Above'
	END AS age_group,
	CASE WHEN life_span >= 12 AND total_sales > 5000 THEN  'VIP'
					WHEN life_span >= 12 AND total_sales <= 5000 THEN  'Regular'
					ELSE  'New'
				END AS customer_segment,
	last_order_date,
	DATEDIFF(MONTH,last_order_date,GETDATE()) as recency,
	total_orders,
	total_sales,
	total_qty,
	total_products,
	life_span,
	-- Compute Average Order Value(AVO)
	CASE WHEN total_orders = 0 THEN 0
		ELSE  total_sales/total_orders
	END AS average_order_value,
	-- Compute Average Monthly Spend
	CASE WHEN life_span = 0 THEN total_sales
		ELSE  total_sales/life_span
	END AS average_monthly_spend
FROM customer_aggregation


SELECT 
age_group,
count(total_orders),
SUM(total_sales)  as total_Sales
FROM gold.report_customers
group by age_group

SELECT 
customer_segment,
count(total_orders),
SUM(total_sales) as total_Sales
FROM gold.report_customers
group by customer_segment
