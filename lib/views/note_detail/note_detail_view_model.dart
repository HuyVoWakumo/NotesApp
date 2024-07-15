import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/repositories/note_repo.dart';

final noteDetailProvider = ChangeNotifierProvider((ref) => NoteDetailViewModel(ref.read(noteRepoProvider)));

class NoteDetailViewModel extends ChangeNotifier {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isReadOnly = true;
  late final NoteRepo _repo;
  Note? note;

  NoteDetailViewModel(NoteRepo repo) {
    _repo = repo;
  }

  Future<void> get(int id) async {
    final note = await _repo.get(id);
    titleController.text = note!.title;
    contentController.text = note.content;
    notifyListeners();
  }

  Future<void> add(String title, String content) async {
    note = Note(
      id: null,
      title: title,
      content: content,
    );
    await _repo.add(note!);
    notifyListeners();
  }

  Future<void> update(int id, String title, String content) async {
    note = Note(
      id: id,
      title: title,
      content: content,
    );
    await _repo.update(note!);
    notifyListeners();
  }

  void toggleEdit() {
    isReadOnly = !isReadOnly;
    notifyListeners();
  }

  void clear() {
    titleController.clear();
    contentController.clear();
    notifyListeners();
  }

}