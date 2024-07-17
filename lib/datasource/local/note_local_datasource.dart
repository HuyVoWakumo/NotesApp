import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/database.dart';
import 'package:notes_app/models/note_model.dart';

final noteLocalProvider = Provider<NoteLocalDatasource>(
  (ref) => NoteLocalDatasource(ref.read(databaseProvider))
);

class NoteLocalDatasource {
  NoteLocalDatasource._();
  static final NoteLocalDatasource _instance = NoteLocalDatasource._();
  static MyDatabase? _myDatabase;

  factory NoteLocalDatasource(MyDatabase myDatabase) {
    _myDatabase = myDatabase;
    return _instance;
  }

  // add note
  Future<int> add(Note note) async {
    final db = await _myDatabase!.db;
    return await db.insert('Note', note.toMap());
  }

  Future<List<Note>> getAll(String? idUser) async {
    final db = await _myDatabase!.db;
    var res = await db.query('Note', where: ' id_user IS ? ', whereArgs: [idUser]);
    return res.isNotEmpty ? res.map((r) => Note.fromMap(r)).toList() : List.empty();
  }

  // get note
  Future<Note?> get(String id) async {
    final db = await _myDatabase!.db;
    var res = await db.query('Note', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? Note.fromMap(res.first) : null;
  }

  // filter note 
  Future<List<Note>> filter(String title) async {
    final db = await _myDatabase!.db;
    var res = await db.query('Note', where: 'title like ?', whereArgs: ['%$title%']);
    return res.isNotEmpty ? res.map((r) => Note.fromMap(r)).toList() : List.empty();
  }

  // edit note
  Future<int> update(Note note) async {
    final db = await _myDatabase!.db;
    return await db.update('Note', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  // delete note
  Future<int> delete(String id) async {
    final db = await _myDatabase!.db;
    return await db.delete('Note', where: 'id = ?', whereArgs: [id]);
  }
}