/*
Data Analysis using Brazilian E-Commerce Database
source from Kaggle: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce 

1. Find the total number of customers and orders in the dataset.
2. Find the number of customers and orders by city.
3. Find the ratio of orders per customer by city, focusing on cities with more than 500 unique customers.
*/

-- Find the total number of customers and orders in the dataset
-- Customer Unique ID is used to identify unique customers, while Order ID is used to identify unique orders.
-- Customer ID is used to link customers and orders, but it may not be unique for each customer, as one customer can have multiple orders.
SELECT 
    COUNT(DISTINCT customers.customer_unique_id) AS total_customers,
    COUNT(DISTINCT orders.order_id) AS total_orders
FROM customers 
INNER JOIN orders ON customers.customer_id = orders.customer_id;

-- Find the number of customers and orders by city
SELECT
    customer_city AS city,
    COUNT(DISTINCT customers.customer_unique_id) AS total_customers,
    COUNT(DISTINCT orders.order_id) AS total_orders
FROM customers 
INNER JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customer_city
ORDER BY total_customers DESC;

/*
Sao Paulo has the highest number of customers and orders, followed by Rio de Janeiro and Belo Horizonte. 
This indicates that these cities are the most active in terms of e-commerce transactions in the dataset.
*/

-- Find the number of customers and orders by state
SELECT
    customer_state AS state,
    COUNT(DISTINCT customers.customer_unique_id) AS total_customers,
    COUNT(DISTINCT orders.order_id) AS total_orders
FROM customers 
INNER JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customer_state
ORDER BY total_customers DESC, total_orders DESC;

/*
Sao Paulo state has the highest number of customers and orders, followed by Rio de Janeiro and Minas Gerais.
This indicates that these states are the most active in terms of e-commerce transactions in the dataset.
*/

-- Find the average number of orders per customer by city
SELECT
    customer_city AS city,
    COUNT(DISTINCT customers.customer_unique_id) AS total_customers,
    COUNT(DISTINCT orders.order_id) AS total_orders,
    -- Calculate the average number of orders per customer by dividing the total number of orders by the total number of customers, and round it to 2 decimal places.
    ROUND(COUNT(DISTINCT orders.order_id)::numeric / COUNT(DISTINCT customers.customer_unique_id), 2) AS orders_per_customer
FROM customers 
INNER JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customer_city
    -- Filter cities with more than 500 unique customers to focus on more active cities.
HAVING COUNT(DISTINCT customers.customer_unique_id) > 500 
ORDER BY orders_per_customer DESC
LIMIT 20;

/*
This query shows the average number of orders per customer by city, focusing on cities with more than 500 unique customers.
The results are ordered by the average number of orders per customer in descending order, showing the most active cities in terms of customer engagement.
The ratio of orders per customer is very low, close to 1, indicating that most customers only make one or two orders, which is common in e-commerce datasets.
It can also indicate that many customers are new or that there is a high churn rate, where customers do not return to make additional purchases.
*/


