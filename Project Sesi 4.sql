-- Berapa Total Order yang tercatat 124.452 data dari 14 jan 2019 s/d 29 okt 2026

SELECT
 COUNT(order_id) AS total_orders,
 MIN (created_at) AS tgl_awal,
 MAX (created_at) AS tgl_akhir
FROM bigquery-public-data.thelook_ecommerce.orders;

--Total order berdasarkan gender
SELECT 
 gender,  -- non agregat
 COUNT(order_id) AS total_orders
FROM bigquery-public-data.thelook_ecommerce.orders
GROUP BY gender
ORDER BY total_orders DESC;

-- Siapa pelanggan paling royal/transaksi paling banyak, (tiap orang paling banyak melakukan 4 transaksi)
SELECT 
 user_id,  -- non agregat
 COUNT(order_id) AS total_orders
FROM bigquery-public-data.thelook_ecommerce.orders
GROUP BY user_id
ORDER BY total_orders DESC;

--Nama pelanggan royal Siapa? Darryl

SELECT 
 *
FROM bigquery-public-data.thelook_ecommerce.users
WHERE id = 2594;

--Tim operasional ingin tahu apakah pelanggan membeli 1 item atau beberapa item sekaligus
-- Hitung jumlah order untuk setiap nilai num_of_item

SELECT 
 num_of_item,  -- non agregat
 COUNT(order_id) AS total_orders
FROM bigquery-public-data.thelook_ecommerce.orders
GROUP BY num_of_item
ORDER BY total_orders DESC;

SELECT
 age,
 COUNT (id) AS jumlah_users
FROM bigquery-public-data.thelook_ecommerce.users
GROUP BY age
ORDER BY jumlah_users DESC;

--Berapa jumlah order yang dikembalikan (returned) oleh pelanggan pria dibandingkan wanita
--dan berapa rata-rata jumlah item per order yang dikmebalikan
SELECT
 gender,
 COUNT (order_id) AS total_order_returned,
 AVG (num_of_item) AS rata2_item 
FROM bigquery-public-data.thelook_ecommerce.orders
WHERE status = 'Returned'
GROUP BY gender
ORDER BY total_order_returned DESC;

SELECT
 DISTINCT status
FROM bigquery-public-data.thelook_ecommerce.orders;

SELECT
 *
FROM bigquery-public-data.thelook_ecommerce.orders
WHERE status = 'Returned';

-- Having untuk filter untuk kolom agregasi sedangkan WHERE hanya untuk kolom non agregat
SELECT
 age,
 COUNT (id) AS jumlah_users
FROM bigquery-public-data.thelook_ecommerce.users 
GROUP BY age
HAVING jumlah_users > 1700
ORDER BY jumlah_users DESC;

--ambilkan list kategori produk yang memiliki produk di atas 500 produk

SELECT
 category,
 count(id) total_product
FROM bigquery-public-data.thelook_ecommerce.products
GROUP BY category
HAVING total_product > 500
ORDER BY total_product DESC;

-- jika rentang pakai BETWEEN AND

SELECT
 category,
 count(id) total_product
FROM bigquery-public-data.thelook_ecommerce.products
GROUP BY category
HAVING total_product BETWEEN 500 AND 1000
ORDER BY total_product DESC;

--Di Amerika Serikat, negara bagian (state) mana yang memiliki pengguna usia 18-25 tahun terbanyak?
--Tampilkan 10 state teratas

SELECT
 state,
 count(id) total_pengguna
FROM bigquery-public-data.thelook_ecommerce.users
WHERE country = 'United States'AND
 age BETWEEN 18 AND 25
GROUP BY state
ORDER BY total_pengguna DESC
LIMIT 10;
