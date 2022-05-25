CREATE TABLE customers_dataset(
	customer_id VARCHAR PRIMARY KEY,
	customer_unique_id VARCHAR(240),
	customer_zip_code_prefix VARCHAR(240),
	customer_city VARCHAR(100),
	customer_state VARCHAR(100)
);

CREATE TABLE geolocation_dataset(
	geolocation_zip_code_prefix VARCHAR,
	geolocation_lat VARCHAR,
	geolocation_lng VARCHAR,
	geolocation_city VARCHAR,
	geolocation_state VARCHAR
);
-- order_id,"order_item_id","product_id","seller_id","shipping_limit_date","price","freight_value"
CREATE TABLE order_items_dataset(
	order_id VARCHAR,
	order_item_id INT,
	product_id VARCHAR,
	seller_id VARCHAR,
	shipping_limit_date TIMESTAMP,
	price real,
	freight_value real
);
-- order_id,"payment_sequential","payment_type","payment_installments","payment_value"
CREATE TABLE order_payments_dataset(
	order_id VARCHAR,
	payment_sequential INT,
	payment_type VARCHAR,
	payment_installments INT,
	payment_value real
);
-- review_id,"order_id","review_score","review_comment_title","review_comment_message","review_creation_date","review_answer_timestamp"
CREATE TABLE order_reviews_dataset(
	review_id VARCHAR,
	order_id VARCHAR,
	review_score INT,
	review_comment_title VARCHAR,
	review_comment_message VARCHAR,
	review_creation_date TIMESTAMP,
	review_answer_timestamp TIMESTAMP
);
-- order_id,"customer_id","order_status","order_purchase_timestamp","order_approved_at","order_delivered_carrier_date","order_delivered_customer_date","order_estimated_delivery_date"
CREATE TABLE orders_dataset(
	order_id VARCHAR,
	customer_id VARCHAR,
	order_status VARCHAR,
	order_purchase_timestamp TIMESTAMP,
	order_approved_at TIMESTAMP,
	order_delivered_carrier_date TIMESTAMP,
	order_delivered_customer_date TIMESTAMP,
	order_estimated_delivery_date TIMESTAMP
);

-- ,product_id,product_category_name,product_name_lenght,product_description_lenght,product_photos_qty,product_weight_g,product_length_cm,product_height_cm,product_width_cm
CREATE TABLE product_dataset(
	id INT, 	
	product_id VARCHAR,
	product_category_name VARCHAR,
	product_name_lenght REAL,
	product_description_lenght REAL,
	product_photos_qty REAL,
	product_weight_g REAL,
	product_length_cm REAL,
	product_height_cm REAL,
	product_width_cm REAL
);
-- seller_id,"seller_zip_code_prefix","seller_city","seller_state"
CREATE TABLE sellers_dataset(
	seller_id VARCHAR, 	
	seller_zip_code_prefix VARCHAR,
	seller_city VARCHAR,
	seller_state VARCHAR
);


SELECT * FROM customers_dataset;
SELECT * FROM geolocation_dataset;
SELECT * FROM order_items_dataset;
SELECT * FROM order_payments_dataset;
SELECT * FROM order_reviews_dataset;
SELECT * FROM orders_dataset;
SELECT * FROM product_dataset;
SELECT * FROM sellers_dataset;

ALTER TABLE orders_dataset
ADD CONSTRAINT customer_id
FOREIGN KEY (customer_id) REFERENCES customers_dataset(customer_id);
-- 
ALTER TABLE customers_dataset
ADD CONSTRAINT geolocation_zip_code_prefix
FOREIGN KEY (customer_zip_code_prefix) REFERENCES geolocation_dataset(geolocation_zip_code_prefix);
-- 
ALTER TABLE sellers_dataset
ADD CONSTRAINT geolocation_zip_code_prefix
FOREIGN KEY (seller_zip_code_prefix) REFERENCES geolocation_dataset(geolocation_zip_code_prefix);
-- 
ALTER TABLE order_items_dataset
ADD CONSTRAINT seller_id
FOREIGN KEY (seller_id) REFERENCES sellers_dataset(seller_id);
-- 
ALTER TABLE order_items_dataset
ADD CONSTRAINT product_id
FOREIGN KEY (product_id) REFERENCES product_dataset(product_id);
-- 
ALTER TABLE order_reviews_dataset
ADD CONSTRAINT order_id
FOREIGN KEY (order_id) REFERENCES orders_dataset(order_id);
-- 
ALTER TABLE order_payments_dataset
ADD CONSTRAINT order_id
FOREIGN KEY (order_id) REFERENCES orders_dataset(order_id);
-- 
ALTER TABLE order_items_dataset
ADD CONSTRAINT order_id
FOREIGN KEY (order_id) REFERENCES orders_dataset(order_id);
