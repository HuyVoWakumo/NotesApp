import 'package:flutter/material.dart';
import 'package:notes_app/utils/validators.dart';

class EditNoteFormWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextFormField(
            validator: validateEmpty,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            readOnly: isReadOnly,
            controller: titleController,
            maxLines: null,
            decoration: InputDecoration(
              hintText: titleController.text == '' ? "Title": null,
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
            readOnly: isReadOnly,
            controller: contentController,
            maxLines: null,
            decoration:  InputDecoration(
              hintText: contentController.text == '' ? "Enter something ..." : null,
              border: InputBorder.none,
            ),
            style: const TextStyle(
              overflow: TextOverflow.ellipsis
            ),
          )
        ],
      ),
    );
  }
}