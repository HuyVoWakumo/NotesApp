import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/repositories/note_repo.dart';

final homeProvider = ChangeNotifierProvider((ref) => HomeViewModel(ref.read(noteRepoProvider)));

class HomeViewModel extends ChangeNotifier {
  List<Color> noteBg = const [
    Color.fromRGBO(253, 153, 255, 1),
    Color.fromRGBO(255, 158, 158, 1),
    Color.fromRGBO(145, 244, 143, 1),
    Color.fromRGBO(255, 245, 153, 1),
    Color.fromRGBO(158, 255, 255, 1),
  ];


  late final NoteRepo _repo;
  List<Note> notes = [];

  HomeViewModel(NoteRepo repo) {
    _repo = repo;
  }

  Future<void> getAll() async {
    notes = await _repo.getAll();
    notifyListeners();
  }

  Future<void> delete(int id) async {
    await _repo.delete(id);
    await getAll();
  }
}