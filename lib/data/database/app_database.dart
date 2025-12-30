import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Notes])// tablas que usara drift
class AppDatabase extends _$AppDatabase {// hago que herede de la clase generada por drift
  AppDatabase() : super(_openConnection());// _openConnection es un QueryExecutor
  //constructor que llama al contructor de la clase padre
  // le damos al padre la conexión a la base de datos

  @override
  int get schemaVersion => 1; // version de la base de datos

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
        .watch();// watch retorna un Stream de List<Note>
  }

  // CRUD - READ de una sola por id
  Stream<Note> watchNote(int id) {
    return (select(notes)..where((t) => t.id.equals(id))).watchSingle();
    //watch single retorna solo 1 elemento Stream
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
// Usando LazyDatabase para abrir la conexión cuando se haga una consulta real
LazyDatabase _openConnection() {
  return LazyDatabase(() async { // la función que abre la conexión es asíncrona
    // ruta segura y persistente 
    //flutter pregunta porque no controla el SO donde esta xd
    // y await porque en getApplicationDocumentsDirectory no controlamos el tiempo de respuesta del SO
    final dbFolder = await getApplicationDocumentsDirectory(); 
    final file = File(p.join(dbFolder.path, 'notes.sqlite'));//une rutas para diferentes SO
    return NativeDatabase(file);
  });
}