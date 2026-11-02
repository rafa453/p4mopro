# Dokumentasi Tugas Praktikum: Notes Storage Demo

Aplikasi **Notes Storage Demo** adalah proyek Flutter yang mengimplementasikan operasi CRUD (Create, Read, Update, Delete) pada catatan sederhana dengan memanfaatkan dua mekanisme penyimpanan lokal yang berbeda: **SQLite** (menggunakan package `sqflite`) dan **Sembast** (NoSQL embedded database).

## Tujuan Praktikum
1. Mempelajari dasar penggunaan package `sqflite` di Flutter.
2. Membuat database dan skema tabel menggunakan SQLite.
3. Menerapkan operasi CRUD pada SQLite.
4. Mengeksplorasi teknologi local storage alternatif, yaitu **Sembast**.
5. Membuat ringkasan dan dokumentasi hasil uji coba SQLite dan Sembast.

## Teknologi dan Package
Proyek ini menggunakan dependensi berikut (berdasarkan `pubspec.lock`):

*   **Flutter SDK**: >=3.44.0
*   **sqflite**: 2.4.5
*   **sembast**: 3.9.0
*   **sembast_web**: 2.4.6+1
*   **sqflite_common_ffi**: 2.4.5
*   **sqflite_common_ffi_web**: 0.4.5+4
*   **path**: 1.9.1
*   **path_provider**: 2.1.6

## Struktur Folder Proyek
```text
lib/
├── data/
│   ├── note.dart                    # Model data Note
│   ├── note_repository.dart         # Kontrak interface CRUD
│   ├── sembast_note_repository.dart # Implementasi Sembast
│   └── sqlite_note_repository.dart  # Implementasi SQLite
└── main.dart                        # UI dan koordinasi repository
```

## Cara Menjalankan
1.  Jalankan `flutter pub get` untuk mengunduh package.
2.  Untuk Web, jalankan `dart run sqflite_common_ffi_web:setup --force`.
3.  Jalankan di Android/Desktop: `flutter run`.
    *Catatan: `sqflite` memerlukan setup khusus agar berjalan di web (browser).*

## Skema Data

### SQLite
Tabel `notes`:
*   `id` (INTEGER PRIMARY KEY AUTOINCREMENT)
*   `title` (TEXT NOT NULL)
*   `content` (TEXT NOT NULL)
*   `created_at` (TEXT NOT NULL)

### Sembast
Menggunakan store `intMapStoreFactory.store('notes')`.

## Implementasi CRUD

### Create
`lib/data/sqlite_note_repository.dart`
```dart
  @override
  Future<Note> create(Note note) async {
    final db = await _database;
    final id = await db.insert('notes', note.toMap());
    return note.copyWith(id: id);
  }
```

### Read
`lib/data/sqlite_note_repository.dart`
```dart
  @override
  Future<List<Note>> readAll() async {
    final db = await _database;
    final rows = await db.query('notes', orderBy: 'id DESC');
    return rows.map((r) => Note.fromMap(r, id: r['id'] as int)).toList();
  }
```

### Update
`lib/data/sqlite_note_repository.dart`
```dart
  @override
  Future<void> update(Note note) async {
    final db = await _database;
    await db.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }
```

### Delete
`lib/data/sqlite_note_repository.dart`
```dart
  @override
  Future<void> delete(int id) async {
    final db = await _database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
```


## Perbandingan SQLite vs Sembast

| Jenis | SQLite (sqflite) | Sembast |
| :--- | :--- | :--- |
| Skema | Relasional (Tabel) | NoSQL (Document) |
| Cara Query | SQL String | Finder (Object-based) |
| Setup | Perlu Create Table | Langsung pakai store |
| Platform | Native-first | Cross-platform |

*Catatan: Sembast memiliki kemiripan filosofi dengan Hive karena menyimpan data sebagai dokumen, namun Sembast lebih mendekati gaya database transaksional (mirip SQLite) sedangkan Hive fokus pada key-value store.*

---
*Laporan: Implementasi CRUD sudah lengkap pada kedua repository. Integrasi SQLite di web telah diatasi menggunakan `sqflite_common_ffi_web`.*
