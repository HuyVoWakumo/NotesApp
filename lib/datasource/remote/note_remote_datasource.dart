import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final noteRemoteProvider = Provider<NoteRemoteDatasource>(
  (ref) => NoteRemoteDatasource()
);

class NoteRemoteDatasource {
  NoteRemoteDatasource._();
  static final NoteRemoteDatasource _instance = NoteRemoteDatasource._();
  final _supabase = Supabase.instance.client;

  factory NoteRemoteDatasource() {
    return _instance;
  }

  // add note
  Future<void> add(Note note) async {
    await _supabase.from('notes')
    .insert(note.toMap())
    .then((value) => log('Inserted supabase'));
  }

  // edit note
  Future<void> update(Note note) async {
    await _supabase.from('notes')
    .update({
      'title': note.title,
      'content': note.content
    }).eq('id', note.id);
  }

  // delete note
  Future<void> delete(String id) async {
    await _supabase.from('notes')
    .delete()
    .eq('id', id);
  }
}