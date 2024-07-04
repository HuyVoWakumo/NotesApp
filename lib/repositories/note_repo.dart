import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/database.dart';
import 'package:notes_app/models/note_model.dart';

class NoteRepo {
  final db = MyDatabase.db;

  // add note
  add(Note note) async {
    return await db.insert('Note', note.toMap());
  }

  Future<List<Note>> getAll() async {
    var res = await db.query('Note');
    return res.isNotEmpty ? res.map((r) => Note.fromMap(r)).toList() : List.empty();
  }

  // get note
  Future<Note?> get(String id) async {
    var res = await db.query('Note', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? Note.fromMap(res.first) : null;
  }

  // filter note 
  filter(String title) async {
    var res = await db.query('Note', where: 'title = ?', whereArgs: [title]);
    return res.isNotEmpty ? res.map((r) => Note.fromMap(r)).toList() : List.empty();
  }

  // edit note
  update(Note note) async {
    return await db.update('Note', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  // delete note
  delete(String id) async {
    return await db.delete('Note', where: 'id = ?', whereArgs: [id]);
  }

}