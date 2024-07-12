import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/repositories/note_repo.dart';

final homeProvider = ChangeNotifierProvider((ref) => HomeViewModel(ref.read(noteRepoProvider)));

class HomeViewModel extends ChangeNotifier {
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