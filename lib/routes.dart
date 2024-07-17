import 'package:flutter/material.dart';
import 'package:notes_app/views/home/home_view.dart';
import 'package:notes_app/views/auth/auth_view.dart';
import 'package:notes_app/views/note_detail/note_detail_view.dart';
import 'package:notes_app/views/search/search_view.dart';

class Routes {
  static late Map<String, Widget Function(BuildContext)> _route;

  static Map<String, Widget Function(BuildContext)> init(BuildContext context) {
    _route = {
      '/auth': (context) => const AuthView(),
      '/home': (context) => const HomeView(),
      '/note-detail': (context) {
        final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return NoteDetailView(args['id']);
      },
      '/search': (context) => const SearchView(),
    };
    return _route;
  }
}