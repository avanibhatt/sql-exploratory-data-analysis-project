/*
============================================================================================================
Product Report
============================================================================================================
Purpose:
	- This report consolidates key product metrics and behaviors

Highlights:
	1. Gathers essential fields such as product name, category, subcategory and cost.
	2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
	3. Aggregates Product-level Metrics:
		- total orders
		- total sales
		- total quantity sold
		- total customers(unique)
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last sale)
		- average order revenue(AOR)
		- average monthly revenue
============================================================================================================
*/
CREATE VIEW gold.report_products AS 
WITH base_query AS(
/*
-----------------------------------------------------------------------------
1) Base query : Retrieves core columns from tables
-----------------------------------------------------------------------------
*/

SELECT 
	f.order_number,
	f.customer_key,
	f.order_date,
	f.sales_amount,
	f.quantity,
	p.product_key,
	p.product_name,
	p.category,
	p.subcategory,
	p.cost
FROM
gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE f.order_date IS NOT NULL				-- Only consider valid sales date
)

,product_aggregation AS(
/*
-----------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the customer level
-----------------------------------------------------------------------------
*/
SELECT
product_key,
product_name,
category,
subcategory,
cost,
DATEDIFF(MONTH, MIN(order_date),MAX(order_date)) AS life_span,
MAX(order_date) AS last_order_date,
COUNT(DISTINCT order_number) AS total_orders,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_qty_sold,
ROUND(AVG(CAST(sales_amount AS FLOAT) /NULLIF(quantity,0)),1) AS avg_selling_price


FROM
base_query
GROUP BY 
	product_key,
	product_name,
	category,
	subcategory,
	cost

)
/*
-----------------------------------------------------------------------------
3) Final Query : Combines all product results into one output
-----------------------------------------------------------------------------
*/
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_order_date,
	DATEDIFF(MONTH,last_order_date,GETDATE()) as recency,
	CASE WHEN total_sales >= 500000 THEN 'High Performers'
		WHEN total_sales  BETWEEN 100000 AND 500000 THEN 'Mid Range Performer'
		ELSE 'Low Performer'
	END AS product_segment,
	life_span,
	total_orders,
	total_sales,
	total_qty_sold,
	total_customers,
	
	-- Compute Average Order Revenue(AOR)
	CASE WHEN total_orders = 0 THEN 0
		ELSE  total_sales/total_orders
	END AS average_order_revenue,
	-- Compute Average Monthly Revenue
	CASE WHEN life_span = 0 THEN total_sales
		ELSE  total_sales/life_span
	END AS average_monthly_revenue
FROM
product_aggregation

SELECT 
product_segment,
count(total_orders) as total_orders,
SUM(total_sales)  as total_Sales
FROM gold.report_products
group by product_segment

SELECT 
*
FROM gold.report_products
