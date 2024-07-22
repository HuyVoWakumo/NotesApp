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

  Future<List<Note>> getAllArchiveLocal(String? idUser) async {
    return await _noteLocal!.getAllArchive(idUser);
  }

  Future<List<Note>> getAllArchiveRemote(String idUser) async {
    return await _noteRemote!.getAllArchive(idUser);
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

  /// Move note to archive in sqflite
  Future<void> archiveLocal(String id) async {
    await _noteLocal!.archive(id);
  }

  /// Move note to archive in supabase
  Future<void> archiveRemote(String id) async {
    await _noteRemote!.archive(id);
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
    List<Note> notesByUser = 
      await getAllArchiveRemote(idUser) +
      await getAllRemote(idUser) + 
      await getAllArchiveLocal(idUser) +
      await getAllLocal(idUser);
    for (Note note in notesByUser) {
      if (note.updatedAt.contains('+')) {
        note.updatedAt = note.updatedAt.substring(0, note.updatedAt.indexOf('+'));
      }
      log(note.updatedAt);
    }
  
    List<Note> mergedNotes = [];

    while(notesByUser.isNotEmpty) {
      Note newNote = notesByUser.removeLast();
      try {
        Note currentNote = mergedNotes.firstWhere((note) => note.id == newNote.id);
        DateTime currentNoteTime = DateTime.parse(currentNote.updatedAt);
        DateTime newNoteTime = DateTime.parse(newNote.updatedAt);
        if(newNoteTime.isAfter(currentNoteTime)) {
          currentNote.assign(newNote);
        } 
      } on StateError catch (_) {
        mergedNotes.add(newNote);
      }
    }

    log(mergedNotes.length.toString());
    for(Note note in mergedNotes) {
      _noteLocal!.upsert(note);
      _noteRemote!.upsert(note);
    }
    log('Sync completed');
    log(mergedNotes.map((note) => note.isTrash).toString());
    return mergedNotes.where((note) => note.isTrash == false).toList();
  }
}