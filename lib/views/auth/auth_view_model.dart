import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/repositories/user_repo.dart';

final authViewModel = ChangeNotifierProvider.autoDispose(
  (ref) => AuthViewModel(ref.read(userRepoProvider))
);

class AuthViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isSignIn = true;

  late final UserRepo _userRepo;
  AuthViewModel(UserRepo userRepo) {
    _userRepo = userRepo;
  }
  
  Future<void> signInWithPassword(BuildContext context) async {
    try {
      if(formKey.currentState!.validate()) {
        await _userRepo.signInWithPassword(
          emailController.text, 
          passwordController.text
        );
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Sign in failed')
      ));
    }
  }   
  
  Future<void> signUp(BuildContext context) async {
    try {
      if(formKey.currentState!.validate()) {
        if (passwordController.text == confirmPasswordController.text) {
          await _userRepo.signUp(
            emailController.text, 
            passwordController.text
          );
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Passwords not match')
          ));
        } 
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Sign up failed')
      ));
    }
  }

  void toggleSignIn() {
    isSignIn = !isSignIn;
    notifyListeners();
  }
  
}