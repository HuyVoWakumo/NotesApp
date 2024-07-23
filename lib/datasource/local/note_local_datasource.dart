import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/database.dart';
import 'package:notes_app/models/note_model.dart';

final noteLocalProvider = Provider<NoteLocalDatasource>(
  (ref) => NoteLocalDatasource(ref.read(databaseProvider))
);

class NoteLocalDatasource {
  static MyDatabase? _myDatabase;

  NoteLocalDatasource(MyDatabase myDatabase) {
    _myDatabase = myDatabase;
  }

  // add note
  Future<void> add(Note note) async {
    final db = await _myDatabase!.db;
    await db.insert('Note', note.toMapLocal());
  }

  Future<List<Note>> getAll(String? idUser) async {
    final db = await _myDatabase!.db;
    var res = await db.query('Note', where: ' id_user IS ? and is_trash = ? ', whereArgs: [idUser, 0], orderBy: 'updated_at');
    return res.isNotEmpty ? res.map((r) => Note.fromMapLocal(r)).toList() : List.empty();
  }

  Future<List<Note>> getAllArchive(String? idUser) async {
    final db = await _myDatabase!.db;
    var res = await db.query('Note', where: ' id_user IS ? and is_trash = ? ', whereArgs: [idUser, 1], orderBy: 'updated_at');
    return res.isNotEmpty ? res.map((r) => Note.fromMapLocal(r)).toList() : List.empty();
  }

  // get note
  Future<Note?> get(String id) async {
    final db = await _myDatabase!.db;
    var res = await db.query('Note', where: ' id = ? ', whereArgs: [id]);
    return res.isNotEmpty ? Note.fromMapLocal(res.first) : null;
  }

  // filter note 
  Future<List<Note>> filter(String title, String? idUser) async {
    final db = await _myDatabase!.db;
    var res = await db.query('Note', where: ' title LIKE ? AND id_user IS ? AND is_trash = ? ', whereArgs: ['%$title%', idUser, 0]);
    return res.isNotEmpty ? res.map((r) => Note.fromMapLocal(r)).toList() : List.empty();
  }

  // edit note
  Future<void> update(Note note) async {
    final db = await _myDatabase!.db;
    await db.update('Note', note.toMapLocal(), where: ' id = ? ', whereArgs: [note.id]);
  }

  Future<void> archive(String id) async {
    final db = await _myDatabase!.db;
    await db.update('Note', {'is_trash': 1, 'updated_at': DateTime.now().toString() }, where: ' id = ? ', whereArgs: [id]);
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
      'INSERT INTO Note (id, title, content, updated_at, is_trash, id_user) '
      'VALUES (?, ?, ?, ?, ?, ?) '
      'ON CONFLICT(id) DO UPDATE SET '
      ' title=excluded.title, '
      ' content=excluded.content, '
      ' updated_at=excluded.updated_at, '
      ' is_trash=excluded.is_trash',
      [note.id, note.title, note.content, note.updatedAt, note.isTrash ? 1 : 0, note.idUser]
    );
  }
}