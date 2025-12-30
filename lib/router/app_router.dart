
import 'package:go_router/go_router.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/note_detail_screen.dart';
import '../presentation/screens/note_form_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Ruta 1: Home - Lista de notas
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    
    // Ruta 3: Crear nota
    GoRoute(
      path: '/note/create',
      name: 'note-create',
      builder: (context, state) => const NoteFormScreen(),
    ),
    
    // Ruta 4: Editar nota
    GoRoute(
      path: '/note/:id/edit',
      name: 'note-edit',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return NoteFormScreen(noteId: id);
      },
    ),
    // Ruta 2: Detalle de nota (Deep link compatible)
    GoRoute(
      path: '/note/:id',
      name: 'note-detail',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return NoteDetailScreen(noteId: id);
      },
    ),
    
  ],
);