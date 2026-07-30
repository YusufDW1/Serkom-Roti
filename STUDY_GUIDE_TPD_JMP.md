# 📚 Study Guide — Roti Saku App (TPD JMP Prep)

Catatan belajar lengkap untuk persiapan TPD / JMP sesuai rubrik BNSP yang diambil dari file `SOAL TPD JMP.pdf`.

---

## 1. Ringkasan Proyek

Roti Saku adalah aplikasi mobile berbasis Flutter untuk **pemesanan roti online** yang mencakup katalog produk, keranjang belanja, checkout dengan lokasi GPS, penyimpanan data di server (Firebase Firestore), dan panel admin untuk melihat pesanan.

### Teknologi Utama
| Layer | Teknologi |
|-------|-----------|
| Framework Mobile | Flutter (cross-platform) |
| State Management | GetX |
| Local Database | SQLite (`sqflite`) |
| Remote Database | Firebase Firestore |
| Location Services | `geolocator` plugin |
| Auth | Firebase Auth |
| UI Pattern | Material Design 3 + Google Fonts (Poppins) |

---

## 2. Kasus BNSP — What They Ask

Berdasarkan halaman 1 `SOAL TPD JMP.pdf`:

> Sebuah perusahaan roti meminta pembuatan aplikasi mobile untuk berjualan roti online yang menampilkan daftar roti/kue beserta harga, memungkinkan pembelian langsung, mencatat data pelanggan beserta koordinat rumah via GPS, menyimpan data di server, dan memungkinkan admin melihat data pemesan.

### 5 Fitur Wajib
1. **Katalog roti/kue + harga** ✅
2. **Pembelian langsung** ✅
3. **Data pelanggan + koordinat GPS** ✅
4. **Penyimpanan data di server** ✅
5. **Admin melihat data pemesan** ✅

---

## 3. Katalog Data &entry Requirements

### 3.1 Data Produk (Customer-facing)
| Field | Tipe | Diimplementasikan? | Catatan |
|-------|------|--------------------|-----|
| Nama produk | String | ✅ | `BakeryItem.name` |
| Harga | int/double | ✅ | `BakeryItem.price` |
| Gambar | URL/asset | ✅ | `BakeryItem.imageUrl` |
| Kategori | String | ✅ | `BakeryItem.category` |
| Deskripsi | String | ✅ | `BakeryItem.description` |

### 3.2 Data Pesanan (Customer + Admin)
| Field | Tipe | Diimplementasikan? | Catatan |
|-------|------|--------------------|-----|
| Nama pelanggan | String | ✅ | `OrderModel.customerName` |
| ID pelanggan | String (nullable) | ✅ | `OrderModel.customerId` |
| Item pesanan | List<OrderItem> | ✅ | nama, qty, harga, subtotal |
| Total | double | ✅ | `OrderModel.total` |
| Latitude | double | ✅ | `OrderModel.latitude` |
| Longitude | double | ✅ | `OrderModel.longitude` |
| Status | String | ✅ | `pending`, `processing`, `completed` |
| Timestamp | String | ✅ | disimpan via `toIso8601String()` |

### 3.3 Data Cart (Local only)
| Field | Tipe | Diimplementasikan? | Catatan |
|-------|------|--------------------|-----|
| productId | TEXT | ✅ | sebagai PK unik |
| name | TEXT | ✅ | |
| price | REAL | ✅ | |
| quantity | INTEGER | ✅ | default 1 |
| imageUrl | TEXT | ✅ | untuk tampilkan di cart |
| createdAt | TEXT | ✅ | `DateTime.now().toIso8601String()` |

---

## 4. Arsitektur Aplikasi

```
lib/
├── main.dart                          # Entry point + routes
├── theme/
│   └── app_theme.dart                 # Design tokens (colors, typography)
├── features/
│   ├── home/
│   │   ├── controllers/
│   │   │   └── home_controller.dart   # Load mock products, add-to-cart
│   │   └ views/
│   │       ├── home_view.dart         # Product grid/list
│   │       └── detail_view.dart       # Product detail screen
│   ├── cart/
│   │   ├── controllers/
│   │   │   └── cart_controller.dart   # Cart CRUD + checkout + GPS
│   │   └ views/
│   │       └── cart_controller.dart   # Cart items list, checkout form
│   ├── order/
│   │   ├── controllers/
│   │   │   └── order_controller.dart  # Realtime order stream + status update
│   │   ├── models/
│   │   │   └── order_model.dart       # Order + OrderItem model
│   │   ├ views/
│   │   │   ├── order_history_view.dart    # Customer order list
│   │   │   └── order_success_view.dart    # Post-checkout confirmation
│   │   └ widgets/
│   │       └── order_card.dart        # Shared order card UI
│   └── auth/
│       └ views/
│           ├── login_view.dart        # Customer login
│           ├── register_view.dart     # Customer register
│           └── admin_dashboard_view.dart  # Admin order management
├── services/
│   ├── database_helper.dart           # SQLite cart persistence
│   ├── location_service.dart          # Geolocator wrapper
│   ├── firebase_service.dart          # Firestore CRUD
│   └── auth_service.dart              # Firebase Auth
└── utils/
    └── formatters.dart                # Currency formatting, etc.
```

---

## 5. Alur Demo yang Wajib Bisa Dijenaskan

### 5.1 Customer Flow
1. Buka app → Home screen menampilkan daftar roti dengan gambar + harga
2. Tap produk → Detail screen → deskripsi lengkap + tombol "Tambah ke Keranjang"
3. Buka cart → lihat item, update qty, hapus item, lihat total
4. Tap "Checkout" → isi Nama Pemesan → lanjut
5. App meminta izin GPS → tampil dialog penjelasan
6. Jika diizinkan → koordinat dicatat → submit ke Firebase
7. Cart dikosongkan → redirect ke Order Success screen
8. Tab History → lihat daftar pesanan sendiri dengan GPS

### 5.2 Admin Flow
1. Login ke mode admin
2. Admin dashboard menampilkan semua pesanan
3. Setiap pesanan menunjukkan:
   - ID pesanan
   - Nama customer
   - Item + qty
   - Total harga
   - Koordinat GPS
   - Status badge
4. Admin bisa ubah status:
   - `pending` → tombol **Proses** (ubah ke `processing`)
   - `pending` → tombol **Selesai** (ubah ke `completed`)
   - `processing` → tombol **Tandai Selesai** (ubah ke `completed`)
5. Customer melihat status berubah realtime di history

---

## 6. Mapping ke Unit Kompetensi BNSP

### Unit J.612000.001.01 — Platform & Bahasa Pemrograman Mobile
| Poin | Kebutuhan | Implementasi |
|------|-----------|--------------|
| Menunjukkan jenis platform OS mobile | Cross-platform app | Flutter → Android/iOS |
| Menentukan platform sesuai kebutuhan | Memilih mobile framework | Flutter dipilih karena cocok untuk e-commerce |

### Unit J.612000.003.01 — Database & Data Persistence
| Poin | Kebutuhan | Implementasi |
|------|-----------|--------------|
| Internal storage | Cart tersimpan lokal | SQLite via `sqflite` |
| External storage | Order tersimpan di server | Firebase Firestore |
| SQLite design | Schema `cart_items` | `productId TEXT PK`, `name`, `price`, `quantity`, `imageUrl`, `createdAt` |
| Model layer | Data class | `BakeryItem`, `CartItemModel`, `OrderModel`, `OrderItem` |

### Unit J.612000.006.01 — LBS/GPS/Navigasi
| Poin | Kebutuhan | Implementasi |
|------|-----------|--------------|
| Lokasi dengan mobile computing | Akses GPS perangkat | `Geolocator.isLocationServiceEnabled()` |
| LBS | Mendapatkan lokasi pengguna | `Geolocator.requestPermission()` + `getCurrentPosition()` |
| GPS | Koordinat presisi | `desiredAccuracy: LocationAccuracy.high` |
| Aplikasi navigasi | Kontekstual untuk pengiriman | Koordinat disimpan ke order untuk delivery |

### Unit J.612000.007.01 — Mobile Interface
| Poin | Kebutuhan | Implementasi |
|------|-----------|--------------|
| Tools perancangan | UI framework | Flutter Material + Google Fonts |
| Informasi layer | Halaman yang sesuai | Home, Detail, Cart, Checkout, History, Admin |
| Estetika | Desain menarik | Poppins font, flour/cinnamon color palette |

---

## 7. Database Schema

### 7.1 SQLite (Local — Cart)
```sql
CREATE TABLE cart_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  productId TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  price REAL NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  imageUrl TEXT,
  createdAt TEXT NOT NULL
);
```

### 7.2 Firestore (Remote — Orders)
```
/orders/{orderId}
  ├── customerName: string
  ├── customerId: string | null
  ├── items: Array<{ productId, name, price, quantity, subtotal }>
  ├── total: number
  ├── latitude: number
  ├── longitude: number
  ├── status: "pending" | "processing" | "completed"
  └── createdAt: timestamp (server-side)

/customers/{customerId}/orders/{orderId}
  └── (mirror order untuk customer-specific queries)
```

---

## 8. Permission & Privacy Flow

### Android Manifest
```xml
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

### Runtime Permission Flow
```
User tap Checkout
    ↓
Check: Location service enabled?
    ├─ NO → Dialog "Lokasi mati" → Buka Pengaturan
    └─ YES → lanjut
         ↓
Check: Permission granted?
    ├─ NO → Dialog "Izin lokasi diperlukan" → Request permission
    │       ├─ Granted → lanjut
    │       └─ Denied → Buka App Settings atau throw error
    └─ YES → lanjut
         ↓
Get current position (high accuracy, 15s timeout)
    ↓
Submit order dengan koordinat
```

---

## 9. Files Kunci untuk Presentasi

| File | Mengapa Penting |
|------|-----------------|
| `lib/features/home/controllers/home_controller.dart` | Mock data products + add-to-cart logic |
| `lib/features/cart/controllers/cart_controller.dart` | Checkout flow + GPS permission handling |
| `lib/features/order/controllers/order_controller.dart` | Realtime Firestore streaming |
| `lib/features/order/models/order_model.dart` | Data model + Firestore serialization |
| `lib/services/location_service.dart` | Geolocator wrapper (LBS/GPS) |
| `lib/services/database_helper.dart` | SQLite schema + cart operations |
| `android/app/src/main/AndroidManifest.xml` | Location permissions |
| `lib/features/auth/views/admin_dashboard_view.dart` | Admin panel + order status actions |

---

## 10. Demo Tips

### 10.1 Saat Demo Customer
- **Pastikan mock data terlihat jelas** — ada 10 produk dengan gambar, nama, harga
- **Scroll halus** — RecyclerView-ish via `ListView.builder`
- **Add to cart dengan feedback** — SnackBar berwarna hijau muncul
- **Checkout dengan location request** — sengaja minta izin GPS untuk menunjukkan kompetensi LBS
- **Order success screen** — Lottie animation untuk feedback positif

### 10.2 Saat Demo Admin
- Tunjukkan real-time update — buka admin dashboard di device lain/emulator
- Lakukan perubahan status dari `pending` → `processing` → `completed`
- Tunjukkan koordinat GPS yang tercatat setiap pesanan

### 10.3 Jika Ditanya Security
- **Firestore rules**: Untuk demo, rules sudah di-set `if true` — tapi jelaskan bahwa production menggunakan auth-based rules
- **Input validation**: Semua input diverifikasi sebelum disubmit
- **No secrets in code**: API keys ada di `firebase_options.dart` (generated), bukan hardcoded

---

## 11. Poin Kunci yang Harus Bisa Dijelaskan

### 11.1 State Management (GetX)
```
HomeController (RxList<BakeryItem>)
    ↓ provides data ke
HomeView (Obx) + DetailView

CartController (RxList<CartItemModel>)
    ↓ provides data ke
CartView (Obx) + CheckoutForm

OrderController (RxList<OrderModel>)
    ↓ listens ke
Firebase snapshot → OrderHistoryView + AdminDashboardView
```

### 11.2 Data Flow Checkout
```
Customer tap Checkout
    → CartController.checkout()
        → _resolveCheckoutCoordinates()
            → LocationService.isLocationEnabled()
            → LocationService.requestPermission()
            → Geolocator.getCurrentPosition()
        → Build OrderModel dengan koordinat
        → FirebaseService.createOrder(order)
            → Firestore /orders collection
        → Clear local cart
```

### 11.3 Realtime Admin Update
```
Admin tap "Proses" / "Tandai Selesai"
    → OrderController.updateOrderStatus(orderId, newStatus)
        → FirebaseService.updateOrderStatus()
            → Firestore document update
Customer sees update via
    → OrderController.listenCustomerOrders()
        → Firebase snapshot listener
        → UI auto-rebuild via Obx
```

---

## 12. Checklist Persiapan Sebelum Demo

- [ ] App bisa di-`flutter run` tanpa error
- [ ] Mock products tampil dengan gambar + harga
- [ ] Add to cart berfungsi + SnackBar muncul
- [ ] Checkout memunculkan permission dialog GPS
- [ ] Setelah izin, order masuk ke Firestore
- [ ] Cart kosong setelah checkout
- [ ] Admin bisa lihat order + ubah status
- [ ] Customer bisa lihat history order
- [ ] `flutter analyze` menunjukkan 0 error
- [ ] Screenshot/video rekam demo untuk backup

---

## 13. Troubleshooting Umum

| Masalah | Penyebab | Solusi |
|---------|----------|--------|
| GPS permission denied | AndroidManifest kurang | Pastikan `ACCESS_FINE_LOCATION` ada |
| Firebase data tidak muncul | Rules belum publish | Firestore Rules → set allow read,write lalu PUBLISH |
| Order tidak realtime | Listener tidak terpasang | Cek `_listenOrders()` di `OrderController` |
| Gambar produk blank | URL placeholder kosong | Telitikan `imageUrl` di mock data |
| Admin stuck di processing | Action row menghilang | Sudah diperbaiki: `processing` sekarang punya tombol |

---

## 14. Catatan dari PDF untuk Asesor

> Seluruh proses kerja mengacu pada SOP/WI yang dipersyaratkan.

Jadi saat presentasi, siapkan:
- Screenshot setiap halaman
- Alur cerita dari Customer → Admin
- Penjelasan singkat database schema
- Highlight GPS + Firestore integration

---

*Generated from SOAL TPD JMP.pdf + app source code review.*
