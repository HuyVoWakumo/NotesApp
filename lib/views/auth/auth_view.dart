import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/views/auth/auth_view_model.dart';
import 'package:notes_app/views/auth/widgets/sign_form_widget.dart';

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
          SignFormWidget(
            formKey: ref.read(authViewModel).formKey,
            emailController: ref.read(authViewModel).emailController,
            passwordController: ref.read(authViewModel).passwordController,
            confirmPasswordController: ref.read(authViewModel).confirmPasswordController,
            isSignin: ref.watch(authViewModel).isSignIn,
            onSignIn: () => ref.read(authViewModel).signInWithPassword(context),
            onSignUp: () => ref.read(authViewModel).signUp(context),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 10),
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