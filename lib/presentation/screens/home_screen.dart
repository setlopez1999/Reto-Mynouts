import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/database_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyNouts', style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
        )),
        centerTitle: true,
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: notesAsync.when(
        data: (notes) {
          if (notes.isEmpty) {
            return const _EmptyState();
          }
          return _CardsState(notes: notes);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/note/create'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Nueva nota'),
      ),


    );
  }
}



//componentes privados
class _EmptyState extends StatelessWidget {
  // ignore: unused_element_parameter
  const _EmptyState({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_add_rounded,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No hay notas',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Toca el botón + para crear una',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

// Grid de las notas 
class _CardsState extends StatelessWidget {
  final List<dynamic> notes;
  // ignore: unused_element_parameter
  const _CardsState({super.key,required this.notes});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive: cambia columnas según ancho
        int crossAxisCount = 1;
        double size = constraints.maxWidth;
        if(size > 800){
          crossAxisCount = 4;
        }else if(size > 600){
          crossAxisCount = 3;
        }else if(size >300){
          crossAxisCount = 2;
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return _NoteCard(
              key: ValueKey(note.id),  
              note: note
            );
          },
        );
      },
    );



  }
}

// Tarjeta individual de cada nota
class _NoteCard extends StatelessWidget {
  final dynamic note;

  const _NoteCard({super.key,required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      
      elevation: 2,
      child: InkWell(
        onTap: () => context.push('/note/${note.id}'),
        borderRadius: BorderRadius.circular(12),
        //hoverColor: Color.fromARGB(112, 9, 126, 38),
        //onLongPress: () => Clip.none,//cambio a futuro
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 184, 184, 184)
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  note.content,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _formatDate(note.updatedAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoy ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}