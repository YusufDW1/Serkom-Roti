# Roti Saku

Aplikasi mobile Flutter untuk pemesanan roti online yang dibangun untuk asesi Junior Mobile Programmer.

## Deskripsi

Roti Saku memungkinkan pelanggan melihat katalog roti/kue, melakukan pembelian melalui keranjang belanja, serta mencatat lokasi pengiriman via GPS. Admin dapat melihat seluruh pesanan dan mengubah status pesanan secara realtime.

## Fitur Utama

- Katalog produk roti/kue beserta harga
- Keranjang belanja dengan update quantity dan remove item
- Checkout dengan pengambilan koordinat GPS
- Penyimpanan pesanan ke Firebase Firestore
- Admin dashboard untuk mengelola status pesanan
- Realtime sync status pesanan antara customer dan admin

## Teknis

- Framework: Flutter
- Bahasa: Dart
- State Management: GetX
- Local Database: SQLite (`sqflite`)
- Remote Database: Firebase Firestore
- Autentikasi: Firebase Auth
- Location Services: Geolocator

## Struktur Project

```
lib/
├── main.dart
├── app/
├── features/
│   ├── home/
│   ├── cart/
│   ├── order/
│   └── auth/
├── services/
│   ├── auth_service.dart
│   ├── database_helper.dart
│   ├── firebase_service.dart
│   └── location_service.dart
├── theme/
└── utils/
```

## Menjalankan Project

1. Install Flutter SDK
2. Jalankan:
   ```bash
   flutter pub get
   flutter run
   ```

## Build APK

```bash
flutter build apk --release
```

Output:
```
build\app\outputs\flutter-apk\app-release.apk
```

## Database

- SQLite: menyimpan data cart secara lokal di device
- Firebase Firestore: menyimpan data pesanan secara permanen

## Dokumentasi Screenshot

| No | Fitur | Tujuan |
|----|-------|--------|
| 1 | Login | Autentikasi customer/admin |
| 2 | Registrasi | Pembuatan akun baru |
| 3 | Home/Menu | Katalog produk dan navigasi utama |
| 4 | Detail Produk | Informasi roti, harga, dan aksi pesan |
| 5 | Keranjang | Daftar item yang akan dibeli |
| 6 | Checkout | Form pesan dan pengambilan GPS |
| 7 | Pesanan Berhasil | Konfirmasi setelah checkout |
| 8 | Histori Pesanan | Riwayat pesanan customer |
| 9 | Admin Dashboard | Manajemen status pesanan |
| 10 | Profil | Informasi akun dan logout |
