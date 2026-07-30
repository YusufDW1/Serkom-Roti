# 📱 Technical Presentation Guide — Roti Saku
## Junior Mobile Programmer (JMP) / TPD BNSP Assessment

---

## PART 1: PRESENTASI (10-15 Menit)

### 1.1 Perkenalan Diri (30 detik)
**Template:**
```
Assalamualaikum warrahmatullahi wabarakatuh,

Nama saya [Nama Lengkap], dari program studi [Program Studi].
Saya akan mendemonstrasikan aplikasi mobile yang saya buat untuk
memenuhi kebutuhan praktik demostrasi sertifikasi Junior Mobile Programmer.
```

**Tips:**
- Sampaikan dengan jelas, jangan terburu-buru
- Siapkan jawaban jika ditanya: "Mengapa memilih mobile app?"

---

### 1.2 Penjelasan Aplikasi (1 menit)

**Template:**
```
Aplikasi ini bernama "Roti Saku" — sebuah aplikasi mobile untuk
pemesanan roti online yang dibangun menggunakan Flutter.

Tujuan utama:
- Memudahkan pelanggan memesan roti/kue secara online
- Mencatat lokasi pelanggan via GPS untuk pengiriman
- Menyimpan data pesanan di server (Firebase Firestore)
- Memberikan dashboard admin untuk mengelola status pesanan

Fungsi utama:
1. Menampilkan katalog roti/kue dengan harga
2. Memungkinkan pembelian langsung via cart
3. Mencatat data pelanggan + koordinat GPS saat checkout
4. Menyimpan data pesanan di cloud database
5. Admin dapat melihat dan mengelola status pesanan
```

**Highlight yang harus disampaikan:**
- Ini adalah **full mobile app** yang functional, bukan hanya UI mockup
- Data **tersimpan permanen** via Firebase, bukan hanya di内存
- Ada **dua role**: customer dan admin
- **Real-time updates**: admin ubah status → customer lihat perubahan langsung

---

### 1.3 Tools yang Digunakan (1 menit)

**Template:**
```
Untuk membuat aplikasi ini, saya menggunakan:

Framework & Language:
- Flutter 3.x (cross-platform mobile framework)
- Dart (programming language)

State Management:
- GetX 4.x (untuk state management, navigation, dan dependency injection)

Local Database:
- SQLite via sqflite plugin
  → Menyimpan data cart secara lokal di device

Remote Database:
- Firebase Firestore (cloud database)
  → Menyimpan data pesanan secara real-time
- Firebase Auth (untuk autentikasi pengguna)

Location Services:
- Geolocator plugin
  → Mencaptur koordinat GPS pelanggan saat checkout

UI/UX:
- Material Design 3
- Google Fonts (Poppins)
- Lottie animations untuk feedback

Development Tools:
- Android Studio (IDE)
- Android emulator / physical device untuk testing
- Git untuk version control
```

**Chart perbandingan:**
| Komponen | Tool | Alasan Pemilihan |
|----------|------|------------------|
| Framework | Flutter | Cross-platform (Android/iOS), performa native |
| State | GetX | Ringan, reactive, easy routing |
| Local DB | SQLite | Offline-first cart persistence |
| Remote DB | Firebase Firestore | Realtime, serverless, scalable |
| Location | Geolocator | GPS precision, permission handling |
| Animasi | Lottie | Native-feeling UX feedback |

---

### 1.4 Demonstrasi Aplikasi (5-7 menit)

**Siapkan sebelum demo:**
- [ ] App di emulator/device
- [ ] Firebase sudah connected
- [ ] Mock data sudah ter-load
- [ ] Internet connection stabil

**Alur Demo yang Harus Dilalui:**

#### A. Login / Register (30 detik)
```
1. Tampilkan halaman Login
2. Masukkan email + password
3. Tap "Login" → masuk ke Home
4. Jelaskan: "Ada dua mode: customer dan admin"
```

**Poin yang harus disampaikan:**
- Autentikasi menggunakan Firebase Auth
- Email/password-based authentication

#### B. Home — Katalog Produk (1 menit)
```
1. Scroll through product list
2. Point out:
   - Gambar produk
   - Nama produk
   - Harga (format Rupiah)
   - Kategori
3. Tap salah satu produk → Detail screen
```

**Poin yang harus disampaikan:**
- Data produk dimuat dari `HomeController` (mock data untuk demo)
- Setiap produk memiliki `imageUrl`, `name`, `price`, `category`, `description`
- Menggunakan `GridView` untuk layout responsif

#### C. Detail Produk + Add to Cart (45 detik)
```
1. Tampilkan detail produk:
   - Gambar besar
   - Nama + deskripsi lengkap
   - Harga
2. Tap "Tambah ke Keranjang"
3. Tunjukkan SnackBar confirmation
4. Tunjukkan cart count badge bertambah
```

**Poin yang harus disampaikan:**
- `addToCart()` di `HomeController` menyimpan ke SQLite
- SnackBar memberikan feedback visual ke user

#### D. Cart — Kelola Item (1 menit)
```
1. Navigate ke Cart screen
2. Tunjukkan:
   - Item yang ada di cart
   - Quantity controls (+/-)
   - Harga per item
   - Total harga
3. Ubah quantity salah satu item
4. Hapus salah satu item (show toast/info)
5. Tunjukkan total update secara real-time
```

**Poin yang harus disampaikan:**
- Cart menggunakan SQLite untuk persistence
- `updateQuantity()` dan `deleteItem()` di `CartController`
- `getTotal()` menghitung total secara dinamis

#### E. Checkout + GPS Location (1,5 menit)
```
1. Tap "Checkout" button
2. Isi Nama Pemesan (misal: "Yusuf")
3. Tap "Lanjut ke Checkout"
4. Android permission dialog muncul:
   "Allow Roti Saku to access this device's location?"
5. Tap "Allow"
6. Koordinat GPS ter-capture
7. Tap "Place Order"
8. Loading indicator muncul
9. Order success screen dengan animasi Lottie
```

**Poin yang harus disampaikan:**
- **Permission flow yang benar**:
  - Cek location service enabled?
  - Request permission dengan dialog penjelasan
  - Jika denied → buka app settings
- Koordinat disimpan ke Firestore bersama order
- Data lokal cart di-clear setelah checkout berhasil

#### F. Order History — Customer (45 detik)
```
1. Navigate ke "Riwayat Pesanan" / History tab
2. Tunjukkan order yang baru dibuat:
   - ID pesanan
   - Nama customer
   - Item yang dipesan
   - Total harga
   - Koordinat GPS (latitude, longitude)
   - Status: "pending"
```

**Poin yang harus disampaikan:**
- Data diambil dari Firestore real-time listener
- `listenCustomerOrders()` di `OrderController`
- UI auto-update via `Obx` ketika data berubah

#### G. Admin Dashboard (1,5 menit)
```
1. Switch ke mode Admin (login dengan akun admin)
2. Tampilkan Admin Dashboard:
   - Semua pesanan dari semua customer
   - Status badges (pending, processing, completed)
3. Pilih order dengan status "pending":
   - Tap "Proses" → status berubah ke "processing"
   - Tap "Selesai" → status berubah ke "completed"
4. Tunjukkan perubahan real-time di customer history
```

**Poin yang harus disampaikan:**
- Admin menggunakan Firestore query untuk mendapatkan semua orders
- `updateOrderStatus()` di `OrderController`
- Realtime sync menggunakan `ordersSnapshot()` listener

---

### 1.5 Penjelasan Database (1 menit)

**Template:**
```
Ada dua jenis database yang digunakan:

A. SQLite (Local — Cart)
   - Menyimpan data keranjang belanja secara offline
   - Schema: cart_items table
     * productId (TEXT) — primary key
     * name, price, quantity, imageUrl
     * createdAt (timestamp)
   - Operasi: insert, update, delete, getTotal

B. Firebase Firestore (Remote — Orders)
   - Menyimpan data pesanan secara permanen di cloud
   - Collection: /orders
     * customerName, customerId
     * items (array of objects)
     * total, latitude, longitude
     * status (pending/processing/completed)
   - Real-time listener: admin dan customer melihat update instantly
```

**Visual Aid (siapkan screenshot atau diagram):**
```
┌─────────────────────────────────────────┐
│         DATABASE ARCHITECTURE           │
├─────────────────────────────────────────┤
│                                         │
│  ┌──────────────┐      ┌─────────────┐ │
│  │   SQLite     │      │  Firestore  │ │
│  │  (Local)     │      │  (Remote)   │ │
│  ├──────────────┤      ├─────────────┤ │
│  │ cart_items   │      │ /orders     │ │
│  │ - productId  │      │ - customer  │ │
│  │ - name       │      │ - items     │ │
│  │ - price      │      │ - total     │ │
│  │ - quantity   │      │ - lat/long  │ │
│  │ - imageUrl   │      │ - status    │ │
│  │ - createdAt  │      │ - timestamp │ │
│  └──────────────┘      └─────────────┘ │
│                                         │
│  Cart operations (CRUD)    Order sync   │
│  - Insert/add to cart      - Real-time  │
│  - Update quantity         - Offline    │
│  - Delete item             - Cloud sync │
│  - Calculate total         - Admin mgmt │
│                                         │
└─────────────────────────────────────────┘
```

---

### 1.6 Source Code & Struktur Project (1 menit)

**Template:**
```
Struktur project mengikuti arsitektur feature-based:

lib/
├── main.dart                      # Entry point, initialization
├── features/
│   ├── home/                      # Customer home
│   │   ├── controllers/           # GetX controllers
│   │   └ views/                   # UI screens
│   ├── cart/                      # Shopping cart
│   │   ├── controllers/           # Cart logic + GPS checkout
│   │   └ views/
│   ├── order/                     # Order management
│   │   ├── controllers/           # Realtime Firestore listener
│   │   ├── models/                # Data models (OrderModel)
│   │   ├ views/                   # History, Success, Admin
│   │   └ widgets/                 # Shared UI components
│   └ auth/                        # Authentication
│       └ views/
└── services/
    ├── database_helper.dart       # SQLite operations
    ├── location_service.dart      # Geolocator wrapper
    ├── firebase_service.dart      # Firestore CRUD
    └ auth_service.dart            # Firebase Auth
```

**Poin penting yang harus disampaikan:**
- **Separation of Concerns**: Controller untuk logic, View untuk UI, Model untuk data
- **Reusability**: Widget `OrderCard` dipakai di kedua screen (customer + admin)
- **Service Layer**: Firebase, Location, Database di package `services/` agar mudah maintenance

**Screenshot struktur folder** (siapkan sebelum presentasi)

---

### 1.7 Tanya Jawab (sesuai waktu tersisa)

**Pertanyaan yang sering muncul + jawaban yang disiapkan:**

#### Q1: "Mengapa menggunakan GetX?"
```
GetX dipilih karena:
1. Ringan dan minimalis — tidak membloat app
2. Sudah include routing + dependency injection
3. Reactive state management dengan Rx (observables)
4. Cocok untuk project skala menengah seperti ini
Alternatif lain seperti Provider atau Bloc juga bisa,
tapi GetX lebih straightforward untuk fast development.
```

#### Q2: "Bagaimana cara GPS bekerja?"
```
Saat checkout:
1. App cek apakah location service aktif
2. Jika belum, tampilkan dialog untuk aktifkan
3. Request runtime permission (ACCESS_FINE_LOCATION)
4. Jika diizinkan, ambil koordinat via Geolocator
5. Koordinat disimpan ke Firestore bersama data order
6. Jika ditolak, user diarahkan ke app settings
```

#### Q3: "Bagaimana real-time update di admin dashboard?"
```
Firestore memiliki real-time listener:
- Admin dashboard menggunakan `ordersSnapshot()` 
  yang listens ke collection /orders
- Setiap documents berubah → snapshot callback triggered
- UI otomatis rebuild via GetX Obx
- Tidak perlu polling atau refresh manual
```

#### Q4: "Bagaimana dengan offline mode?"
```
- SQLite menyimpan cart secara lokal,
  jadi user bisa continue shopping meski offline
- Firestore memiliki offline persistence built-in
- Namun, untuk demo ini, kita fokus ke online mode
  agar asesor bisa lihat real-time features
```

#### Q5: "Apakah ada security concern?"
```
Firestore rules saat ini set ke `if true` untuk development
Dalam production, seharusnya menggunakan:
- Authentication-based rules
- User can only read own orders
- Admin only can update status
- Input validation di setiap form
```

#### Q6: "Mengapa Flutter bukan Kotlin/Java native?"
```
Flutter dipilih karena:
1. Cross-platform — satu codebase untuk Android & iOS
2. Hot reload untuk fast development/iteration
3. Performa yang mendekati native
4. Cocok untuk project yang butuh cross-platform
5. Dokumentasi dan community support yang baik
```

---

## PART 2: SUBMISSION CHECKLIST

### 2.1 File yang Wajib Dikumpulkan

| No | Berkas | Format | Keterangan |
|----|--------|--------|------------|
| 1 | Source Code | Folder project | Atau link GitHub |
| 2 | APK | `.apk` file | Harus bisa diinstal & dijalankan |
| 3 | Database | SQLite + Firestore config | `.db` file + `firebase.json` |
| 4 | Dokumen Presentasi | PPTX / PDF | Maksimal 10 slide |
| 5 | Flowchart / Use Case Diagram | Gambar / PDF | Visual workflow aplikasi |
| 6 | Screenshot Dokumentasi | PNG/JPEG | Login, Dashboard, Menu, Fitur utama |

### 2.2 Nama Folder/File

**Format:**
```
NamaLengkap_JMP/
├── source_code/
│   └── roti_saku/
├── apk/
│   └── roti_saku_release.apk
├── database/
│   ├── roti_saku_cart.db
│   └── firebase_config.json
├── dokumentasi/
│   ├── flowchart.png
│   └── screenshots/
│       ├── 01_login.png
│       ├── 02_home.png
│       ├── 03_cart.png
│       ├── 04_checkout.png
│       ├── 05_order_success.png
│       ├── 06_admin_dashboard.png
│       └── 07_order_history.png
└── presentasi/
    └── NamaLengkap_JMP.pptx
```

### 2.3 Persiapan Sebelum Upload

**Checklist sebelum upload ke Drive:**
- [ ] APK bisa diinstal di device lain (test di 2-3 device)
- [ ] Semua screenshot terlihat jelas (resolusi tinggi)
- [ ] Source code tidak ada file `.env` atau credentials
- [ ] `firebase_options.dart` di-commit (generated file, aman)
- [ ] README.md ada di root project dengan cara menjalankan app
- [ ] PPT presentasi sudah review: maksimal 10 slide
- [ ] Flowchart sudah clear dan mudah dibaca
- [ ] Semua file dalam folder `NamaLengkap_JMP/`
- [ ] Ukuran total folder tidak terlalu besar (max 1-2 GB)
- [ ] Double-check semua file bisa dibuka/dijalankan

---

## PART 3: CREATE APK (Langkah-langkah)

### 3.1 Build Release APK

```bash
cd D:/Kuliah/Exercise/Serkom/roti_saku

# 1. Pastikan pub get sudah done
flutter pub get

# 2. Build release APK
flutter build apk --release

# Output will be at:
# build\app\outputs\flutter-apk\app-release.apk
```

### 3.2 APK Testing Checklist

- [ ] Install APK ke physical device (bukan hanya emulator)
- [ ] App launch tanpa crash
- [ ] Login works
- [ ] Product list loads
- [ ] Add to cart works
- [ ] Checkout + GPS permission works
- [ ] Order history shows up
- [ ] Admin dashboard accessible
- [ ] Status update works

### 3.3 Firebase Configuration untuk APK

**Pastikan `google-services.json` sudah ada:**
```
android/app/google-services.json
```

**Firebase project yang digunakan:**
- Project: `roti_saku` (check `firebase_options.dart`)
- Firestore rules: Allow read/write untuk testing (sementara)
- Authentication: Email/Password enabled

---

## PART 4: DOKUMENTASI YANG HARUS DIBUAT

### 4.1 Flowchart Aplikasi

**Yang harus ada di flowchart:**

```
┌─────────────────────────────────────────┐
│          CUSTOMER FLOW                  │
└─────────────────────────────────────────┘

[Start]
   ↓
[Login/Register]
   ↓
[Home — Browse Products]
   ↓
[Product Detail]
   ↓
[Add to Cart] ──────────────┐
   ↓                        │
[Cart Screen]               │
   ↓                        │
[Update Qty / Remove] ──────┘
   ↓
[Checkout Form]
   ↓
[Request GPS Permission]
   ↓
[Capture Coordinates]
   ↓
[Submit Order to Firestore]
   ↓
[Clear Cart]
   ↓
[Order Success Screen]
   ↓
[Order History] ← (Realtime update)
   ↓
[End]

┌─────────────────────────────────────────┐
│           ADMIN FLOW                    │
└─────────────────────────────────────────┘

[Admin Login]
   ↓
[Admin Dashboard]
   ↓
[View All Orders]
   ↓
[Select Order]
   ↓
[Update Status: pending → processing]
   ↓
[Update Status: processing → completed]
   ↓
[Real-time sync to customer]
   ↓
[End]
```

### 4.2 Use Case Diagram

```
┌─────────────────────────────────────────┐
│         USE CASE DIAGRAM                │
├─────────────────────────────────────────┤
│                                         │
│  ┌──────────┐                           │
│  │ Customer │                           │
│  └────┬─────┘                           │
│       │                                  │
│       ├── Register/Login                │
│       ├── Browse Products               │
│       ├── View Product Detail           │
│       ├── Add to Cart                   │
│       ├── Update Cart Quantity          │
│       ├── Checkout                      │
│       ├── Share Location (GPS)          │
│       └── View Order History            │
│                                         │
│  ┌──────────┐                           │
│  │  Admin   │                           │
│  └────┬─────┘                           │
│       │                                  │
│       ├── Login                         │
│       ├── View All Orders               │
│       ├── Update Order Status           │
│       └── Monitor Real-time Orders      │
│                                         │
│  ┌──────────┐                           │
│  │ System   │                           │
│  └────┬─────┘                           │
│       │                                  │
│       ├── Store Cart (SQLite)           │
│       ├── Store Orders (Firestore)      │
│       ├── Capture GPS Coordinates       │
│       └── Real-time Sync                │
│                                         │
└─────────────────────────────────────────┘
```

---

## PART 5: PERSIAPAN PRIBADI

### 5.1 Yang Harus Dipahami

**State Management:**
- Bagaimana `RxList`, `RxBool`, `RxDouble` bekerja
- Kapan menggunakan `Obx()` vs `GetX()`
- Bagaimana `update()` vs `obs` triggering rebuild

**Firebase:**
- Firestore data model dan struktur collection
- Real-time snapshot listener (`snapshots()`)
- CRUD operations: `add()`, `update()`, `delete()`
- Security rules (meskipun current adalah `if true`)

**SQLite:**
- `openDatabase()`, `CREATE TABLE`
- `insert()`, `query()`, `update()`, `delete()`
- Transaction dan error handling

**Geolocator:**
- Permission flow: `checkPermission()` → `requestPermission()`
- `isLocationServiceEnabled()`
- `getCurrentPosition()` dengan desiredAccuracy
- `openAppSettings()` untuk fallback

### 5.2 Siapkan Environment

```
Sebelum presentasi:
1. Charge laptop ≥ 80%
2. Emulator/device sudah di-prepare
3. APK sudah diinstall di device cadangan
4. Screenshots sudah di-capture
5. PPT sudah di-review
6. Backup plan: screenshot/video demo jika app crash
```

### 5.3 Rehearsal

```
Siapkan script presentasi:
- 10 menit pertama: demo live
- 5 menit terakhir: Q&A

Siapkan "cheat sheet" dengan:
- Poin-poin kunci yang harus disampaikan
- Pertanyaan yang mungkin dari asesor
- Diagram architecture app singkat
```

---

## PART 6: TIPS TAMBAHAN

### 6.1 Jika Ditanya Hal yang Tidak Diketahui
```
Jangan jawab sembarang. Jawab dengan jujur:

"Untuk poin tersebut, saya belum mengimplementasikannya
secara fully, tapi saya memahami konsepnya adalah [konsep].
Jika diberikan waktu tambahan, saya bisa menambahkan [fitur]."

Contoh:
Q: "Bagaimana dengan payment gateway?"
A: "Untuk versi ini, saya belum implement payment gateway.
   Namun, konsepnya mirip dengan checkout flow — saya tinggal
   tambahkan payment method selection dan integrate dengan
   Midtrans/Stripe API sebelum submit order ke Firestore."
```

### 6.2 Highlight Fitur Unik
```
Yang membuat app ini stand out:
1. Real-time admin dashboard dengan status updates
2. GPS location capture dengan permission handling yang baik
3. Offline-first cart (SQLite) + Cloud sync (Firestore)
4. Reusable OrderCard widget untuk customer & admin
5. Loading states, error handling, dan user feedback (SnackBar, Lottie)
```

### 6.3 Jika Ada Bug saat Demo
```
Tetap tenang dan jelaskan:
"Ini adalah edge case yang belum sempat saya handle.
 Namun, error handling untuk kasus ini ada di codebase.
 Mari saya tunjukkan di source code."

Lalu tunjukkan bagian code yang handle error tersebut.
```

---

## CHECKLIST AKHIR (HARI H)

- [ ] Nama lengkap sesuai format: `NamaLengkap_JMP`
- [ ] Semua file sudah di-upload ke Drive
- [ ] APK bisa dijalankan tanpa error
- [ ] Source code bisa di-build ulang
- [ ] Screenshot sesuai standar (jelas, tidak blur)
- [ ] PPT presentasi ≤ 10 slide
- [ ] Flowchart / Use Case Diagram sudah dibuat
- [ ] Laptop dalam keadaan charge
- [ ] Device/emulator siap
- [ ] Internet connection stabil (jika perlu live demo)
- [ ] Backup APK di device cadangan
- [ ] Sudah rehearse minimal 1x
- [ ] Paham setiap baris kode yang akan dijelaskan

---

## APPENDIX: QUICK REFERENCE

### Key Files untuk Presentasi
| File | Presentasi Ke |
|------|---------------|
| `home_controller.dart` | Product loading + add-to-cart logic |
| `cart_controller.dart` | Checkout + GPS flow |
| `order_controller.dart` | Real-time Firestore listener |
| `order_model.dart` | Data structure + serialization |
| `location_service.dart` | GPS permission handling |
| `database_helper.dart` | SQLite schema + operations |
| `admin_dashboard_view.dart` | Admin features |
| `AndroidManifest.xml` | Android permissions |

### Demo Credentials (siapkan terlebih dahulu)
```
Customer:
- Email: customer@test.com
- Password: password123

Admin:
- Email: admin@test.com
- Password: admin123
```

**Pastikan akun-akun ini sudah ter-register di Firebase Authentication.**

---

*Dibuat khusus untuk persiapan TPD / JMP assessment.*

*Source: SOAL TPD JMP.pdf + Roti Saku app documentation.*
