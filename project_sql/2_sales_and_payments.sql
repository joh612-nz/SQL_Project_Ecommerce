/*
1. Find the monthly sales trends by calculating the total payment_value for each month, ensuring that only 'delivered' orders are included in the analysis.
    - Use the order_purchase_timestamp from the orders table to group the sales by month.
    - payment value should be summed up for each month to get the total sales for that month.
    - Is payment_value increasing over time on a monthly basis?
    - Check the change in payment_value over time by each city to see if there are any regional trends in sales.
2. Analyze the preferred payment methods by calculating the average number of installments (payment_installments) used in transactions, and see if there are any trends or patterns in installment usage.

need to check that order status (from orders table) is 'delivered' to ensure that we are analyzing completed transactions, 
    as other statuses like 'canceled' or 'returned' may not reflect actual sales and payments.
*/

-- Before we start analyzing the preferred payment methods, we need to check the distribution of order statuses in the orders table to ensure that we are focusing on 'delivered' orders for our analysis of payment methods, as other statuses may not reflect completed transactions.
SELECT
    DISTINCT order_status,
    COUNT (*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;
/*
It indicates that the majority of orders in the dataset are 'delivered', which means that we can focus our analysis on these orders to get insights into completed transactions and payment methods.
96478 out of 99441 orders are delivered, which is a very high percentage (approximately 97.1%), indicating that most transactions in the dataset are completed successfully.
*/

-- checking the data from orders table to see if there are multiple years of data, and if so, we need to consider that in our analysis of monthly sales trends.
-- starts from September 2016 and ends in August 2018, so we have data for multiple years, and we need to consider that in our analysis of monthly sales trends.
SELECT
    order_id,
    order_purchase_timestamp,
    order_status
FROM orders
WHERE order_status = 'delivered'
ORDER BY order_purchase_timestamp;

-- Find the monthly sales trends by calculating the total payment_value for each month, ensuring that only 'delivered' orders are included in the analysis.
-- going to only use data from 2017 for this analysis to avoid the partial data from 2016 and 2018, which may skew the results.
SELECT
    Extract(YEAR FROM orders.order_purchase_timestamp) AS order_year,
    Extract(MONTH FROM orders.order_purchase_timestamp) AS order_month,
    COUNT(orders.order_id) AS total_orders,
    SUM(order_payments.payment_value) AS total_payment_value
FROM orders
INNER JOIN order_payments ON orders.order_id = order_payments.order_id
WHERE orders.order_status = 'delivered'
    AND Extract(YEAR FROM orders.order_purchase_timestamp) = 2017
GROUP BY order_year, order_month
ORDER BY order_month;
/*
This query calculates the total number of orders delivered and the total payment value (sales) for each month of the year 2017.
The results show that sales tend to increase towards the end of the year, with a significant spike in December, which is likely due to holiday shopping. The lowest sales are observed in February, 
    which is typically a slow month for retail sales.
*/

-- Similar to the previous query, but organized by quarter instead of month to see if there are any seasonal trends in sales.
    SELECT
        CASE 
            WHEN EXTRACT(MONTH FROM orders.order_purchase_timestamp) IN (1, 2, 3) THEN 'Q1'
            WHEN EXTRACT(MONTH FROM orders.order_purchase_timestamp) IN (4, 5, 6) THEN 'Q2'
            WHEN EXTRACT(MONTH FROM orders.order_purchase_timestamp) IN (7, 8, 9) THEN 'Q3'
            ELSE 'Q4'
        END AS quarter,
        COUNT(orders.order_id) AS total_orders,
        SUM(order_payments.payment_value) AS total_sales
    FROM orders
    INNER JOIN order_payments ON orders.order_id = order_payments.order_id
    WHERE orders.order_status = 'delivered'
        AND EXTRACT(YEAR FROM orders.order_purchase_timestamp) = 2017
    GROUP BY quarter
    ORDER BY quarter;

-- to check the total sales and orders by city for the year 2017 in order to identify the top cities in terms of sales and orders, which can help us focus our analysis on the most relevant regions.
SELECT 
    customers.customer_city AS city,
    COUNT(orders.order_id) AS total_orders,
    SUM(order_payments.payment_value) AS total_sales
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id
INNER JOIN order_payments ON orders.order_id = order_payments.order_id
WHERE orders.order_status = 'delivered'
    AND Extract(YEAR FROM orders.order_purchase_timestamp) = 2017
GROUP BY city
ORDER BY total_sales DESC, total_orders DESC
LIMIT 5;
/*
    it indicates that Sao Paulo, Rio de Janeiro, Belo Horizonte, Brasilia, and Porto Alegre are the top cities in terms of total sales and orders, 
    which is consistent with the fact that these cities have the highest number of customers in the dataset. 
    This suggests that these cities are likely to be the most important markets for the business, and analyzing sales trends in these cities can provide valuable insights into customer behavior and preferences.
*/

-- Analyze the monthly sales trends by city to see if there are any regional trends in sales.
-- focusing on the top 5 cities with the highest number of customers, which are Sao Paulo, Rio de Janeiro, Belo Horizonte, Brasilia, and Porto Alegre.

SELECT
    customer_city AS city,
    Extract(MONTH FROM orders.order_purchase_timestamp) AS order_month,
    COUNT(orders.order_id) AS total_orders,
    SUM(order_payments.payment_value) AS total_sales
FROM orders
INNER JOIN order_payments ON orders.order_id = order_payments.order_id
INNER JOIN customers ON orders.customer_id = customers.customer_id
WHERE orders.order_status = 'delivered'
    AND Extract(YEAR FROM orders.order_purchase_timestamp) = 2017
    AND customer_city IN ('sao paulo', 'rio de janeiro', 'belo horizonte', 'brasilia', 'porto alegre')
GROUP BY city, order_month
ORDER BY city, order_month;

-- going to work on same analysis but using CTEs to make it more organized and easier to read.
-- make a CTE to extract top 5 cities based on total sales and orders, and then use that CTE to analyze the monthly sales trends by city.

WITH monthly_sales AS (
    SELECT
        customer_city AS city,
        Extract(MONTH FROM orders.order_purchase_timestamp) AS order_month,
        COUNT(orders.order_id) AS total_orders,
        SUM(order_payments.payment_value) AS total_sales
    FROM orders
    INNER JOIN order_payments ON orders.order_id = order_payments.order_id
    INNER JOIN customers ON orders.customer_id = customers.customer_id
    WHERE orders.order_status = 'delivered'
        AND Extract(YEAR FROM orders.order_purchase_timestamp) = 2017
        AND customer_city IN ('sao paulo', 'rio de janeiro', 'belo horizonte', 'brasilia', 'porto alegre')
    GROUP BY city, order_month
)
SELECT * FROM monthly_sales ORDER BY city, order_month;

-- Analyze the preferred payment methods and payment installments 

-- Checking the distribution of payment types in the transactions made in 2017 (and completed) to see which payment methods are most commonly used by customers for their purchases, which can help us understand customer preferences and behavior when it comes to payment options.
SELECT
    payment_type,
    COUNT(*) AS total_transactions
FROM 
    order_payments
INNER JOIN orders ON order_payments.order_id = orders.order_id
WHERE orders.order_status = 'delivered'
    AND Extract(YEAR FROM orders.order_purchase_timestamp) = 2017
GROUP BY payment_type
ORDER BY total_transactions DESC;

SELECT 
    payment_type,
    AVG(payment_installments) AS avg_installments
FROM order_payments
INNER JOIN orders ON order_payments.order_id = orders.order_id
WHERE orders.order_status = 'delivered'
    AND Extract(YEAR FROM orders.order_purchase_timestamp) = 2017
GROUP BY payment_type
ORDER BY avg_installments DESC;

SELECT 
    payment_installments,
    COUNT(*) AS total_transactions,
    SUM(payment_value) AS total_payment_value
FROM order_payments
GROUP BY payment_installments
ORDER BY payment_installments;

SELECT
    *
FROM order_payments;
