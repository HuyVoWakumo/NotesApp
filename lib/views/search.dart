import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/views/home.dart';
import 'package:notes_app/widgets/note_item.dart';

class Search extends ConsumerStatefulWidget {
  const Search({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchState();
}

class _SearchState extends ConsumerState<Search> {
  List<Note> filteredNotes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: "Search by title...",
                ),
                onChanged: (value) {
                  ref.read(notesProvider).filter(value)
                  .then((value) {
                    setState(() {
                      filteredNotes = value;
                    });
                  });
                },
              ),
              filteredNotes.isNotEmpty
              ? Column(
                children: filteredNotes.map((note) => NoteItem(note)).toList())
              : const Center(child: Text("No matching notes")) ,
              
            ],
          ),
        ),
      )
    );
  }
}