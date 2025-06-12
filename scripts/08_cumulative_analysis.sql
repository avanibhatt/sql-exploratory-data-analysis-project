--Calculate the total sales per month
-- and the running total of zsales over time
-- And the moving average of sales over time

SELECT 
order_date,
total_sales,
SUM(total_sales) OVER(ORDER BY order_date) AS running_total_sales,
AVG(avg_sales) OVER(ORDER BY order_date) AS moving_avg_price
FROM(
	SELECT
	--DATETRUNC(MONTH,order_date) as order_date,
	DATEFROMPARTS(YEAR(order_date),'01','01') AS order_date,		-- FOR NEW VERSION USE DATETRUNC FUNCTION INSTEAD
	--DATEFROMPARTS(YEAR(order_date),MONTH(order_date),'01') AS order_date,
	SUM(sales_amount)  AS total_sales,
	AVG(sales_amount) AS avg_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATEFROMPARTS(YEAR(order_date),'01','01')--FORMAT(order_date,'yyyy-MM-01')	--DATETRUNC(MONTH,order_date)
	   --DATETRUNC(MONTH,order_date)	
)t
