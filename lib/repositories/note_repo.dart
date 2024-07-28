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
  static NoteLocalDatasource? _noteLocal;
  static NoteRemoteDatasource? _noteRemote;

  NoteRepo(NoteLocalDatasource noteLocal, NoteRemoteDatasource noteRemote) {
    _noteLocal = noteLocal;
    _noteRemote = noteRemote;
  }

  // add note to sqflite 
  Future<void> addLocal(Note note) async {
    await _noteLocal!.add(note);
  }

  // add note to supabase
  Future<void> addRemote(Note note) async {
    await _noteRemote!.add(note);
  } 

  Future<List<Note>> getAllLocal() async {
    return await _noteLocal!.getAll();
  }

  Future<List<Note>> getAllRemote(String idUser) async {
    return await _noteRemote!.getAll(idUser);
  }

  Future<List<Note>> getAllNotArchiveLocal() async {
    final notes = await _noteLocal!.getAllNotArchive();
    notes.sort((a,b) => DateTime.parse(b.updatedAt).compareTo(DateTime.parse(a.updatedAt)));
    log('Local notes: ${notes.map((note) => note.toLocalJson()).toString()}');
    return notes;
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
    // log('IdUser: $idUser');
    List<Note> notes = 
      await getAllRemote(idUser) + 
      await getAllLocal();
    for (Note note in notes) {
      if (note.updatedAt.contains('T')) {
        note.updatedAt.replaceAll('T', ' ');
      }
      if (note.updatedAt.contains('+')) {
        note.updatedAt = note.updatedAt.substring(0, note.updatedAt.indexOf('+'));
      }
      if (note.idUser == null || note.idUser == '') {
        note.idUser = idUser;
      }
    }
    // log("Notes");
    // for (var note in notes) {
    //   log(note.toLocalJson().toString());
    // }
    List<Note> mergedNotes = [];
    // await Future.sync(() {

      while(notes.isNotEmpty) {
        Note newNote = notes.removeLast();
        log('${newNote.toLocalJson()}');
        try {
          Note currentNote = mergedNotes.firstWhere((note) => note.id == newNote.id);
          if (currentNote.isTrash) continue;
          DateTime currentNoteTime = DateTime.parse(currentNote.updatedAt);
          DateTime newNoteTime = DateTime.parse(newNote.updatedAt);
          log('${currentNote.id} : $currentNoteTime - $newNoteTime');
          if(newNoteTime.isAfter(currentNoteTime)) {
            currentNote.assign(newNote);
          } 
        } on StateError catch (_) {
          mergedNotes.add(newNote);
        }
      }
    // });
    mergedNotes.sort((a,b) => DateTime.parse(b.updatedAt).compareTo(DateTime.parse(a.updatedAt)));
    // log(mergedNotes.map((note) => note.toLocalJson()).toString());
    for(Note note in mergedNotes) {
      _noteLocal!.upsert(note);
      _noteRemote!.upsert(note);
    }
    log('Sync completed');
    return mergedNotes.where((note) => note.isTrash == false).toList();
  }
}