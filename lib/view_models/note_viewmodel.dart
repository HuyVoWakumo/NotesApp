import 'package:flutter/material.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/repositories/note_repo.dart';
import 'package:notes_app/widgets/note_item.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class NoteNotifier extends ChangeNotifier {
  final repo = NoteRepo();
  List<Note> notes = [];

  add(String title, String content) async {
    Note note = Note(
      id: null,
      title: title,
      content: content,
    );
    notes = [...notes, note];
    await repo.add(note);
    await getAll();
  }

  getAll() async {
    notes = await repo.getAll();
    notifyListeners();
  }

  get(int id) async {
    return await repo.get(id);
  }

  update(int id, String title, String content) async {
    Note note = Note(
      id: id,
      title: title,
      content: content,
    );
    await repo.update(note);
    await getAll();
  }

  delete(int id) async {
    await repo.delete(id);
    await getAll();
  }
  
}