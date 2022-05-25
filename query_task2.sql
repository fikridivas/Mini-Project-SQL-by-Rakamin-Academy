-- soal 1
SELECT
	tahun,
	ROUND(AVG(monthly_active_user), 2) AS MAU
FROM(
	SELECT
		date_part('year', orders.order_purchase_timestamp) AS tahun,
		date_part('month', orders.order_purchase_timestamp) AS bulan,
		COUNT(DISTINCT customers.customer_unique_id) AS monthly_active_user
	FROM
		orders_dataset orders
	JOIN customers_dataset customers
	ON customers.customer_id = orders.customer_id
	GROUP BY 1,2
) AS cnt_mau
GROUP BY 1;

-- soal 2
SELECT
	date_part('year', first_order_time) AS tahun,
	COUNT(*) AS total_customers
FROM(
	SELECT
		customers.customer_unique_id,
		MIN(orders.order_purchase_timestamp) AS first_order_time
	FROM
		customers_dataset customers
	JOIN
		orders_dataset orders
	ON customers.customer_id = orders.customer_id
	GROUP BY 1
) cnt_first_order
GROUP BY 1
ORDER BY tahun;

-- soal 3
SELECT
	tahun,
	COUNT(customer_unique_id) AS total_repeat_customers
FROM(
	SELECT
		date_part('year', orders.order_purchase_timestamp) AS tahun,
		customers.customer_unique_id,
		count(*) AS total_orders
	FROM
		orders_dataset orders
	JOIN
		customers_dataset customers
	ON orders.customer_id = customers.customer_id
	GROUP BY 1,2
	HAVING count(*) > 1
) repeat_order_total
GROUP BY 1
ORDER BY 1;

-- soal 4
SELECT
	tahun,
	ROUND(AVG(total_orders),2) AS average_order
FROM(
	SELECT
		date_part('year', orders.order_purchase_timestamp) AS tahun,
		customers.customer_unique_id,
		count(*) AS total_orders
	FROM
		orders_dataset orders
	JOIN customers_dataset customers
	ON customers.customer_id = orders.customer_id
	GROUP BY 1,2
) AS cnt_total_orders
GROUP BY 1
ORDER BY 1;

-- soal 5
WITH calculate_mau AS(
	SELECT
	tahun,
	ROUND(AVG(monthly_active_user), 2) AS MAU
	FROM(
		SELECT
			date_part('year', orders.order_purchase_timestamp) AS tahun,
			date_part('month', orders.order_purchase_timestamp) AS bulan,
			COUNT(DISTINCT customers.customer_unique_id) AS monthly_active_user
		FROM
			orders_dataset orders
		JOIN customers_dataset customers
		ON customers.customer_id = orders.customer_id
		GROUP BY 1,2
	) AS cnt_mau
	GROUP BY 1
),
calculate_new_customers AS (
	SELECT
		date_part('year', first_order_time) AS tahun,
		COUNT(*) AS total_customers
	FROM(
		SELECT
			customers.customer_unique_id,
			MIN(orders.order_purchase_timestamp) AS first_order_time
		FROM
			customers_dataset customers
		JOIN
			orders_dataset orders
		ON customers.customer_id = orders.customer_id
		GROUP BY 1
	) cnt_first_order
	GROUP BY 1
),
calculate_repeat_order AS (
	SELECT
		tahun,
		COUNT(customer_unique_id) AS total_repeat_customers
	FROM(
		SELECT
			date_part('year', orders.order_purchase_timestamp) AS tahun,
			customers.customer_unique_id,
			count(*) AS total_orders
		FROM
			orders_dataset orders
		JOIN
			customers_dataset customers
		ON orders.customer_id = customers.customer_id
		GROUP BY 1,2
		HAVING count(*) > 1
	) repeat_order_total
	GROUP BY 1
),
calculate_average_orders_customer AS (
	SELECT
		tahun,
		ROUND(AVG(total_orders),2) AS average_order
	FROM(
		SELECT
			date_part('year', orders.order_purchase_timestamp) AS tahun,
			customers.customer_unique_id,
			count(*) AS total_orders
		FROM
			orders_dataset orders
		JOIN customers_dataset customers
		ON customers.customer_id = orders.customer_id
		GROUP BY 1,2
	) AS cnt_total_orders
	GROUP BY 1
)

SELECT
	mau.tahun,
	mau.MAU,
	cal_new_cust.total_customers,
	cal_repeat_ord.total_repeat_customers,
	cal_avg_cust.average_order
FROM
	calculate_mau mau
JOIN calculate_new_customers cal_new_cust ON mau.tahun = cal_new_cust.tahun
JOIN calculate_repeat_order cal_repeat_ord ON mau.tahun = cal_repeat_ord.tahun
JOIN calculate_average_orders_customer cal_avg_cust ON mau.tahun = cal_avg_cust.tahun