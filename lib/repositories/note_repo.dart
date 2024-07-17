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

  // add note to sqflite 
  Future<void> addLocal(Note note) async {
    await _noteLocal!.add(note);
  }

  // add note to supabase
  Future<void> addRemote(Note note) async {
    await _noteRemote!.add(note);
  } 

  Future<List<Note>> getAll(String? idUser) async {
    return await _noteLocal!.getAll(idUser);
  }

  // get note by id from sqflite
  Future<Note?> get(String id) async {
    return await _noteLocal!.get(id);
  }

  // edit note in sqflite
  Future<void> updateLocal(Note note) async {
    await _noteLocal!.update(note);
  }

  // edit note in supabase
  Future<void> updateRemote(Note note) async {
    await _noteRemote!.update(note);
  }

  // delete note in sqflite
  Future<void> deleteLocal(String id) async {
    await _noteLocal!.delete(id);
  }

  // delete note in supabase
  Future<void> deleteRemote(String id) async {
    await _noteRemote!.delete(id);
  }

  // filter note 
  Future<List<Note>> filter(String title) async {
    return await _noteLocal!.filter(title);
  }

}