import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/utils/validators.dart';
import 'package:notes_app/views/auth/auth_view_model.dart';
import 'package:notes_app/views/auth/widgets/password_text_field_widget.dart';

class SignForm extends ConsumerWidget {
  const SignForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: ref.read(authViewModel).formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            validator: validateEmpty,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: ref.read(authViewModel).emailController,
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "Enter your email...",
              border: OutlineInputBorder(
                borderSide: const BorderSide(width: 1, color: Colors.white),
                borderRadius: BorderRadius.circular(20),
              )
            )
          ),
          const SizedBox(height: 10),
          PasswordTextFieldWidget(
            validator: validateEmpty,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: ref.read(authViewModel).passwordController,
            label: const Text('Password'),
          ),
          const SizedBox(height: 10),
          Visibility(
            visible: !ref.watch(authViewModel).isSignIn,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PasswordTextFieldWidget(
                  validator: validateEmpty,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: ref.read(authViewModel).confirmPasswordController,
                  label: const Text('Confirm password'),
                ),
                const SizedBox(height: 10),
              ]
            ), 
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ref.watch(authViewModel).isSignIn
                    ? ref.read(authViewModel).signInWithPassword(context)
                    : ref.read(authViewModel).signUp(context);
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  child: Text(ref.watch(authViewModel).isSignIn ? 'Sign in' : 'Sign up', style: const TextStyle(fontSize: 20)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  } 


  
}