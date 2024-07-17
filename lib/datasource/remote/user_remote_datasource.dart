import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final userRemoteProvider = Provider<UserRemoteDatasource>(
  (ref) => UserRemoteDatasource()
);

class UserRemoteDatasource {
  UserRemoteDatasource._();
  static final UserRemoteDatasource _instance = UserRemoteDatasource._();
  final _supabase = Supabase.instance.client;
  
  factory UserRemoteDatasource() {
    return _instance;
  }

  Future<AuthResponse> signInWithPassword(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password
    );
  }

  Future<AuthResponse> signUp(String email, String password) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password
    );
  }

}