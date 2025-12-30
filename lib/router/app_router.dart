
import 'package:go_router/go_router.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/note_detail_screen.dart';
import '../presentation/screens/note_form_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // al home - Lista de notas
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    
    // crear nota
    GoRoute(
      path: '/note/create',
      name: 'note-create',
      builder: (context, state) => const NoteFormScreen(),
    ),
    
    // editar nota
    GoRoute(
      path: '/note/:id/edit',
      name: 'note-edit',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return NoteFormScreen(noteId: id);
      },
    ),
    // detalle de nota (Deep link compatible)
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