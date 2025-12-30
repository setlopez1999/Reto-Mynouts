import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Notes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // CRUD - CREATE
  Future<int> createNote(NotesCompanion note) async {
    return await into(notes).insert(note);
  }

  // CRUD - READ de todas las tarjetas
  Stream<List<Note>> watchAllNotes() {
    return (select(notes)
          ..orderBy([
            (t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc)
          ]))
        .watch();
  }

  // CRUD - READ de una sola por id
  Stream<Note> watchNote(int id) {
    return (select(notes)..where((t) => t.id.equals(id))).watchSingle();
  }

  // CRUD - UPDATE
  Future<bool> updateNote(Note note) async {
    return await update(notes).replace(note);
  }

  // CRUD - DELETE
  Future<int> deleteNote(int id) async {
    return await (delete(notes)..where((t) => t.id.equals(id))).go();
  }
}
// Conexión a la base de datos
// Usando LazyDatabase para abrir la conexión cuando sea necesario
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'notes.sqlite'));
    return NativeDatabase(file);
  });
}