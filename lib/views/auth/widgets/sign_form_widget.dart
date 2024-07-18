import 'package:flutter/material.dart';
import 'package:notes_app/utils/validators.dart';
import 'package:notes_app/views/auth/widgets/password_text_field_widget.dart';

class SignFormWidget extends StatelessWidget {
  final Key formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  bool isSignin;
  final void Function() onSignIn;
  final void Function() onSignUp;
  SignFormWidget({
    required this.formKey, 
    required this.emailController, 
    required this.passwordController, 
    required this.confirmPasswordController, 
    required this.isSignin,
    required this.onSignIn, 
    required this.onSignUp, 
    super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            validator: validateEmpty,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: emailController,
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
            controller: passwordController,
            label: const Text('Password'),
          ),
          const SizedBox(height: 10),
          Visibility(
            visible: !isSignin,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PasswordTextFieldWidget(
                  validator: validateEmpty,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: confirmPasswordController,
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
                  onPressed: isSignin ? onSignIn : onSignUp, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  child: Text(isSignin ? 'Sign in' : 'Sign up', style: const TextStyle(fontSize: 20)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  } 
}