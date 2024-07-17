import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/views/search/search_view_model.dart';
import 'package:notes_app/widgets/note_item_widget.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchState();
}

class _SearchState extends ConsumerState<SearchView> {
  
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
                .map((index, note) => MapEntry(index, NoteItemWidget(
                  note, backgroundColor: ref.read(searchViewModel).noteBg[index % 5]))).values.toList())
              : const Center(child: Text("No matching notes")),
            ],
          ),
        ),
      )
    );
  }
}