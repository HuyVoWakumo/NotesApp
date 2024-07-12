import 'package:flutter/material.dart';
import 'package:notes_app/views/home/home.dart';
import 'package:notes_app/views/note_detail/note_detail.dart';
import 'package:notes_app/views/search/search.dart';

class Routes {
  static late Map<String, Widget Function(BuildContext)> _route;

  static Map<String, Widget Function(BuildContext)> init(BuildContext context) {
    _route = {
      '/home': (context) => const Home(),
      '/note-detail': (context) {
        final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return NoteDetail(args['id']);
      },
      '/search': (context) => const Search(),
    };
    return _route;
  }
}