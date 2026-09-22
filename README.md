# DIGI Bank BJB - Reverse Engineering & Maintenance Project

Dokumentasi dan struktur projek terorganisir untuk analisis, pemeliharaan (*maintenance*), dan modifikasi aplikasi **DIGI bank bjb** (`com.bjbsmb`).

---

## 📁 Struktur Direktori Projek

```text
bjbv2/
├── original_apk/             # Paket APK / Biner Asli
│   └── base.apk              # File installer APK asli
│
├── decompiled_base/          # Dekompilasi Android Native (JADX / Apktool)
│   ├── sources/              # Kode sumber Java/Kotlin (com.bjbsmb, AppGuard, dll)
│   └── resources/            # AndroidManifest.xml, Res, & Assets (Flutter assets, Font, HTML, SSL CA)
│
├── native_libs/              # Library Native (.so) Hasil Ekstraksi
│   └── lib/arm64-v8a/
│       ├── libapp.so         # Binary Aplikasi Flutter AOT
│       └── libflutter.so     # Engine Flutter Runtime
│
├── flutter_analysis/         # Hasil Reverse Engineering Flutter (Blutter Output)
│   ├── objs.txt              # Rekonstruksi Struktur Class, Method, & Tipe Data Dart
│   ├── pp.txt                # Dump Object Pool (String, API Endpoints, Constants)
│   ├── blutter_frida.js      # Script Frida Siap Pakai untuk Hooking Runtime
│   ├── asm/                  # Disassembly Assembly ARM64 dengan Nama Simbol Fungsi
│   └── ida_script/           # Script Pembantu untuk Ghidra / IDA Pro
│
└── tools/                    # Tools Pembantu Tambahan
    └── blutter/              # Source code & engine Blutter (Dart AOT Reverse Tool)
```

---

## 🚀 Panduan Alur Kerja Pemeliharaan (*Maintenance Workflow*)

### 1. Menjalankan Aplikasi di Emulator / Perangkat Real (Samsung)
Untuk memasang seluruh modul split APK ke perangkat Samsung:
```cmd
python -c "import glob, subprocess; apks = glob.glob('decompiled/resources/*.apk'); subprocess.run(['adb', 'install-multiple'] + apks)"
```
Atau buka aplikasi:
```cmd
adb shell am start -n com.bjbsmb/.MainActivity
```

### 2. Mengubah Resource / Konfigurasi Native Android
File konfigurasi dan asset berada di folder `decompiled_base/`:
* **Manifest**: `decompiled_base/resources/AndroidManifest.xml`
* **Flutter Assets**: `decompiled_base/resources/assets/flutter_assets/` (termasuk sertifikat SSL CA, font, HTML syaratan)
* **Android Resources**: `decompiled_base/resources/res/`
* **Java/Kotlin Wrapper**: `decompiled_base/sources/com/bjbsmb/`

### 3. Analisis Logic Flutter (Dart AOT)
* **Mencari Fungsi / Class**: Buka `flutter_analysis/objs.txt`
* **Mencari String / Endpoint API**: Buka `flutter_analysis/pp.txt`
* **Kompilasi Ulang Blutter (jika diperlukan)**:
  Run dari VS Developer Command Prompt:
  ```cmd
  python tools\blutter\blutter.py native_libs\lib\arm64-v8a flutter_analysis --rebuild
  ```

### 4. Dynamic Hooking & Intersepsi Runtime (Frida)
Gunakan script Frida bawaan `flutter_analysis/blutter_frida.js` untuk melakukan hooking pada fungsi Flutter saat aplikasi berjalan:
```cmd
frida -U -f com.bjbsmb -l flutter_analysis/blutter_frida.js
```

---

## 📌 Info Spesifikasi Teknikal Aplikasi
* **Package Name**: `com.bjbsmb`
* **Main Activity**: `com.bjbsmb.MainActivity`
* **Framework**: Flutter
* **Dart VM Version**: `3.6.0`
* **Target Arch**: `ARM64-v8a` (Compressed Pointers)
