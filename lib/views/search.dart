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
  static const List<Color> noteBg = [
    Color.fromRGBO(253, 153, 255, 1),
    Color.fromRGBO(255, 158, 158, 1),
    Color.fromRGBO(145, 244, 143, 1),
    Color.fromRGBO(255, 245, 153, 1),
    Color.fromRGBO(158, 255, 255, 1),
  ];
  // TODO REVIEW:
  // Consider to separate view model for this widget, must not use setState here
  // Or consider to use one parent view model, combine with ref watch selector to control this change
  List<Note> filteredNotes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search by title...",
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 1,
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
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
              const SizedBox(height: 20),
              filteredNotes.isNotEmpty
              ? Column(
                children: filteredNotes.asMap().map((index, note) => MapEntry(index, NoteItem(note, backgroundColor: noteBg[index]))).values.toList())
              : const Center(child: Text("No matching notes")) ,
              
            ],
          ),
        ),
      )
    );
  }
}