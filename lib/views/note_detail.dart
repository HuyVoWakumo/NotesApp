import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/views/home.dart';

class NoteDetail extends ConsumerStatefulWidget {
  const NoteDetail({super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoteDetailState();
}

class _NoteDetailState extends ConsumerState<NoteDetail> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    ref.read(notesProvider).get(args['id']);
    var currentNote = ref.watch(notesProvider).currentNote;
    titleController.text = currentNote != null ? currentNote.title: "";
    contentController.text = currentNote != null ? currentNote.content : "";

    return Scaffold(
      appBar: AppBar(
        actions: [  
          IconButton(
            onPressed: () =>
              currentNote != null 
              ? Navigator.pushNamed(context, '/note-editor', arguments: { 'id' : currentNote.id })
                // .then((value) => ref.read(notesProvider).currentNote = null) 
              : null,
            icon: const Icon(Icons.edit)
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            readOnly: true,
            controller: titleController,
            maxLines: 2,
            style: const TextStyle(
              overflow: TextOverflow.ellipsis
            ),
          ),
          TextField(
            readOnly: true,
            controller: contentController,
            maxLines: 10,
            style: const TextStyle(
              overflow: TextOverflow.ellipsis
            ),
          )
        ],
      ),
    );
  }

}