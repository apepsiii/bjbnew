# PROJECT.md: DIGI Bank BJB Custom Mobile App

## 📌 Context & Objective
Project ini bertujuan untuk membangun aplikasi mobile **Flutter baru yang bersih (*clean Flutter project*)** dengan mereplikasi **desain visual, tema warna, font, dan asset** dari aplikasi *DIGI bank bjb*, namun mengimplementasikan **alur kerja (*workflow*) khusus** sesuai kebutuhan pengguna.

---

## 🎨 Asset & Design System Mapping (Dari Projek Dekompilasi)

| Elemen Design | Sumber Asset / Value | Keterangan |
| :--- | :--- | :--- |
| **Primary Color** | `#0083C9` (BJB Primary Blue) | Digunakan untuk Header, Button, dan Splash Screen |
| **Secondary Color** | `#00588A` (BJB Dark Blue) | Digunakan untuk Accent, Top Bar, dan Active States |
| **Font Family** | `Quicksand` (`Quicksand-Regular.ttf`, `Quicksand-SemiBold.ttf`) | Diambil dari `decompiled_base/resources/assets/flutter_assets/assets/fonts/` |
| **Logo & Icons** | `decompiled_base/resources/assets/flutter_assets/assets/icons/` | Logo DIGI bank bjb, icon autodebet, dsb. |
| **Backgrounds** | `decompiled_base/resources/assets/flutter_assets/assets/background/` | Background splash & header gradient |

---

## 📱 Alur Layar & Fitur Aplikasi (*Screen Workflows*)

### 1. Splash Screen (`splash_screen.dart`)
* **Visual**: Background biru BJB dengan animasi logo DIGI bank bjb di tengah.
* **Logic**: Delay 2-3 detik, lalu otomatis berpindah ke **Login Screen**.

### 2. Login Screen (`login_screen.dart`)
* **Visual**: Banner ucapan "Selamat Datang di DIGI bank bjb", kartu input melayang (*floating card*).
* **Fitur**:
  * Input Nama / Identitas Custom.
  * Input Password Custom.
  * Tombol "Masuk / Login" bergaya BJB.
  * Navigasi ke **Dashboard Screen** setelah autentikasi sukses.

### 3. Dashboard Screen (`dashboard_screen.dart`)
* **Visual**: Header biru BJB dengan profil pengguna custom, ringkasan saldo/rekening.
* **Fitur**:
  * Grid Menu Pilihan (Transfer, DigiCash, Layanan, Rekening Koran).
  * Tombol Utama **"Cetak Rekening Koran"** untuk masuk ke alur statement.

### 4. Form Rekening Koran (`statement_form_screen.dart`)
* **Visual**: Card form bersih dengan kalender & input field.
* **Fitur**:
  * Input *Date Range* (Tanggal Mulai – Tanggal Selesai).
  * Input Alamat Email Tujuan.
  * Tombol **"Kirim & Tampilkan Rekening Koran"**.

### 5. Preview PDF & Email Service (`pdf_viewer_screen.dart`)
* **Visual**: PDF Viewer terintegrasi di dalam aplikasi dengan kontrol zoom & download.
* **Fitur**:
  * Membuka & menampilkan file PDF Rekening Koran yang sudah disiapkan.
  * Mengirimkan file PDF tersebut ke email yang dimasukkan di form secara otomatis.

---

## 🏗️ Struktur Arsitektur Kode (`lib/`)

```text
lib/
├── main.dart                   # Root widget & BJB Material Theme setup
├── constants/
│   ├── app_colors.dart         # Warna resmi BJB (#0083C9, #00588A, #F5F7FA)
│   └── app_assets.dart         # Path ke asset logo, font, & icon
├── models/
│   ├── user_model.dart          # Data identitas & akun pengguna
│   └── statement_request.dart  # Data range tanggal & email
├── screens/
│   ├── splash_screen.dart       # Layar 1: Splash
│   ├── login_screen.dart        # Layar 2: Login Custom
│   ├── dashboard_screen.dart    # Layar 3: Dashboard Utama
│   ├── statement_form_screen.dart # Layar 4: Form Rekening Koran
│   └── pdf_viewer_screen.dart   # Layar 5: Tampilkan PDF & Status Email
├── services/
│   ├── email_service.dart       # Handling pengiriman email PDF
│   └── pdf_service.dart         # Handling pengoperasian file PDF
└── widgets/
    ├── bjb_button.dart          # Widget tombol custom BJB
    ├── bjb_text_field.dart      # Widget input text custom BJB
    └── bjb_app_bar.dart         # Top Bar custom BJB
```

---

## 📦 Paket / Package Dependencies (`pubspec.yaml`)
* `flutter_pdfview`: Untuk menampilkan PDF di dalam aplikasi.
* `intl`: Untuk format tanggal (*Date Range Picker*).
* `mailer` / `http`: Untuk pengiriman email & attachment PDF.
* `path_provider`: Untuk akses file PDF di penyimpanan lokal.
