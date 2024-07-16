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
    _supabase.from('notes')
    .insert(note.toMap())
    .then((value) => log('Inserted supabase'));
  }

  // Future<List<Note>> getAll() async {

  // }

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