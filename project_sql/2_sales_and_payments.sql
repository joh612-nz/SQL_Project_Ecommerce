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
    Extract(MONTH FROM orders.order_purchase_timestamp) AS order_month,
    COUNT(orders.order_id) AS total_orders,
    SUM(order_payments.payment_value) AS total_payment_value
FROM orders
INNER JOIN order_payments ON orders.order_id = order_payments.order_id
WHERE orders.order_status = 'delivered'
    AND Extract(YEAR FROM orders.order_purchase_timestamp) = 2017
GROUP BY order_month
ORDER BY order_month;
/*
This query calculates the total number of orders delivered and the total payment value (sales) for each month of the year 2017.
The results show that sales tend to increase towards the end of the year, with a significant spike in December, which is likely due to holiday shopping. The lowest sales are observed in February, 
    which is typically a slow month for retail sales.
*/

-- Similar to the previous query, but organized by quarter instead of month to see if there are any seasonal trends in sales.
WITH quarterly_sales AS (
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
    ORDER BY quarter
)

