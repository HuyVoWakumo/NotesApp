import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/utils/validators.dart';
import 'package:notes_app/views/note_detail/note_detail_view_model.dart';

class NoteDetailView extends ConsumerStatefulWidget {
  final int? id;
  const NoteDetailView(this.id, {super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoteDetailState();
}

class _NoteDetailState extends ConsumerState<NoteDetailView> {
  
  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      ref.read(noteDetailProvider).get(widget.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [  
          Visibility(
            visible: widget.id != null,
            child: IconButton(
              onPressed: () => ref.read(noteDetailProvider).toggleEdit(),
              icon: Icon(ref.read(noteDetailProvider).isReadOnly ? Icons.edit : Icons.remove_red_eye),
            ),
          ),
          Visibility(
            visible: !ref.watch(noteDetailProvider).isReadOnly,
            child: IconButton(
              onPressed: () {
                if (ref.watch(noteDetailProvider).formKey.currentState!.validate()) {
                  showDialog(
                    context: context,
                    builder: (context) {          
                      return AlertDialog(
                        title: const Icon(Icons.info),
                        content: const Text("Save changes ?", textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
                        actionsAlignment: MainAxisAlignment.spaceAround,
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            }, 
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.only(top: 2, bottom: 2, left: 6, right: 6),
                              backgroundColor: const Color.fromARGB(241, 243, 74, 62),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                            ),
                            child: const Text("Discard"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              final title = ref.read(noteDetailProvider).titleController.text;
                              final content = ref.read(noteDetailProvider).contentController.text;
                              if (widget.id == null) {
                                ref.read(noteDetailProvider).add(title, content);
                                Navigator.popUntil(context, ModalRoute.withName('/home'));
                              } else {
                                ref.read(noteDetailProvider).update(widget.id!, title, content);
                                Navigator.popUntil(context, ModalRoute.withName('/home'));
                              }
                            }, 
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.only(top: 2, bottom: 2, left: 6, right: 6),
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
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
          )
        ],
      ),
      body: Form(
        key: ref.read(noteDetailProvider).formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              validator: validateEmpty,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              readOnly: ref.read(noteDetailProvider).isReadOnly,
              controller: ref.read(noteDetailProvider).titleController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "Title",
                border: InputBorder.none,
              ),
              style: const TextStyle(
                fontSize: 30,
                overflow: TextOverflow.ellipsis
              ),
            ),
            const Divider(),
            TextFormField(
              validator: validateEmpty,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              readOnly: ref.read(noteDetailProvider).isReadOnly,
              controller: ref.read(noteDetailProvider).contentController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "Enter something ...",
                border: InputBorder.none,
              ),
              style: const TextStyle(
                overflow: TextOverflow.ellipsis
              ),
            )
          ],
        ),
      ),
    );
  }

}