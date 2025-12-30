import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/database_provider.dart';

class NoteDetailScreen extends ConsumerWidget {
  final int noteId;

  const NoteDetailScreen({super.key, required this.noteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteAsync = ref.watch(noteProvider(noteId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/note/$noteId/edit'),
            tooltip: 'Editar',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, ref),
            tooltip: 'Eliminar',
          ),
        ],
      ),
      body: noteAsync.when(
        data: (note) { return _DetailNoteWidget(note: note); },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _NoteNotFoundWidget(),
      ),
    );
  }



  // CConfirmación de borrado de nota
  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar nota?', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
        content: const Text('Esta acción no se puede deshacer.', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              final database = ref.read(databaseProvider);
              await database.deleteNote(noteId);
              if (context.mounted) {
                Navigator.pop(context); // Cierra diálogo
                context.go('/'); // Vuelve a home
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

}

String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
}

class _DetailNoteWidget extends StatelessWidget {

  final dynamic note;
  const _DetailNoteWidget({required this.note});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Text(
            note.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          
          // Fecha
          Text(
            'Actualizado: ${_formatDate(note.updatedAt)}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const Divider(height: 32),
          
          // Contenido
          Text(
            note.content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoteNotFoundWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.note_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Nota no encontrada',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}