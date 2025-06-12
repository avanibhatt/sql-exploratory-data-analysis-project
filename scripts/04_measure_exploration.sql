-- Find the Total Sales
SELECT sum(sales_amount) AS total_sales FROM gold.fact_sales
-- Find how many items are sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales
-- Find the average selling price
SELECT AVG(price) AS avg_price FROM gold.fact_sales
-- Find the Total number of Orders
SELECT COUNT( order_number) AS total_orders FROM gold.fact_sales
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales
-- Find the Total number of Products
SELECT COUNT(DISTINCT product_name) AS total_products FROM gold.dim_products
SELECT COUNT(product_name) AS total_products FROM gold.dim_products
-- Find the Total number of Customers
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.dim_customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers

-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.fact_sales

SELECT COUNT(customer_key) AS total_customers FROM gold.fact_sales



--Generate a Report that shows all key metrics of the business

SELECT 'Total Sales' AS measure_name, sum(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity' AS measure_name,SUM(quantity) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Average Price' AS measure_name,AVG(price) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total No. OF Orders' AS measure_name,COUNT(DISTINCT order_number) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total No. OF Products' AS measure_name,COUNT(product_name) AS measure_value FROM gold.dim_products
UNION ALL
SELECT 'Total No. OF Customers' AS measure_name,COUNT(customer_key) AS measure_value FROM gold.dim_customers
