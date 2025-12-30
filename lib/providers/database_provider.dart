import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database/app_database.dart';

// Provider de la base de datos singleton
//Provider no guarda estado, solo instancia
// ref es para manejar el ciclo de vida del provider
//Returna una instancia de AppDatabase
final databaseProvider = Provider<AppDatabase>((ref) {
  // esto no crea la bd al inciar la app
  // lo hace cuando se pide una watch o read del provider ln 18 o 24
  final database = AppDatabase();
  // Cuando no usen la bd se cierra la conexión
  ref.onDispose(() => database.close());
  return database;
});

// Provider del stream de todas las notas
// Stream quiere decir que cada vez que haya un cambio en la bd
// se notificará a los listeners (widgets que usen este provider)
final notesStreamProvider = StreamProvider<List<Note>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.watchAllNotes();
});

// Provider para una nota específica por ID
// el parametro family permite pasar argumentos al provider
final noteProvider = StreamProvider.family<Note, int>((ref, id) {
  final database = ref.watch(databaseProvider);
  return database.watchNote(id);
});