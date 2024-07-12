import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/views/search/search_view_model.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
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
                  ref.read(searchViewModel).filter(value);
                },
              ),
              const SizedBox(height: 20),
              ref.watch(searchViewModel).notes.isNotEmpty
              ? Column(
                children: ref.watch(searchViewModel).notes.asMap()
                .map((index, note) => MapEntry(index, NoteItem(
                  note, backgroundColor: noteBg[index % 5]))).values.toList())
              : const Center(child: Text("No matching notes")),
            ],
          ),
        ),
      )
    );
  }
}