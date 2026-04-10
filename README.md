# Aplikasi Data Mahasiswa - Hive Flutter

> **Mata Kuliah:** Pemrograman Platform Bergerak  
> **Semester:** 6  
> **Tugas:** Praktikum Hive — CRUD Aplikasi Data Mahasiswa  
> **NIM:** 23106050011  
> **Nama:** Agung Nugraha

---

## Deskripsi

Aplikasi manajemen data mahasiswa berbasis Flutter yang menggunakan **Hive** sebagai database lokal (NoSQL key-value store). Aplikasi ini dibuat sebagai praktik mata kuliah Pemrograman Platform Bergerak untuk mempelajari cara menyimpan, membaca, mengubah, dan menghapus data secara persisten menggunakan Hive.

---

## Fitur Aplikasi

| Fitur | Keterangan |
|-------|-----------|
| **Tambah Mahasiswa** | Input nama, NIM, dan program studi dengan validasi form |
| **Lihat Daftar** | Tampilkan semua mahasiswa dalam kartu dengan avatar inisial berwarna |
| **Edit Data** | Ubah data yang sudah ada, form otomatis terisi saat tombol edit ditekan |
| **Hapus Data** | Hapus dengan dialog konfirmasi agar tidak terhapus tidak sengaja |
| **Cari / Filter** | Cari berdasarkan nama, NIM, atau prodi secara real-time |
| **Validasi Form** | Semua field wajib diisi sebelum data bisa disimpan |
| **Notifikasi** | Snackbar muncul setiap kali operasi berhasil |
| **Reactive UI** | Tampilan diperbarui otomatis menggunakan `ValueListenableBuilder` |

---

## Teknologi yang Digunakan

- **Flutter** — Framework UI cross-platform
- **Dart** — Bahasa pemrograman
- **Hive** — Database lokal NoSQL (key-value store, lebih cepat dari SQLite untuk data sederhana)
- **hive_flutter** — Integrasi Hive dengan Flutter (init path, listenable)
- **Material Design 3** — Sistem desain UI

### Perbandingan Hive vs SQLite

| Aspek | Hive | SQLite |
|-------|------|--------|
| Tipe database | NoSQL (key-value) | Relasional |
| Kecepatan baca/tulis | Sangat cepat | Cepat |
| Query kompleks | Tidak didukung | Didukung (SQL) |
| Setup | Mudah | Sedang |
| Cocok untuk | Data sederhana/cache | Data terstruktur |

---

## Struktur Proyek

```
lib/
├── main.dart            # Entry point: init Hive, buka box, jalankan app
└── views/
    └── mahasiswa_page.dart  # UI CRUD + search + validasi form
```

---

## Cara Menjalankan

### Prasyarat

- Flutter SDK versi **3.10.0** atau lebih baru
- Dart SDK versi **3.0.0** atau lebih baru

### Instalasi & Menjalankan

```bash
# 1. Masuk ke folder proyek
cd hiveapp

# 2. Install dependencies (termasuk hive & hive_flutter)
flutter pub get

# 3. Jalankan aplikasi
flutter run
```

### Pilih Platform

```bash
# Android (emulator atau device fisik)
flutter run -d android

# Web (Chrome)
flutter run -d chrome

# Windows Desktop
flutter run -d windows
```

---

## Cara Kerja Hive

### 1. Inisialisasi
```dart
await Hive.initFlutter();            // Set direktori penyimpanan
await Hive.openBox('mahasiswaBox');  // Buka/buat box
```

### 2. Menyimpan Data
```dart
final box = Hive.box('mahasiswaBox');
box.add({'nama': 'Agung', 'nim': '23106050011', 'prodi': 'Informatika'});
```

### 3. Membaca Data
```dart
final data = box.getAt(0);  // Baca berdasarkan index
```

### 4. Update Data
```dart
box.putAt(index, dataBaruMap);  // Timpa data di index tertentu
```

### 5. Hapus Data
```dart
box.deleteAt(index);
```

### 6. Reactive UI dengan ValueListenableBuilder
```dart
ValueListenableBuilder(
  valueListenable: box.listenable(),
  builder: (context, Box box, _) {
    // Widget ini otomatis rebuild saat data berubah
  },
)
```

---

## Konsep yang Dipelajari

1. **Hive NoSQL Database** — Cara menyimpan data lokal menggunakan key-value store tanpa SQL.
2. **Box** — Konsep "tabel" di Hive, tempat menyimpan kumpulan data.
3. **Reactive Programming** — `ValueListenableBuilder` memantau perubahan box dan rebuild UI otomatis.
4. **Form Validation** — Penggunaan `GlobalKey<FormState>` dan `validator` untuk validasi input.
5. **StatefulWidget** — Manajemen state untuk mode tambah vs edit.
6. **Dialog Konfirmasi** — Mencegah penghapusan data tidak disengaja.

---

## Screenshot Tampilan

```
┌─────────────────────────────────────┐
│        Data Mahasiswa     3 mhs     │  <- AppBar dengan counter reaktif
├─────────────────────────────────────┤
│  Tambah Mahasiswa Baru              │
│  ┌──────────────────────────────┐   │
│  │ [icon] Nama Lengkap          │   │
│  │ [icon] NIM                   │   │  <- Form dengan validasi
│  │ [icon] Program Studi         │   │
│  └──────────────────────────────┘   │
│  [ + Simpan ]                       │
├─────────────────────────────────────┤
│  [search] Cari nama, NIM, prodi...  │  <- Search bar real-time
├─────────────────────────────────────┤
│  Daftar Mahasiswa (3)               │
│  ┌──────────────────────────────┐   │
│  │ AN  Agung Nugraha  [edit][x] │   │
│  │     23106050011              │   │  <- Card dengan avatar inisial
│  │     Teknik Informatika       │   │
│  └──────────────────────────────┘   │
└─────────────────────────────────────┘
```

---

## Lisensi

Proyek ini dibuat untuk keperluan akademik sebagai bagian dari tugas praktikum mata kuliah **Pemrograman Platform Bergerak**.
