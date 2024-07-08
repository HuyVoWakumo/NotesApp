import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/utils/validators.dart';
import 'package:notes_app/views/home.dart';

class NoteEditor extends ConsumerStatefulWidget {
  int? id;
  NoteEditor(this.id, {super.key});

   @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoteEditorState();
}

class _NoteEditorState extends ConsumerState<NoteEditor> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


@override
  void initState() {
    super.initState();
    if (widget.id != null) {
      ref.read(notesProvider).get(widget.id!)
      .then((value) {
        titleController.text = value != null ? value.title: "";
        contentController.text = value != null ? value.content : "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBar(context),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              validator: validateEmpty,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: titleController,
              decoration: InputDecoration(
                hintText: titleController.text == '' ? "Title" : null
              ),
              maxLines: null,
              style: const TextStyle(
                fontSize: 25,
                overflow: TextOverflow.ellipsis,
              )
            ),
            const SizedBox(height: 20),
            TextFormField(
              validator: validateEmpty,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: contentController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: contentController.text == '' ? "Type something" : null
              ),
              maxLines: null,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis
              )
            )
          ],
        ),
      )
    );
  }

  appBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              showDialog(
                context: context,
                builder: (context) {          
                  return AlertDialog(
                    title: const Icon(Icons.info),
                    content: const Text("Save changes ?", textAlign: TextAlign.center),
                    actionsAlignment: MainAxisAlignment.spaceAround,
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
                          final title = titleController.text;
                          final content = contentController.text;
                          if (widget.id == null) {
                            ref.read(notesProvider).add(title, content);
                            Navigator.popUntil(context, ModalRoute.withName('/home'));
                          } else {
                            ref.read(notesProvider).update(widget.id!, title, content);
                            Navigator.popUntil(context, ModalRoute.withName('/home'));
                          }
                        }, 
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(5),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Save"),
                      ),
                    ],
                  );
                }
              );
            }
          },
          icon: const Icon(Icons.save)
        )
      ],
    );
  }

}