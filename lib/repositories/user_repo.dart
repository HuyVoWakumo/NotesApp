import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/datasource/remote/user_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final userRepoProvider = Provider<UserRepo>(
  (ref)=> UserRepo(ref.read(userRemoteProvider))
);

class UserRepo {
  static UserRemoteDatasource? _userRemote;
  User? user;
  UserRepo(UserRemoteDatasource userRemote) {
    _userRemote = userRemote;
  }

  Future<void> signInWithPassword(String email, String password) async {
    final authResponse = await _userRemote!.signInWithPassword(email, password);
    user = authResponse.user;
    log(authResponse.session.toString());
  }

  Future<void> signUp(String email, String password) async {
    final authResponse = await _userRemote!.signUp(email, password);
    user = authResponse.user;
    log(authResponse.session.toString());
  }

  Future<void> signOut() async {
    await _userRemote!.signOut();
    user = null;
  }

  User? checkCurrentUser() {
    user = _userRemote!.checkCurrentUser();
    return user;
  }
}