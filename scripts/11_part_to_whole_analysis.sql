-- Which categories contribute the most to overall sales
WITH category_sales AS(
SELECT
category,
SUM(f.sales_amount) AS total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY category
)

SELECT
category,
total_sales,
SUM(total_sales) OVER() AS overall_sales,
CONCAT(ROUND((CAST(total_sales AS FLOAT)/ SUM(total_sales) OVER()) * 100,2),'%') AS pct_of_total
FROM category_sales
ORDER BY total_sales DESC
