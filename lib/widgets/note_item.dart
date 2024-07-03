import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/models/note_model.dart';

class NoteItem extends ConsumerWidget {
  Note note;
  NoteItem(this.note, {super.key});

  deleteNote() {

  }

  viewNoteDetail() {

  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onLongPress: deleteNote,
      onTap: viewNoteDetail,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: Center(
          child: Text(note.title),
        ),
      ),
    );
  }
}