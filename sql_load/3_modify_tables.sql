/* ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
Database Load Issues (follow if receiving permission denied when running SQL code below)

NOTE: If you are having issues with permissions. And you get error: 

'could not open file "[your file path]\job_postings_fact.csv" for reading: Permission denied.'

1. Open pgAdmin
2. In Object Explorer (left-hand pane), navigate to `sql_course` database
3. Right-click `sql_course` and select `PSQL Tool`
    - This opens a terminal window to write the following code
4. Get the absolute file path of your csv files
    1. Find path by right-clicking a CSV file in VS Code and selecting “Copy Path”
5. Paste the following into `PSQL Tool`, (with the CORRECT file path)

\copy customers FROM '/Users/junghwanoh/Documents/Business_Analytics/SQL_Project_Ecommerce/csv_files/customers.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy sellers FROM '/Users/junghwanoh/Documents/Business_Analytics/SQL_Project_Ecommerce/csv_files/sellers.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy products FROM '/Users/junghwanoh/Documents/Business_Analytics/SQL_Project_Ecommerce/csv_files/products.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy order_items FROM '/Users/junghwanoh/Documents/Business_Analytics/SQL_Project_Ecommerce/csv_files/order_items.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy orders FROM '/Users/junghwanoh/Documents/Business_Analytics/SQL_Project_Ecommerce/csv_files/orders.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy order_payments FROM '/Users/junghwanoh/Documents/Business_Analytics/SQL_Project_Ecommerce/csv_files/order_payments.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy order_reviews FROM '/Users/junghwanoh/Documents/Business_Analytics/SQL_Project_Ecommerce/csv_files/order_reviews.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy product_category_name_translation FROM '/Users/junghwanoh/Documents/Business_Analytics/SQL_Project_Ecommerce/csv_files/product_category_name_translation.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

*/

-- NOTE: This has been updated from the video to fix issues with encoding

COPY customers
FROM '/Users/junghwanoh/Documents/Business_Analytics/SQL_Project_Ecommerce/csv_files/customers.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY sellers
FROM '/Users/junghwanoh/Documents/Business_Analytics/SQL_Project_Ecommerce/csv_files/sellers.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY products
FROM '/Users/junghwanoh/Documents/Business_Analytics/SQL_Project_Ecommerce/csv_files/products.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY order_items
FROM '/Users/junghwanoh/Documents/Business_Analytics/SQL_Project_Ecommerce/csv_files/order_items.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY orders
FROM '/Users/junghwanoh/Documents/Business_Analytics/SQL_Project_Ecommerce/csv_files/orders.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY order_payments
FROM '/Users/junghwanoh/Documents/Business_Analytics/SQL_Project_Ecommerce/csv_files/order_payments.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY order_reviews
FROM '/Users/junghwanoh/Documents/Business_Analytics/SQL_Project_Ecommerce/csv_files/order_reviews.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY product_category_name_translation
FROM '/Users/junghwanoh/Documents/Business_Analytics/SQL_Project_Ecommerce/csv_files/product_category_name_translation.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');