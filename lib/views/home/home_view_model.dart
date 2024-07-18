import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/repositories/note_repo.dart';
import 'package:notes_app/repositories/user_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final homeViewModel = ChangeNotifierProvider.autoDispose(
  (ref) => HomeViewModel(ref.read(noteRepoProvider), ref.read(userRepoProvider))
);

class HomeViewModel extends ChangeNotifier {
  List<Color> noteBg = const [
    Color.fromRGBO(253, 153, 255, 1),
    Color.fromRGBO(255, 158, 158, 1),
    Color.fromRGBO(145, 244, 143, 1),
    Color.fromRGBO(255, 245, 153, 1),
    Color.fromRGBO(158, 255, 255, 1),
  ];


  late final NoteRepo _noteRepo;
  late final UserRepo _userRepo;
  List<Note> notes = [];

  HomeViewModel(NoteRepo noteRepo, UserRepo userRepo) {
    _noteRepo = noteRepo;
    _userRepo = userRepo;
  }

  Future<void> getAll() async {
    notes = await _noteRepo.getAll(_userRepo.user?.id);
    notifyListeners();
  } 

  Future<void> delete(String id) async {
    await _noteRepo.deleteLocal(id);
    if (_userRepo.user != null) {
      await _noteRepo.deleteRemote(id);
    }
    await getAll();
  }

  User? checkCurrentUser() {
    return _userRepo.checkCurrentUser();
  }

  Future<void> signOut() async {
    await _userRepo.signOut();
  }
}