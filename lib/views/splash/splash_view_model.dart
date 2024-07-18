import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/repositories/user_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final splashViewModel = ChangeNotifierProvider.autoDispose(
  (ref) => SplashViewModel(ref.read(userRepoProvider))
);

class SplashViewModel extends ChangeNotifier {
  late final UserRepo _userRepo;

  SplashViewModel(UserRepo userRepo) {
    _userRepo = userRepo;
  }

  User? checkCurrentUser() {
    return _userRepo.checkCurrentUser();
  }
}