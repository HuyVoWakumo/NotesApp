import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/views/home.dart';

class NoteItem extends ConsumerStatefulWidget {
  Note note;
  NoteItem(this.note, {super.key});

  @override
  NoteItemState createState() => NoteItemState();
  

}
class NoteItemState extends ConsumerState<NoteItem> {

  deleteNote(BuildContext context) {
    
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {

            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.info,
            label: 'Detail',
          ),
          SlidableAction(
            onPressed: (context) {
              showDialog(
                context: context, 
                builder: (context) => AlertDialog(
                  title: const Icon(Icons.warning),
                  content: const Text('Confirm delete ?'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      }, 
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(5),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Discard"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(notesProvider).delete(widget.note.id!);
                        Navigator.popUntil(context, ModalRoute.withName('/home'));
                      }, 
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(5),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Save"),
                    ),
                  ],
                )
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          )
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: Center(
          child: Text(widget.note.title),
        ),
      ),
    );
  }
}
