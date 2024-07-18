import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/repositories/note_repo.dart';
import 'package:notes_app/repositories/user_repo.dart';

final searchViewModel = ChangeNotifierProvider(
  (ref) => SearchViewModel(ref.read(noteRepoProvider), ref.read(userRepoProvider))
);

class SearchViewModel extends ChangeNotifier {
  List<Color> noteBg = const [
    Color.fromRGBO(253, 153, 255, 1),
    Color.fromRGBO(255, 158, 158, 1),
    Color.fromRGBO(145, 244, 143, 1),
    Color.fromRGBO(255, 245, 153, 1),
    Color.fromRGBO(158, 255, 255, 1),
  ];

  late final NoteRepo _noteRepo;
  late final UserRepo _userRepo;
  SearchViewModel(NoteRepo noteRepo, UserRepo userRepo) {
    _noteRepo = noteRepo;
    _userRepo = userRepo;
  }

  List<Note> notes = [];

  Future<void> filter(String title) async {
    notes =  await _noteRepo.filter(title, _userRepo.user?.id);
    notifyListeners();
  }
}