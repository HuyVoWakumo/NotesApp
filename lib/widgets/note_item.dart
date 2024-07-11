import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/views/home.dart';
import 'package:notes_app/views/note_detail.dart';

// TODO REVIEW:
// No more state here, consider to use stateless only
class NoteItem extends ConsumerStatefulWidget {
  Note note;
  Color backgroundColor;
  NoteItem(this.note, {this.backgroundColor = Colors.white60, super.key});

  @override
  ConsumerState<NoteItem> createState() => _NoteItemState();
}
class _NoteItemState extends ConsumerState<NoteItem> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NoteDetail(widget.note.id!)));
              },
              backgroundColor: const Color.fromARGB(255, 53, 158, 244),
              foregroundColor: Colors.white,
              icon: Icons.info,
              label: 'Detail',
            ),
            SlidableAction(
              onPressed: (context) {
                showDialog(
                  context: context, 
                  builder: (context) => AlertDialog(
                    alignment: Alignment.center,
                    title: const Icon(Icons.warning),
                    content: const Text('Confirm delete ?', textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
                    actionsAlignment: MainAxisAlignment.spaceAround,
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        }, 
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(top: 2, bottom: 2, left: 6, right: 6),
                          backgroundColor: Color.fromARGB(241, 243, 74, 62),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                        ),
                        child: const Text("Discard"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(notesProvider).delete(widget.note.id!);
                          Navigator.popUntil(context, ModalRoute.withName('/home'));
                        }, 
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(top: 2, bottom: 2, left: 6, right: 6),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                        ),
                        child: const Text("Delete"),
                      ),
                    ],
                  )
                );
              },
              borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            )
          ],
        ),
        child: Container(
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
          ),
        ),
      ),
    );
  }
}
