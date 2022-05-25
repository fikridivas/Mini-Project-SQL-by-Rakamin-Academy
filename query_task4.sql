-- Menampilkan jumlah penggunaan masing-masing tipe pembayaran secara all time diurutkan 
-- dari yang terfavorit (Hint: Perhatikan struktur (kolom-kolom apa saja) dari tabel akhir yang ingin didapatkan)
SELECT
	payment_type,
	COUNT(*) AS total_users
FROM
	order_payments_dataset
GROUP BY 1
ORDER BY 2 DESC;

-- Menampilkan detail informasi jumlah penggunaan masing-masing tipe pembayaran untuk setiap tahun 
-- (Hint: Perhatikan struktur (kolom-kolom apa saja) dari tabel akhir yang ingin didapatkan)
WITH cnt_payment_type AS (
	SELECT
		date_part('year', orders.order_purchase_timestamp) AS year,
		order_payments.payment_type,
		COUNT(*) AS total_users
	FROM order_payments_dataset AS order_payments
	JOIN orders_dataset AS orders ON order_payments.order_id = orders.order_id
	GROUP BY 1,2
)

SELECT
	payment_type,
	sum(case when year = '2016' then total_users else 0 end) as "2016",
	sum(case when year = '2017' then total_users else 0 end) as "2017",
	sum(case when year = '2018' then total_users else 0 end) as "2018"
FROM cnt_payment_type
GROUP BY 1;