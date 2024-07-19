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
  Future<void> add(Note note) async {
    final db = await _myDatabase!.db;
    await db.insert('Note', note.toMap());
  }

  Future<List<Note>> getAll(String? idUser) async {
    final db = await _myDatabase!.db;
    var res = await db.query('Note', where: ' id_user IS ? ', whereArgs: [idUser], orderBy: 'created_at', );
    return res.isNotEmpty ? res.map((r) => Note.fromMap(r)).toList() : List.empty();
  }

  // get note
  Future<Note?> get(String id) async {
    final db = await _myDatabase!.db;
    var res = await db.query('Note', where: ' id = ? ', whereArgs: [id]);
    return res.isNotEmpty ? Note.fromMap(res.first) : null;
  }

  // filter note 
  Future<List<Note>> filter(String title, String? idUser) async {
    final db = await _myDatabase!.db;
    var res = await db.query('Note', where: ' title LIKE ? AND id_user IS ? ', whereArgs: ['%$title%', idUser]);
    return res.isNotEmpty ? res.map((r) => Note.fromMap(r)).toList() : List.empty();
  }

  // edit note
  Future<void> update(Note note) async {
    final db = await _myDatabase!.db;
    await db.update('Note', note.toMap(), where: ' id = ? ', whereArgs: [note.id]);
  }

  // delete note
  Future<void> delete(String id) async {
    final db = await _myDatabase!.db;
    await db.delete('Note', where: ' id = ? ', whereArgs: [id]);
  }

  // upsert note
  Future<void> upsert(Note note) async {
    final db = await _myDatabase!.db;
    await db.rawInsert(
      'INSERT INTO Note (id, title, content, created_at, id_user) '
      'VALUES (?, ?, ?, ?, ?) '
      'ON CONFLICT(id) DO UPDATE SET '
      ' title=excluded.title, '
      ' content=excluded.content, '
      ' created_at=excluded.created_at',
      [note.id, note.title, note.content, note.createdAt, note.idUser]
    );
  }
}