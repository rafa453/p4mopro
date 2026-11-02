import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'note.dart';
import 'note_repository.dart';

class SqliteNoteRepository implements NoteRepository {
  static Database? _db;

  @override
  String get name => 'SQLite (sqflite)';

  Future<Database> get _database async => _db ??= await _open();

  Future<Database> _open() async {
    final path = kIsWeb ? 'notes.db' : join(await getDatabasesPath(), 'notes.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  @override
  Future<Note> create(Note note) async {
    final db = await _database;
    final id = await db.insert('notes', note.toMap());
    return note.copyWith(id: id);
  }

  @override
  Future<List<Note>> readAll() async {
    final db = await _database;
    final rows = await db.query('notes', orderBy: 'id DESC');
    return rows.map((r) => Note.fromMap(r, id: r['id'] as int)).toList();
  }

  @override
  Future<void> update(Note note) async {
    final db = await _database;
    await db.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  @override
  Future<void> delete(int id) async {
    final db = await _database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
