-- 1. customer info
CREATE TABLE customers (
    customer_id TEXT PRIMARY KEY,
    customer_unique_id TEXT,
    customer_zip_code_prefix INT,
    customer_city TEXT,
    customer_state CHAR(2)
);

-- 2. seller info
CREATE TABLE sellers (
    seller_id TEXT PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city TEXT,
    seller_state CHAR(2)
);

-- 3. product info
CREATE TABLE products (
    product_id TEXT PRIMARY KEY,
    product_category_name TEXT,
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

-- 4. order info
CREATE TABLE orders (
    order_id TEXT PRIMARY KEY,
    customer_id TEXT REFERENCES customers(customer_id), -- 연결 추가
    order_status TEXT,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

-- 5. order items info
CREATE TABLE order_items (
    order_id TEXT REFERENCES orders(order_id),
    order_item_id INT,
    product_id TEXT REFERENCES products(product_id),
    seller_id TEXT REFERENCES sellers(seller_id), -- 연결 추가
    shipping_limit_date TIMESTAMP,
    price DECIMAL(10, 2),
    freight_value DECIMAL(10, 2),
    PRIMARY KEY (order_id, order_item_id) 
);

-- 6. payment info
CREATE TABLE order_payments (
    order_id TEXT REFERENCES orders(order_id), 
    payment_sequential INT,                         
    payment_type TEXT,                               
    payment_installments INT,                        
    payment_value DECIMAL(10, 2)                     
);

-- 7. review info
CREATE TABLE order_reviews (
    review_id TEXT PRIMARY KEY, -- TEXT로 변경
    order_id TEXT REFERENCES orders(order_id),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

-- 8. cateogory name translation
CREATE TABLE product_category_name_translation (
    product_category_name TEXT,
    product_category_name_english TEXT
);

-- Set ownership of the tables to the postgres user
ALTER TABLE customers OWNER to postgres;
ALTER TABLE sellers OWNER to postgres;
ALTER TABLE products OWNER to postgres;
ALTER TABLE orders OWNER to postgres;
ALTER TABLE order_items OWNER to postgres;
ALTER TABLE order_payments OWNER to postgres;
ALTER TABLE order_reviews OWNER to postgres;
ALTER TABLE product_category_name_translation OWNER to postgres;


-- Create indexes on foreign key columns for better performance
CREATE INDEX idx_customer_id ON public.orders (customer_id);
CREATE INDEX idx_product_id ON public.order_items (product_id);
CREATE INDEX idx_seller_id ON public.order_items (seller_id);
CREATE INDEX idx_order_id ON public.order_payments (order_id);
CREATE INDEX idx_review_order_id ON public.order_reviews (order_id);

