import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/views/note_detail/note_detail_view_model.dart';
import 'package:notes_app/views/note_detail/widgets/confirm_dialog_widget.dart';
import 'package:notes_app/views/note_detail/widgets/edit_note_form_widget.dart';

class NoteDetailView extends ConsumerStatefulWidget {
  final String? id;
  const NoteDetailView(this.id, {super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoteDetailState();
}

class _NoteDetailState extends ConsumerState<NoteDetailView> {
  
  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      ref.read(noteDetailViewModel).get(widget.id!);
    } 
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (value) => ref.read(noteDetailViewModel).clear(),
      child: Scaffold(
        appBar: _appBar(),
        body: EditNoteFormWidget(
          formKey: ref.read(noteDetailViewModel).formKey,
          titleController: ref.read(noteDetailViewModel).titleController,
          contentController: ref.read(noteDetailViewModel).contentController,
          isReadOnly: ref.read(noteDetailViewModel).isReadOnly,
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('Note', style: TextStyle(fontSize: 20)),
      actions: [  
        _toggleEditBtn(),
        _saveBtn()
      ],
    );
  }

  Widget _toggleEditBtn() {
    return Visibility(
      visible: widget.id != null,
      child: IconButton(
        onPressed: () => ref.read(noteDetailViewModel).toggleEdit(),
        icon: Icon(ref.read(noteDetailViewModel).isReadOnly ? Icons.edit : Icons.remove_red_eye),
      ),
    );
  }

  Widget _saveBtn() {
    return Visibility(
      visible: !ref.watch(noteDetailViewModel).isReadOnly,
      child: IconButton(
        onPressed: () {
          if (ref.watch(noteDetailViewModel).formKey.currentState!.validate()) {
            showDialog(
              context: context,
              builder: (context) {          
                return ConfirmDialogWidget(
                  approveText: 'Save',
                  cancelText: 'Discard',
                  content: 'Save changes...?',
                  onApprove: () {
                    final title = ref.read(noteDetailViewModel).titleController.text;
                    final content = ref.read(noteDetailViewModel).contentController.text;
                    if (widget.id == null) {
                      ref.read(noteDetailViewModel).add(title, content);
                      Navigator.popUntil(context, ModalRoute.withName('/home'));
                    } else {
                      ref.read(noteDetailViewModel).update(widget.id!, title, content);
                      Navigator.popUntil(context, ModalRoute.withName('/home'));
                    }});
              });
          }},
        icon: const Icon(Icons.save)
      )
    );
  }

}