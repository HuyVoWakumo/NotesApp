import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/datasource/local/note_local_datasource.dart';
import 'package:notes_app/datasource/remote/note_remote_datasource.dart';
import 'package:notes_app/models/note_model.dart';

final noteRepoProvider = Provider<NoteRepo>(
  (ref) => NoteRepo(
    ref.read(noteLocalProvider), 
    ref.read(noteRemoteProvider)
  )
);

class NoteRepo {
  NoteRepo._();
  static final NoteRepo _instance = NoteRepo._();
  // static MyDatabase? _myDatabase;
  static NoteLocalDatasource? _noteLocal;
  static NoteRemoteDatasource? _noteRemote;

  factory NoteRepo(NoteLocalDatasource noteLocal, NoteRemoteDatasource noteRemote) {
    // _myDatabase = myDatabase;
    _noteLocal = noteLocal;
    _noteRemote = noteRemote;
    return _instance;
  }

  // add note
  Future<void> add(Note note) async {
    await _noteLocal!.add(note);
    await _noteRemote!.add(note);
  }

  Future<List<Note>> getAll() async {
    return _noteLocal!.getAll();
  }

  // // get note
  // Future<Note?> get(String id) async {

  // }

  // // filter note 
  // Future<List<Note>> filter(String title) async {

  // }

  // // edit note
  // Future<int> update(Note note) async {

  // }

  // // delete note
  // Future<int> delete(String id) async {

  // }
}