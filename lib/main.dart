import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/database.dart';
import 'package:notes_app/routes.dart';
import 'package:notes_app/views/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MyDatabase.instance.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        routes: Routes.init(context),
        initialRoute: '/home',
      ),
    );
  }
}
