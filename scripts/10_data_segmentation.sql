-- Segment products into cost range and
-- count how many products fall into each segment
WITH product_segment AS (
SELECT
product_key,
product_name,
cost,
	CASE WHEN cost < 100 THEN 'Below 100'
		 WHEN cost BETWEEN 100 AND 500 THEN '100-500'
		 WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
		 ELSE 'ABOVE 1000'
	END  cost_range
		 
FROM
gold.dim_products
)

SELECT
cost_range,
count(product_key) AS total_products
FROM 
product_segment
GROUP BY cost_range
ORDER BY total_products DESC

/*
Group customers into three segments based on their spending behavior:
	- VIP : Customers with at least 12 months of history and spending more than $5,000
	- Regular : CUstomers with at least 12 months of history but spending $5000 or less.
	- New : CUstomers with a lifespan less than 12 months.
	And find total number of customers by each group.
*/
select 
customer_segment,
count(*)
FROM (
	select 
	customer_key,
	min(order_date) first_order,
	max(order_date) last_order,
	SUM(sales_amount) AS spending_amt,
	DATEDIFF(MONTH,  min(order_date), max(order_date)) as life_span,
		CASE WHEN DATEDIFF(MONTH,  min(order_date), max(order_date)) >= 12 AND SUM(sales_amount) > 5000 THEN  'VIP'
			WHEN DATEDIFF(MONTH,  min(order_date), max(order_date)) >= 12 AND SUM(sales_amount) < 5000 THEN  'Regular'
			ELSE  'New'
		END AS customer_segment
	from gold.fact_sales
	group by customer_key 
)t
GROUP BY customer_segment

--------------------------------------OR -------------------------------

WITH customer_spending AS (
	SELECT
	c.customer_key,
	MIN(f.order_date) first_order,
	MAX(f.order_date) last_order,
	SUM(f.sales_amount) AS spending_amt,
	DATEDIFF(month,  MIN(order_date), MAX(order_date)) as life_span
		
	from gold.fact_sales f
	LEFT JOIN gold.dim_customers c
	ON f.customer_key = c.customer_key
	group by c.customer_key 
)
SELECT
	customer_segment,
	count(*) FROM
	(
		SELECT 
			customer_key,
			life_span,
			spending_amt,
			CASE WHEN life_span >= 12 AND spending_amt > 5000 THEN  'VIP'
					WHEN life_span >= 12 AND spending_amt <= 5000 THEN  'Regular'
					ELSE  'New'
				END AS customer_segment
			FROM customer_spending
	) t
	GROUP BY customer_segment
