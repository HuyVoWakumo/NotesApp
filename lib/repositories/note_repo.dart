import 'dart:developer';

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
  static NoteLocalDatasource? _noteLocal;
  static NoteRemoteDatasource? _noteRemote;

  factory NoteRepo(NoteLocalDatasource noteLocal, NoteRemoteDatasource noteRemote) {
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

  Future<List<Note>> getAllLocal(String? idUser) async {
    return await _noteLocal!.getAll(idUser);
  }

  Future<List<Note>> getAllRemote(String idUser) async {
    return await _noteRemote!.getAll(idUser);
  }

  /// Get note by id from sqflite
  Future<Note?> get(String id) async {
    return await _noteLocal!.get(id);
  }

  /// Edit note in sqflite
  Future<void> updateLocal(Note note) async {
    await _noteLocal!.update(note);
  }

  /// Edit note in supabase
  Future<void> updateRemote(Note note) async {
    await _noteRemote!.update(note);
  }

  /// Delete note in sqflite
  Future<void> deleteLocal(String id) async {
    await _noteLocal!.delete(id);
  }

  /// Delete note in supabase
  Future<void> deleteRemote(String id) async {
    await _noteRemote!.delete(id);
  }

  /// Filter note 
  Future<List<Note>> filter(String title, String? idUser) async {
    return await _noteLocal!.filter(title, idUser);
  }

  /// Fetch all notes by each user from local and remote
  /// and merge them into one, by time priority
  Future<List<Note>> sync(String idUser) async {
    List<Note> notesByUser = await getAllRemote(idUser) + await getAllLocal(idUser);
    log(notesByUser.map((note) => note.title).toString());
    List<Note> mergedNotes = [];

    while(notesByUser.isNotEmpty) {
      Note newNote = notesByUser.removeLast();
      try {
        Note currentNote = mergedNotes.firstWhere((note) => note.id == newNote.id);
        DateTime currentNoteTime = DateTime.parse(currentNote.createdAt);
        DateTime newNoteTime = DateTime.parse(newNote.createdAt);
        if(newNoteTime.isAfter(currentNoteTime)) {
          currentNote.assign(newNote);
        }
      } on StateError catch (_) {
        mergedNotes.add(newNote);
      }
    }
    mergedNotes.sort((prevNote, nextNote) {
      DateTime prevNoteTime = DateTime.parse(prevNote.createdAt);
      DateTime nextNoteTime = DateTime.parse(nextNote.createdAt);
      return prevNoteTime.compareTo(nextNoteTime);
    });

    for(Note note in mergedNotes) {
      _noteLocal!.upsert(note);
      _noteRemote!.upsert(note);
    }
    log('Sync completed');
    return mergedNotes;
  }
}