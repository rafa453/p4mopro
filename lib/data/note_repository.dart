import 'note.dart';

/// Kontrak CRUD yang sama untuk kedua storage, supaya perbandingannya apple-to-apple.
abstract class NoteRepository {
  String get name;
  Future<Note> create(Note note);
  Future<List<Note>> readAll();
  Future<void> update(Note note);
  Future<void> delete(int id);
}