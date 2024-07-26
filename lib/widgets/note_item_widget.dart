import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/views/note_detail/note_detail_view_model.dart';

class NoteItemWidget extends ConsumerStatefulWidget {
  final Note note;
  final Color backgroundColor;
  const NoteItemWidget(this.note, {this.backgroundColor = Colors.white60, super.key});

  @override
  ConsumerState<NoteItemWidget> createState() => _NoteItemState();
}
class _NoteItemState extends ConsumerState<NoteItemWidget> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ref.read(noteDetailViewModel).isReadOnly = true;
        Navigator.pushNamed(context, '/note-detail', arguments: { 'id' : widget.note.id });
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          color: widget.backgroundColor,
        ),
        child: Center(
          child: Text(
            widget.note.title, 
            maxLines: 2,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
      )
    );
  }
}
