-- Membuat tabel yang berisi informasi pendapatan/revenue perusahaan total 
-- untuk masing-masing tahun (Hint: Revenue adalah harga barang dan juga biaya kirim. 
-- Pastikan juga melakukan filtering terhadap order status yang tepat untuk menghitung pendapatan)

CREATE TABLE total_revenue_company_per_year AS
SELECT
	date_part('year', orders.order_purchase_timestamp) AS year,
	SUM(revenue_order) AS revenue
FROM(
	SELECT
		order_id,
		SUM(price+freight_value) AS revenue_order
	FROM
		order_items_dataset
	GROUP BY 1
) cal_revenue_order
JOIN
	orders_dataset AS orders
ON cal_revenue_order.order_id = orders.order_id
WHERE
	orders.order_status = 'delivered'
GROUP BY 1
ORDER BY 1;

-- Membuat tabel yang berisi informasi jumlah cancel order total untuk masing-masing tahun 
-- (Hint: Perhatikan filtering terhadap order status yang tepat untuk menghitung jumlah cancel order)
CREATE TABLE total_order_cancel_per_year AS
SELECT
	date_part('year', order_purchase_timestamp) AS year,
	COUNT(*) AS total_cancel_order
FROM
	orders_dataset
WHERE
	order_status = 'canceled'
GROUP BY 1;

-- Membuat tabel yang berisi nama kategori produk yang memberikan pendapatan total tertinggi 
-- untuk masing-masing tahun (Hint: Perhatikan penggunaan window function dan juga filtering yang dilakukan)
CREATE TABLE top_product_category_per_year AS
SELECT
	year,
	product_category_name,
	revenue_product
FROM(
	SELECT
		date_part('year', orders.order_purchase_timestamp) AS year,
		products.product_category_name,
		SUM(order_items.price+order_items.freight_value) AS revenue_product,
		RANK() OVER (PARTITION BY date_part('year', orders.order_purchase_timestamp) ORDER BY SUM(order_items.price+order_items.freight_value) DESC) AS the_rank
	FROM
		order_items_dataset AS order_items
	JOIN
		orders_dataset AS orders ON order_items.order_id = orders.order_id
	JOIN
		product_dataset AS products ON order_items.product_id = products.product_id
	WHERE orders.order_status = 'delivered'
	GROUP BY 1,2
) AS calt_revenue_product
WHERE the_rank = 1;

-- Membuat tabel yang berisi nama kategori produk yang memiliki jumlah cancel order terbanyak 
-- untuk masing-masing tahun (Hint: Perhatikan penggunaan window function dan juga filtering yang dilakukan)
CREATE TABLE top_product_category_canceled AS
SELECT
	year,
	product_category_name,
	total_product_cancel
FROM(
	SELECT
		date_part('year', orders.order_purchase_timestamp) AS year,
		products.product_category_name,
		COUNT(*) AS total_product_cancel,
		RANK() OVER (PARTITION BY date_part('year', orders.order_purchase_timestamp) ORDER BY COUNT(*) DESC) AS the_rank2
	FROM
		order_items_dataset AS order_items
	JOIN
		orders_dataset AS orders ON order_items.order_id = orders.order_id
	JOIN
		product_dataset AS products ON order_items.product_id = products.product_id
	WHERE orders.order_status = 'canceled'
	GROUP BY 1,2
) AS calt_revenue_cancel_product
WHERE the_rank2 = 1;

-- Menggabungkan informasi-informasi yang telah didapatkan ke dalam satu tampilan tabel 
-- (Hint: Perhatikan teknik join yang dilakukan serta kolom-kolom yang dipilih)
SELECT
	a.year,
	a.revenue AS total_revenue,
	b.total_cancel_order AS number_cancel_order,
	c.product_category_name AS top_product_category_name,
	c.revenue_product AS revenue_top_product,
	d.product_category_name AS top_product_category_name_canceled,
	d.total_product_cancel AS num_top_product_category_canceled
FROM
	total_revenue_company_per_year AS a
JOIN
	total_order_cancel_per_year b ON a.year = b.year
JOIN
	top_product_category_per_year c ON a.year = c.year
JOIN
	top_product_category_canceled d ON a.year = d.year;
	
	