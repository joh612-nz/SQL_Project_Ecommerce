/*
Data Analysis using E-Commerce Database
1. Find the cities with the highest number of customers.
2. Find the cities with the highest total orders.
3. Find the most popular products.

*/

SELECT 
    COUNT(customers.customer_id) AS total_customers,
    customer_city AS city
FROM customers
INNER JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customer_city
ORDER BY total_customers DESC;

