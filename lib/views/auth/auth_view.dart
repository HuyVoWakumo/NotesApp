import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/views/auth/auth_view_model.dart';
import 'package:notes_app/views/auth/widgets/sign_form.dart';

class AuthView extends ConsumerWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          _title(),
          const SizedBox(height: 50),
          const SignForm(),
          const SizedBox(height: 30),
          _otherMethods(ref),
          const SizedBox(height: 100),
          _useOfflineText(context),
        ]
      )
    );
  }

  Widget _title() {
    return const Text(
      'Notes App',
      style: TextStyle(
        fontSize: 40,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _otherMethods(WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: ref.read(authViewModel).toggleSignIn, 
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            fixedSize: const Size(180, 30)
          ),
          child: Text(ref.watch(authViewModel).isSignIn ? 'New account?' : 'Have an account?'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: null, 
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(180, 30)
          ),
          child: const Text('Google'),
        )
      ],
    );
  }

  Widget _useOfflineText(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/home');
      },
      child: const Text(
        'Continue using offline', 
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.white, decoration: TextDecoration.underline)
      ),
    );
  }

}