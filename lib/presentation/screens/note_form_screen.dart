import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import '../../data/database/app_database.dart';
import '../../providers/database_provider.dart';

class NoteFormScreen extends ConsumerStatefulWidget {
  final int? noteId;

  const NoteFormScreen({super.key, this.noteId});

  @override
  ConsumerState<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends ConsumerState<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.noteId != null;

    // Si estamos editando, cargar datos
    if (isEditing) {
      final noteAsync = ref.watch(noteProvider(widget.noteId!));
      
      noteAsync.whenData((note) {
        if (_titleController.text.isEmpty) {
          _titleController.text = note.title;
          _contentController.text = note.content;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Nota' : 'Nueva Nota'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Campo Título
            TextFormField(
              style: const TextStyle(color: Colors.white),
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
                
              ),
              
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El título es obligatorio';
                }
                if (value.length > 200) {
                  return 'Máximo 200 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Campo Contenido
            TextFormField(
              style: const TextStyle(color: Colors.white),
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Contenido',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 10,
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El contenido es obligatorio';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            // Botón Guardar
            FilledButton.icon(
              onPressed: _isLoading ? null : _saveNote,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(isEditing ? 'Actualizar' : 'Guardar'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final database = ref.read(databaseProvider);
      final now = DateTime.now();

      if (widget.noteId == null) {
        // Crear nueva nota
        await database.createNote(
          NotesCompanion(
            title: drift.Value(_titleController.text.trim()),
            content: drift.Value(_contentController.text.trim()),
            createdAt: drift.Value(now),
            updatedAt: drift.Value(now),
          ),
        );
      } else {
        // Actualizar nota existente
        final noteStream = database.watchNote(widget.noteId!);
        final note = await noteStream.first; // ✅ Correcto: first sobre el Stream
        
        await database.updateNote(
          note.copyWith(
            title: _titleController.text.trim(),
            content: _contentController.text.trim(),
            updatedAt: now,
          ),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.noteId == null ? 'Nota creada' : 'Nota actualizada',
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}