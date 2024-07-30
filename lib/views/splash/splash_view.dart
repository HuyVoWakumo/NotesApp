import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/views/splash/splash_view_model.dart';

class SplashView extends ConsumerWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedSplashScreen.withScreenRouteFunction(
      splash: 'assets/images/notes-icon.webp',
      backgroundColor: Colors.black54, 
      animationDuration: Durations.extralong4,
      splashTransition: SplashTransition.fadeTransition,
      screenRouteFunction: () async => ref.read(splashViewModel).checkCurrentUser() == null ? '/auth' : '/home',
    );
  }
}