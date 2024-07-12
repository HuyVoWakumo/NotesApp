import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/repositories/note_repo.dart';

final searchViewModel = ChangeNotifierProvider((ref) => SearchViewModel(ref.read(noteRepoProvider)));

class SearchViewModel extends ChangeNotifier {
  late final NoteRepo _repo;
  SearchViewModel(NoteRepo repo) {
    _repo = repo;
  }

  List<Note> notes = [];

  filter(String title) async {
    notes =  await _repo.filter(title);
    notifyListeners();
  }
}