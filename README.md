# 📊 Advanced SQL Analytics & Filtering: `thelook_ecommerce`

Dokumen ini berisi latihan SQL tingkat menengah yang berfokus pada analisis perilaku pelanggan (*Customer Insights*), pemfilteran hasil agregasi dengan klausa `HAVING`, penggunaan rentang nilai (`BETWEEN...AND`), serta penggabungan berbagai klausa SQL di Google BigQuery.

## 📌 Konsep Utama

1. **`WHERE` vs `HAVING`**:
   * **`WHERE`**: Memfilter baris data **sebelum** proses agregasi (`GROUP BY`). Hanya bekerja pada kolom non-agregat.
   * **`HAVING`**: Memfilter hasil **setelah** agregasi dijalankan. Digunakan khusus untuk kolom/nilai agregasi (seperti `COUNT`, `SUM`, `AVG`).
2. **`BETWEEN...AND`**: Digunakan untuk memfilter nilai dalam rentang tertentu (inklusif), baik numerik, teks, maupun tanggal.

---

## 📜 Kueri SQL dan Studi Kasus

### 1. Rentang Waktu & Ringkasan Transaksi

* **Rentang Tanggal Pemesanan**:
  Menghitung total pemesanan beserta batas tanggal terawal dan terbaru.

  ```sql
  -- Total: 124.452 transaksi (14 Jan 2019 s/d 29 Okt 2026)
  SELECT
    COUNT(order_id) AS total_orders,
    MIN(created_at) AS tgl_awal,
    MAX(created_at) AS tgl_akhir
  FROM bigquery-public-data.thelook_ecommerce.orders;
  ```

---

### 2. Analisis Perilaku Pelanggan & Demografi

* **Total Pemesanan berdasarkan Gender**:

  ```sql
  SELECT 
    gender,
    COUNT(order_id) AS total_orders
  FROM bigquery-public-data.thelook_ecommerce.orders
  GROUP BY gender
  ORDER BY total_orders DESC;
  ```

* **Identifikasi Pelanggan Paling Royal (Most Loyal Customer)**:
  Mencari `user_id` dengan transaksi terbanyak (maksimal 4 transaksi per pengguna).

  ```sql
  -- 1. Cari user_id dengan total order terbanyak
  SELECT 
    user_id,
    COUNT(order_id) AS total_orders
  FROM bigquery-public-data.thelook_ecommerce.orders
  GROUP BY user_id
  ORDER BY total_orders DESC;

  -- 2. Detail informasi profil pengguna royal (misal: ID = 2594 -> Nama: Darryl)
  SELECT *
  FROM bigquery-public-data.thelook_ecommerce.users
  WHERE id = 2594;
  ```

* **Distribusi Jumlah Item per Pesanan (`num_of_item`)**:
  Analisis operasional untuk mengetahui preferensi kuantitas pembelian pelanggan.

  ```sql
  SELECT 
    num_of_item,
    COUNT(order_id) AS total_orders
  FROM bigquery-public-data.thelook_ecommerce.orders
  GROUP BY num_of_item
  ORDER BY total_orders DESC;
  ```

* **Analisis Pemesanan yang Dikembalikan (*Returned Orders*)**:
  Membandingkan tingkat pengembalian barang dan rata-rata item per pesanan antara pria dan wanita.

  ```sql
  SELECT
    gender,
    COUNT(order_id) AS total_order_returned,
    ROUND(AVG(num_of_item), 2) AS rata2_item 
  FROM bigquery-public-data.thelook_ecommerce.orders
  WHERE status = 'Returned'
  GROUP BY gender
  ORDER BY total_order_returned DESC;
  ```

---

### 3. Pemfilteran Hasil Agregasi (`HAVING`) & Rentang (`BETWEEN`)

* **Filter Demografi Umur (`HAVING`)**:
  Menampilkan kelompok usia pengguna yang memiliki jumlah lebih dari 1.700 orang.

  ```sql
  SELECT
    age,
    COUNT(id) AS jumlah_users
  FROM bigquery-public-data.thelook_ecommerce.users 
  GROUP BY age
  HAVING jumlah_users > 1700
  ORDER BY jumlah_users DESC;
  ```

* **Filter Kategori Produk Terbanyak (`HAVING`)**:
  Menampilkan kategori produk yang memiliki lebih dari 500 unit barang.

  ```sql
  SELECT
    category,
    COUNT(id) AS total_product
  FROM bigquery-public-data.thelook_ecommerce.products
  GROUP BY category
  HAVING total_product > 500
  ORDER BY total_product DESC;
  ```

* **Filter Kategori Produk dalam Rentang (`HAVING` + `BETWEEN...AND`)**:
  Menampilkan kategori produk yang jumlah barangnya di antara 500 hingga 1.000 unit.

  ```sql
  SELECT
    category,
    COUNT(id) AS total_product
  FROM bigquery-public-data.thelook_ecommerce.products
  GROUP BY category
  HAVING total_product BETWEEN 500 AND 1000
  ORDER BY total_product DESC;
  ```

---

### 4. Studi Kasus Kompleks: Pengguna Usia Muda di AS

* **Studi Kasus**:
  Di negara **United States**, negara bagian (*state*) mana yang memiliki pengguna berusia 18–25 tahun terbanyak? Tampilkan Top 10.

  ```sql
  SELECT
    state,
    COUNT(id) AS total_pengguna
  FROM bigquery-public-data.thelook_ecommerce.users
  WHERE country = 'United States'
    AND age BETWEEN 18 AND 25
  GROUP BY state
  ORDER BY total_pengguna DESC
  LIMIT 10;
  ```

---

## 📌 Catatan Penting (Key Takeaways)

1. **Urutan Eksekusi Kueri SQL**:
   `FROM` ➡️ `WHERE` ➡️ `GROUP BY` ➡️ `HAVING` ➡️ `SELECT` ➡️ `ORDER BY` ➡️ `LIMIT`
2. **`HAVING` membutuhkan `GROUP BY`**: Klausa `HAVING` hanya dapat digunakan jika kueri menggunakan `GROUP BY` atau fungsi agregasi.
3. **Penggunaan `BETWEEN...AND`**: Bersifat *inclusive*, artinya batas bawah dan batas atas (misal: 18 dan 25) ikut dihitung dalam kriteria filter.
