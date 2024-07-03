import 'package:notes_app/database.dart';
import 'package:notes_app/models/note_model.dart';

class NoteRepo {
  final db = MyDatabase.db;

  // add note
  add(Note note) async {
    return await db.insert('Note', note.toMap());
  }

  // get note
  get(String id) async {
    if(id == 'All') {
      return await db.query('Note');
    } else {
      return await db.query('Note', where: 'id = ?', whereArgs: [id]);
    }
  }

  // filter note 
  filter(String title) async {
    return await db.query('Note', where: 'title = ?', whereArgs: [title]);
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