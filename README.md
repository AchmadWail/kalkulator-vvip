# 📱 Kalkulator VVIP (Secret Vault & Converter)

Kalkulator VVIP adalah aplikasi *hybrid* (mendukung Flutter Web, Mobile, dan Desktop) yang dari luar tampak seperti aplikasi kalkulator premium bergaya Apple/iOS. Namun di baliknya, aplikasi ini menyimpan fitur canggih berupa **Brankas Rahasia (Vault)**, **Sistem Pembayaran VIP (DANA)**, serta **Konverter Lengkap (Satuan & Valuta)** tanpa memerlukan API Key pihak ketiga.

---

## 🌟 Fitur Utama

### 1. 🧮 Kalkulator Premium (iOS Style)
- Tampilan elegan dengan mode gelap (*Dark Mode*).
- Responsif di berbagai perangkat (Web, Android, iOS).
- Layar pintar: Teks otomatis mengecil (*FittedBox*) saat angka terlalu panjang.
- Fitur pratinjau hasil (menampilkan bayangan hasil saat rumus diketik).

### 2. 🔐 Brankas Rahasia (Secret Vault)
- Kalkulator ini menyembunyikan galeri/brankas untuk menyimpan foto dan video.
- Fitur tersembunyi (*stealth mode*), orang awam hanya akan mengira ini aplikasi kalkulator biasa.
- Menggunakan `image_picker` untuk mengambil media langsung dari galeri lokal Anda.

### 3. 💳 Sistem VIP & Pembayaran DANA
- Untuk mengakses Brankas Utama, pengguna harus menjadi VIP.
- Integrasi *Deep Link* langsung ke aplikasi DANA (`dana://pay?amount=15000&note=KalkulatorVIP`).
- Menggunakan `shared_preferences` untuk mengingat status pembelian secara permanen.

### 4. 📏 Konverter Satuan & 💵 Valuta Asing
- Dilengkapi dengan 6 konverter satuan bawaan: Panjang, Berat, Suhu, Area, Volume, Waktu.
- Konverter mata uang *offline-first* menggunakan data fallback JSON (Bebas dari *rate limit* API pihak ketiga).

---

## 🕵️‍♂️ Daftar Kode Rahasia (Secret Codes)

Ketikkan kombinasi operasi matematika berikut di layar kalkulator utama untuk memicu fitur tersembunyi:

| Kode Rahasia | Fungsi |
| :--- | :--- |
| **`1+1=`** | Membuka Brankas Rahasia versi **Gratis** (Preview) |
| **`99+99=`** | Mengecek status VIP. Jika belum bayar, akan dialihkan ke **Layar Pembayaran DANA**. Jika sudah bayar, langsung ke **Brankas VIP**. |

*(Catatan: Anda bisa mengubah atau menambah secret code lain di dalam file `lib/features/calculator/logic/secret_detector.dart`)*

---

## 🏗️ Struktur Arsitektur (Feature-First)

Proyek ini dibangun menggunakan struktur *Feature-First* (Modular) yang sangat rapi untuk memudahkan skalabilitas dan *maintenance*:

```text
lib/
 ├── core/
 │    └── theme/         # app_colors.dart, app_theme.dart
 ├── features/
 │    ├── calculator/    # Layar utama kalkulator, UI tombol, dan detektor kode
 │    ├── converters/    # Layar konverter satuan & mata uang
 │    └── vault/         # Layar brankas gambar & sistem pembayaran VIP
 ├── main.dart
 └── app.dart
```

---

## 🚀 Instalasi & Cara Menjalankan

1. **Kloning Repositori**
   ```bash
   git clone https://github.com/RydenzzRyxx/kalkulator.git
   cd kalkulator
   ```

2. **Unduh Dependensi**
   Aplikasi ini membutuhkan beberapa *library* seperti `provider`, `url_launcher`, dan `image_picker`.
   ```bash
   flutter pub get
   ```

3. **Jalankan Aplikasi**
   Untuk menjalankan aplikasi di *browser* Chrome (Web):
   ```bash
   flutter run -d chrome
   ```
   Untuk Android/iOS:
   ```bash
   flutter run
   ```

---

## 🛠️ Tech Stack
- **Framework**: Flutter (Dart)
- **State Management**: Provider
- **Storage**: Shared Preferences
- **Routing**: standard `Navigator` (dengan dukungan GoRouter)
- **Assets**: Ikon lokal custom dan JSON fallback

---
*Didesain dan dibangun berdasarkan VVIP Calculator Blueprint v2.0.*
