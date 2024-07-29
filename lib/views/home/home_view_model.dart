import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
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
  late final StreamSubscription<List<ConnectivityResult>> internetSubscription;
  List<Note> notes = [];
  bool hasInternetConnection = true;

  HomeViewModel(NoteRepo noteRepo, UserRepo userRepo) {
    _noteRepo = noteRepo;
    _userRepo = userRepo;
    // internetSubscription
    //   = Connectivity().onConnectivityChanged.listen(
    //     (List<ConnectivityResult> result) async {
    //       if (result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)) {
    //         hasInternetConnection = true;
    //         log('Has internet connection');
    //         if (_userRepo.user != null) {
    //           notes = await _noteRepo.sync(_userRepo.user!.id);
    //         }
    //         notifyListeners();
    //       } else if (result.contains(ConnectivityResult.none)) {
    //         hasInternetConnection = false;
    //         notifyListeners();
    //         log('No internet connection');
    //       }
    // });
  }

  Future<void> getAll() async {
    if (_userRepo.user == null || !hasInternetConnection) {
      notes = await _noteRepo.getAllNotArchiveLocal();
    } else {
      await sync();
    }
    notifyListeners();
  } 

  Future<void> sync() async {
    notes = await _noteRepo.sync(_userRepo.user!.id);
  }

  User? checkCurrentUser() {
    return _userRepo.checkCurrentUser();
  }

  Future<void> signOut() async {
    await _userRepo.signOut();
  }

  Future<void> refresh() async {
    if (_userRepo.user != null ) {
      notes = await _noteRepo.sync(_userRepo.user!.id);
    }
    notifyListeners();
  }
}