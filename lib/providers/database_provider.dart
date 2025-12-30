import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database/app_database.dart';

// Provider de la base de datos (singleton)
final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(() => database.close());
  return database;
});

// Provider del stream de todas las notas
final notesStreamProvider = StreamProvider<List<Note>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.watchAllNotes();
});

// Provider para una nota específica por ID
final noteProvider = StreamProvider.family<Note, int>((ref, id) {
  final database = ref.watch(databaseProvider);
  return database.watchNote(id);
});