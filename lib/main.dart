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
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.dark,
        routes: Routes.init(context),
        initialRoute: '/home',
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

// TODO REVIEW:
// Re-check all places, do format code and remove unused imports
// Re-check all places, which one can use const then let's use it, don't forget to follow lint analysis
// Re-check all places, MUST NOT use setState, only notifyListeners from change notifier
// Your structure is still good, but let's consider to wrap view and view model to features layer, like inside folder home, it has home_view and home_view_model