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
