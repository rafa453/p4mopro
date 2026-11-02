import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'note.dart';
import 'note_repository.dart';

class SembastNoteRepository implements NoteRepository {
  static Database? _db;
  final _store = intMapStoreFactory.store('notes');

  @override
  String get name => 'Sembast';

  Future<Database> get _database async => _db ??= await _open();

  Future<Database> _open() async {
    if (kIsWeb) {
      return databaseFactoryWeb.openDatabase('notes_sembast.db');
    }
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    return databaseFactoryIo.openDatabase(join(dir.path, 'notes_sembast.db'));
  }

  @override
  Future<Note> create(Note note) async {
    final db = await _database;
    final id = await _store.add(db, note.toMap());
    return note.copyWith(id: id);
  }

  @override
  Future<List<Note>> readAll() async {
    final db = await _database;
    final snaps = await _store.find(
      db,
      finder: Finder(sortOrders: [SortOrder(Field.key, false)]),
    );
    return snaps.map((s) => Note.fromMap(s.value, id: s.key)).toList();
  }

  @override
  Future<void> update(Note note) async {
    final db = await _database;
    await _store.record(note.id!).update(db, note.toMap());
  }

  @override
  Future<void> delete(int id) async {
    final db = await _database;
    await _store.record(id).delete(db);
  }
}