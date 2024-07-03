import 'package:flutter/material.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/repositories/note_repo.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class NoteNotifier extends ChangeNotifier {
  final repo = NoteRepo();
  List<Note> notes = List.empty(growable: true);

  add(String title, String content) {
    Note note = Note(
      id: _uuid.v4(),
      title: title,
      content: content,
    );
    notes.add(note);
    repo.add(note);
    notifyListeners();
  }

}