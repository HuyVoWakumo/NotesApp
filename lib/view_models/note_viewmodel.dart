import 'package:flutter/material.dart';
import 'package:notes_app/models/note_model.dart';

class NoteViewModel extends ChangeNotifier {
  List<Note> notes = List.empty(growable: true);

  

}