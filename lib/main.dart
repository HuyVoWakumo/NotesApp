import 'package:flutter/material.dart';
import 'package:notes_app/database.dart';
import 'package:notes_app/views/home.dart';

void main() async {
  MyDatabase.instance.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Home(),
        ),
      ),
    );
  }
}
