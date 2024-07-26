import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final noteRemoteProvider = Provider<NoteRemoteDatasource>(
  (ref) => NoteRemoteDatasource()
);

class NoteRemoteDatasource {
  final _supabase = Supabase.instance.client;

  /// get all note
  Future<List<Note>> getAll(String idUser) async {
    return await _supabase.from('notes')
    .select()
    .eq('id_user', idUser)
    .order('updated_at', ascending: true)
    .then((value) => value.map((noteJson) => Note.fromRemoteJson(noteJson)).toList());
  }

  Future<List<Note>> getAllArchive(String idUser) async {
    return await _supabase.from('notes')
    .select()
    .eq('id_user', idUser)
    .eq('is_trash', true)
    .order('updated_at', ascending: true)
    .then((value) => value.map((noteJson) => Note.fromRemoteJson(noteJson)).toList());
  }

  // add note
  Future<void> add(Note note) async {
    await _supabase.from('notes')
    .insert(note.toRemoteJson())
    .then((value) => log('Inserted supabase'));
  }

  // edit note
  Future<void> update(Note note) async {
    await _supabase.from('notes')
    .update(note.toRemoteJson())
    .eq('id', note.id);
  }

  Future<void> archive(String id) async {
    await _supabase.from('notes')
    .update({
      'is_trash': true,
      'updated_at': DateTime.now().toString()
    }).eq('id', id);
  }

  // delete note
  Future<void> delete(String id) async {
    await _supabase.from('notes')
    .delete()
    .eq('id', id);
  }

  // upsert note
  Future<void> upsert(Note note) async {
    await _supabase.from('notes')
    .upsert(note.toRemoteJson());
  }
}