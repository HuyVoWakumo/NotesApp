import 'package:flutter/material.dart';
import 'package:notes_app/views/home.dart';
import 'package:notes_app/views/note_detail.dart';
import 'package:notes_app/views/note_editor.dart';

class Routes {
  static late Map<String, Widget Function(BuildContext)> _route;

  static Map<String, Widget Function(BuildContext)> init(BuildContext context) {
    _route = {
      '/home': (context) => Home(),
      '/note-detail': (context) => NoteDetail(),
      '/note-editor': (context) => NoteEditor(),
    };
    return _route;
  }
}