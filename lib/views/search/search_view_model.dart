import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/repositories/note_repo.dart';

final searchViewModel = ChangeNotifierProvider((ref) => SearchViewModel(ref.read(noteRepoProvider)));

class SearchViewModel extends ChangeNotifier {
  List<Color> noteBg = const [
    Color.fromRGBO(253, 153, 255, 1),
    Color.fromRGBO(255, 158, 158, 1),
    Color.fromRGBO(145, 244, 143, 1),
    Color.fromRGBO(255, 245, 153, 1),
    Color.fromRGBO(158, 255, 255, 1),
  ];

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