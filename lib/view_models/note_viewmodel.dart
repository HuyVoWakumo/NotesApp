import 'package:flutter/material.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/repositories/note_repo.dart';
import 'package:notes_app/widgets/note_item.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class NoteNotifier extends ChangeNotifier {
  final repo = NoteRepo();
  List<Note> notes = [];

  add(String title, String content) {
    Note note = Note(
      id: null,
      title: title,
      content: content,
    );
    notes = [...notes, note];
    // notes.add(note);
    repo.add(note);
    notifyListeners();
  }

  getAll() async {
    notes = await repo.getAll();
    notifyListeners();
  }
}