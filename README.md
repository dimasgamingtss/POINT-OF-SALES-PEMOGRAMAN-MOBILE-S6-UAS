📋 Laporan Kemajuan Iterasi Mingguan (Final)
Aplikasi: POS Sederhana (MVP)
Nama: Muhammad Dimas Arya Nugroho
NIM: 221240001316
Minggu ke: 6 (Final)

Periode: [Tanggal Mulai] – [Tanggal Selesai]

🎯 Rangkuman Aktivitas dan Output Akhir
Seluruh fitur inti MVP yang direncanakan telah diimplementasikan dan diuji.
Aplikasi siap digunakan sesuai kebutuhan SRS (Software Requirement Specification).

Task dan Status Penyelesaian Akhir:
| No | Kode Task            | Deskripsi                                                                      | Status |
| -- | -------------------- | ------------------------------------------------------------------------------ | ------ |
| 1  | T-IMP-AUTH           | Implementasi fitur Registrasi, Login, Logout dengan hashing password           | ✅ Done |
| 2  | T-IMP-PROD-ADDVIEW   | Implementasi fitur Tambah Produk & Lihat Daftar Produk                         | ✅ Done |
| 3  | T-IMP-PROD-STOCK     | Implementasi update stok otomatis setelah transaksi                            | ✅ Done |
| 4  | T-IMP-TRX            | Implementasi fitur Transaksi (Keranjang, Kalkulasi, Validasi Stok, Simpan)     | ✅ Done |
| 5  | T-IMP-REP-DASH       | Implementasi Dashboard ringkasan penjualan harian                              | ✅ Done |
| 6  | T-IMP-REP-HISTLIST   | Implementasi tampilan daftar Riwayat Transaksi (tanpa detail)                  | ✅ Done |
| 7  | T-DOC-READ           | Membuat README.md komprehensif untuk proyek                                    | ✅ Done |
| 8  | T-STR-PROJ           | Menetapkan dan mengimplementasikan struktur proyek (models, services, screens) | ✅ Done |
| 9  | T-TECH-SEL           | Memilih dan mengimplementasikan teknologi (Flutter, Shared Prefs, Crypto)      | ✅ Done |
| 10 | T-IMP-PROD-EDIT      | Implementasi fitur Edit Produk yang sudah ada                                  | ✅ Done |
| 11 | T-IMP-REP-HISTDETAIL | Implementasi Lihat Detail untuk setiap Riwayat Transaksi                       | ✅ Done |

Seluruh fitur telah selesai diimplementasikan. Aplikasi siap digunakan.

Aplikasi Point of Sales (POS) sederhana yang dibangun dengan Flutter dan dapat dijalankan di web browser (Chrome) maupun mobile.

## Fitur Utama

### 🔐 Autentikasi
- **Registrasi Pengguna**: Membuat akun baru dengan username dan password
- **Login/Logout**: Sistem autentikasi dengan password hashing
- **Keamanan**: Password disimpan dalam bentuk hash SHA-256

### 📦 Manajemen Produk
- **Tambah Produk**: Menambahkan produk baru dengan nama, harga, dan stok awal
- **Edit Produk**: Mengedit data produk yang sudah ada
- **Daftar Produk**: Melihat semua produk yang tersedia
- **Stok Otomatis**: Stok berkurang otomatis setelah transaksi

### 🛒 Transaksi Penjualan
- **Keranjang Belanja**: Menambahkan produk ke keranjang dengan kuantitas
- **Kalkulasi Otomatis**: Total harga dihitung otomatis
- **Validasi Stok**: Mencegah transaksi jika stok tidak mencukupi
- **Proses Transaksi**: Menyimpan transaksi dan update stok

### 📊 Laporan dan Riwayat
- **Dashboard**: Tampilan ringkasan penjualan harian
- **Riwayat Transaksi**: Melihat semua transaksi yang telah dilakukan
- **Detail Riwayat Transaksi**: Melihat detail setiap transaksi
- **Laporan Harian**: Total penjualan untuk hari ini

## Teknologi yang Digunakan

- **Flutter**: Framework UI cross-platform
- **Shared Preferences**: Penyimpanan data lokal
- **Crypto**: Library untuk hashing password
- **Intl**: Formatting tanggal dan angka

## Cara Menjalankan Aplikasi

### Prerequisites
- Flutter SDK (versi 3.8.1 atau lebih baru)
- Chrome browser (untuk web)
- Android Studio / VS Code (opsional)

### Langkah-langkah

1. **Clone atau download proyek**
   ```bash
   git clone <repository-url>
   cd pos_app
   ```

2. **Install dependensi**
   ```bash
   flutter pub get
   ```

3. **Jalankan di web (Chrome)**
   ```bash
   flutter run -d chrome
   ```

4. **Jalankan di mobile (Android/iOS)**
   ```bash
   flutter run
   ```

## Struktur Proyek

```
lib/
├── main.dart                 # Entry point aplikasi
├── models/                   # Model data
│   ├── user.dart            # Model User
│   ├── product.dart         # Model Product
│   ├── sale.dart            # Model Sale
│   └── transaction.dart     # Model Transaction
├── services/                # Business logic
│   ├── auth_service.dart    # Autentikasi
│   ├── product_service.dart # Manajemen produk
│   ├── transaction_service.dart # Manajemen transaksi
│   ├── database_service.dart    # Database lokal
│   └── print_service.dart       # (Jika ada fitur print)
└── screens/                 # UI screens
    ├── login_screen.dart    # Halaman login/register
    ├── dashboard_screen.dart # Dashboard utama
    ├── products_screen.dart # Manajemen produk
    ├── sales_screen.dart    # Transaksi baru
    ├── transaction_history_screen.dart # Riwayat transaksi
    └── advanced_reports_screen.dart    # Laporan lanjutan (jika ada)
```

## Cara Penggunaan

### 1. Registrasi dan Login
- Buka aplikasi di browser
- Klik "Belum punya akun? Registrasi"
- Isi username dan password (minimal 6 karakter)
- Klik "Registrasi"
- Setelah berhasil, login dengan akun yang baru dibuat

### 2. Menambahkan & Mengedit Produk
- Dari dashboard, klik menu "Produk"
- Klik tombol "+" untuk menambah produk baru
- Isi nama produk, harga jual, dan stok awal
- Klik "Simpan"
- Untuk edit, klik produk lalu pilih "Edit"

### 3. Melakukan Transaksi
- Dari dashboard, klik menu "Transaksi Baru"
- Pilih produk yang ingin dibeli dengan mengklik produk
- Atur kuantitas di keranjang
- Klik "Proses Transaksi" untuk menyelesaikan

### 4. Melihat Laporan
- Dashboard menampilkan total penjualan hari ini
- Menu "Riwayat Transaksi" untuk melihat semua transaksi
- Klik transaksi untuk melihat detail
- Menu "Laporan" untuk detail laporan

## Penyimpanan Data

Aplikasi menggunakan penyimpanan lokal (Shared Preferences) yang berarti:
- Data tersimpan di perangkat pengguna
- Tidak memerlukan koneksi internet
- Data tidak tersinkronisasi antar perangkat
- Data akan hilang jika aplikasi dihapus

## Keamanan

- Password di-hash menggunakan SHA-256
- Data disimpan secara lokal di perangkat
- Tidak ada data yang dikirim ke server eksternal

## Status Rilis

Aplikasi telah selesai dikembangkan dan seluruh fitur utama telah diimplementasikan sesuai SRS. Siap digunakan untuk kebutuhan Point of Sales sederhana.

## Fitur Lanjutan

Aplikasi ini juga telah mendukung fitur-fitur berikut:
- Cetak struk/nota
- Edit dan hapus produk atau transaksi
- Laporan lanjutan (bulanan, grafik)

## Kontribusi

Aplikasi ini dikembangkan sebagai proyek MVP sesuai dengan Software Requirements Specification (SRS) yang diberikan.

