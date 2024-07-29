import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/utils/validators.dart';
import 'package:notes_app/views/note_detail/note_detail_view_model.dart';

class EditNoteFormWidget extends ConsumerStatefulWidget {
  final Key formKey;
  final TextEditingController titleController;
  final TextEditingController contentController;
  bool isReadOnly;
  
  EditNoteFormWidget({ super.key, 
    required this.formKey, 
    required this.titleController, 
    required this.contentController,
    required this.isReadOnly
  });

  @override
  ConsumerState<EditNoteFormWidget> createState() => _EditNoteFormWidgetState();
}

class _EditNoteFormWidgetState extends ConsumerState<EditNoteFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextFormField(
            validator: validateEmpty,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            readOnly: widget.isReadOnly,
            controller: widget.titleController,
            maxLines: null,
            decoration: InputDecoration(
              hintText: widget.titleController.text == '' ? "Title": null,
              border: InputBorder.none,
            ),
            style: const TextStyle(
              fontSize: 30,
              overflow: TextOverflow.ellipsis
            ),
            onChanged: (value) {
              log(value);
              ref.read(noteDetailViewModel).compare();
            },
          ),
          const Divider(),
          TextFormField(
            validator: validateEmpty,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            readOnly: widget.isReadOnly,
            controller: widget.contentController,
            maxLines: null,
            decoration:  InputDecoration(
              hintText: widget.contentController.text == '' ? "Enter something ..." : null,
              border: InputBorder.none,
            ),
            style: const TextStyle(
              overflow: TextOverflow.ellipsis
            ),
            onChanged: (value) {
              log(value);
              ref.read(noteDetailViewModel).compare();
            },
          )
        ],
      ),
    );
  }
}