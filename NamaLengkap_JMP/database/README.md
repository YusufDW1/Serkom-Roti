# Database Documentation

## SQLite Database (Local)
- Nama file: roti_saku_cart.db
- Lokasi asli (emulator): 
  /data/data/com.example.roti_saku/app_flutter/roti_saku_cart.db
- Cara backup via ADB:
  adb shell "run-as com.example.roti_saku cp /data/data/com.example.roti_saku/app_flutter/roti_saku_cart.db /sdcard/roti_saku_cart.db"
  adb pull /sdcard/roti_saku_cart.db .
- Schema: cart_items (productId, name, price, quantity, imageUrl, createdAt)

## Firebase Firestore (Remote)
- Collection: /orders
- Dokument berisi: customerName, customerId, items, total, latitude, longitude, status, createdAt
- Rules untuk testing: allow read, write: if true;
- Konfigurasi: Lihat firebase_options.dart

##-file digunakan:
- google-services.json (Android)
- firebase_options.dart (Flutter)
- firebase.json (Firestore rules)
