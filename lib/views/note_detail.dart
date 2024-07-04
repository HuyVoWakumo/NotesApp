import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/views/home.dart';
import 'package:notes_app/views/note_editor.dart';

class NoteDetail extends ConsumerStatefulWidget {
  int id;
  NoteDetail(this.id, {super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoteDetailState();
}

class _NoteDetailState extends ConsumerState<NoteDetail> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  var currentNote;

  @override
  void initState() {
    super.initState();
    ref.read(notesProvider).get(widget.id);
    currentNote = ref.read(notesProvider.notifier).currentNote;
    titleController.text = currentNote != null ? currentNote.title: "";
    contentController.text = currentNote != null ? currentNote.content : "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [  
          IconButton(
            onPressed: () =>
              currentNote != null 
              ? Navigator.push(context, MaterialPageRoute(builder: (context) => NoteEditor(widget.id)))
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