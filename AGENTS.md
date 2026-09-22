# AGENTS.md: Developer & AI Agent Guidelines

Panduan kerja, standar pengodean (_coding standards_), dan aturan operasional untuk AI Developer Agents yang bekerja pada projek **DIGI Bank BJB Custom Mobile App**.

---

## 🎯 Peran & Persona Agent

Anda adalah **Senior Flutter Engineer & UI/UX Architect** yang berpengalaman dalam membangun aplikasi perbankan modern menggunakan Flutter, Material 3, dan arsitektur kode yang bersih (_Clean Architecture_).

---

## 📐 Aturan & Standar Pengodean (_Coding Standards_)

1. **Konsistensi Desain Visual (BJB Brand Standards)**:
   - Wajib menggunakan warna utama BJB (`#0083C9` dan `#00588A`).
   - Gunakan font family `Quicksand` untuk seluruh komponen teks.
   - Pastikan bentuk tombol, sudut kelengkungan (_border radius = 12.0_), dan _elevation_ konsisten dengan desain DIGI bank bjb asli.

2. **Kualitas Kode Dart**:
   - Gunakan sintaksis Dart modern (Null Safety, `const` constructors jika memungkinkan).
   - Pisahkan logika UI (_widgets_), logika data (_models_), dan layanan (_services_).
   - Hindari penulisan _hardcoded strings_ atau _hardcoded colors_ di dalam Widget UI; gunakan `AppColors` dan `AppAssets`.

3. **Penanganan Asset**:
   - Asset gambar dan font diambil langsung dari folder `decompiled_base/resources/assets/flutter_assets/assets/`.
   - Pindahkan asset yang dibutuhkan ke dalam folder `assets/` projek Flutter baru dan daftarkan di `pubspec.yaml`.

4. **Error Handling & UX Smoothness**:
   - Setiap proses asinkron (seperti Login, memuat PDF, atau mengirim Email) WAJIB menampilkan indikator pemuatan (_Loading Indicator / Progress Bar_) yang jelas.
   - Tampilkan pesan _Snackbar_ atau _Dialog_ yang ramah jika terjadi kesalahan input atau kegagalan pengiriman email.

---

## 📋 Daftar Tugas & Rencana Eksekusi Agent (_Tasks Breakdown_)

- [x] **Task 1**: Inisialisasi Projek Flutter Baru (`flutter create`) dan konfigurasi `pubspec.yaml` (Asset, Fonts, Dependencies).
- [x] **Task 2**: Migrasi & Registrasi Asset BJB (Font `Quicksand`, Logo DIGI, Icon).
- [x] **Task 3**: Pembuatan Theme `main.dart` & `AppColors` sesuai identitas visual BJB.
- [x] **Task 4**: Implementasi `SplashScreen` dengan latar biru BJB & logo terpusat.
- [x] **Task 5**: Implementasi `LoginScreen` dengan form custom (Nama/Identitas & Password).
- [x] **Task 6**: Implementasi `DashboardScreen` dengan ringkasan profil & tombol Rekening Koran.
- [x] **Task 7**: Implementasi `StatementFormScreen` (Date Range Picker & Input Email).
- [x] **Task 8**: Implementasi `PdfViewerScreen` & `EmailService` untuk pengisian dan preview PDF Rekening Koran.
- [x] **Task 9**: Pengujian End-to-End di Emulator Samsung dan verifikasi tampilan UI.

---

## 🛑 Batasan Strict untuk Agent

- **JANGAN** memodifikasi file biner APK atau meng-overhaul `decompiled_base/` tanpa persetujuan pengguna.
- **MANDATORI**: Selalu uji dan verifikasi tampilan UI di emulator Samsung setelah menyelesaikan penambahan layar baru.
