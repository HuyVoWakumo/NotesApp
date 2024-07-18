import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/repositories/note_repo.dart';
import 'package:notes_app/repositories/user_repo.dart';
import 'package:uuid/uuid.dart';

final noteDetailViewModel = ChangeNotifierProvider.autoDispose(
  (ref) => NoteDetailViewModel(ref.read(noteRepoProvider), ref.read(userRepoProvider))
);

const uuid = Uuid();

class NoteDetailViewModel extends ChangeNotifier {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isReadOnly = true;
  late final NoteRepo _noteRepo;
  late final UserRepo _userRepo;
  Note? note;

  NoteDetailViewModel(NoteRepo noteRepo, UserRepo userRepo) {
    _noteRepo = noteRepo;
    _userRepo = userRepo;
  }

  Future<void> get(String id) async {
    final note = await _noteRepo.get(id);
    titleController.text = note!.title;
    contentController.text = note.content;
    notifyListeners();
  }

  Future<void> add(String title, String content) async {
    note = Note(
      id: uuid.v4(),
      title: title,
      content: content,
      createdAt: DateTime.now().toString(),
      idUser: _userRepo.user?.id,
    );
    await _noteRepo.addLocal(note!);
    if (_userRepo.user != null) {
      await _noteRepo.addRemote(note!);
    }
    notifyListeners();
  }

  Future<void> update(String id, String title, String content) async {
    note = Note(
      id: id,
      title: title,
      content: content,
      createdAt: DateTime.now().toString(),
      idUser: _userRepo.user?.id,
    );
    await _noteRepo.updateLocal(note!);
    if(_userRepo.user != null) {
      await _noteRepo.updateRemote(note!);
    }
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