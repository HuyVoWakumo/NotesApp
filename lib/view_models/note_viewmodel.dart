import 'package:flutter/material.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class NoteNotifier extends ChangeNotifier {
  List<Note> notes = List.empty(growable: true);

  add(String title, String content) {
    notes.add(Note(
      id: _uuid.v4(),
      title: title,
      content: content,
    ));
    notifyListeners();
  }

}