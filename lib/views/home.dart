import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/view_models/note_viewmodel.dart';
import 'package:notes_app/views/note_editor.dart';
import 'package:notes_app/widgets/note_item.dart';

final notesProvider = ChangeNotifierProvider((ref) => NoteNotifier());

class Home extends ConsumerWidget {

  addNote(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NoteEditor()))
    .then((value) {

    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: appBar(),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: ref.watch(notesProvider).notes.map((note) => NoteItem(note)).toList(),
      ),
      // floatingActionButton: IconButton(
      //   onPressed: addNote(context),
      //   icon: const Icon(Icons.add),
      // ),
    );
  }

  appBar() {
    return AppBar(
      title: const Text('Notes', style: TextStyle(fontSize: 20)),
      actions: [
        IconButton(
          onPressed: () {

          },
          icon: const Icon(Icons.search),
        ),
        IconButton(
          onPressed: () {

          }, 
          icon: const Icon(Icons.info_outline),
        )
      ],
    );
  }

}


