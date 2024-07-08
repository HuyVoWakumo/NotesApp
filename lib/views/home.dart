import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/view_models/note_viewmodel.dart';
import 'package:notes_app/views/note_editor.dart';
import 'package:notes_app/views/search.dart';
import 'package:notes_app/widgets/note_item.dart';

final notesProvider = ChangeNotifierProvider((ref) => NoteNotifier());

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}
class HomeState extends ConsumerState<Home> {

  static const List<Color> noteBg = [
    Color.fromRGBO(253, 153, 255, 1),
    Color.fromRGBO(255, 158, 158, 1),
    Color.fromRGBO(145, 244, 143, 1),
    Color.fromRGBO(255, 245, 153, 1),
    Color.fromRGBO(158, 255, 255, 1),
  ];

  @override
  void initState() {
    super.initState();
    ref.read(notesProvider).getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: ref.watch(notesProvider).notes.isEmpty
      ? const Center(child: Text('Create some notes !'))
      : ListView(
        padding: const EdgeInsets.all(10),
        children: ref.watch(notesProvider).notes.asMap().map((index, note) => MapEntry(index, NoteItem(note, backgroundColor: noteBg[index % 5]))).values.toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NoteEditor(null)));
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.black54,
        child: const Icon(Icons.add),
      ),
    );
  }

  appBar(BuildContext context) {
    return AppBar(
      title: const Text('Notes', style: TextStyle(fontSize: 20)),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Search()));
          },
          icon: const Icon(Icons.search),
        ),
        IconButton(
          onPressed: () {
            showDialog(
              context: context, 
              builder: (context) {
                return const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Designed by - '),
                      Text('Redesigned by - '),
                      Text('Illustrations - '),
                      Text('Icons - '),
                      Text('Font - '),
                      Text('Made by - ', textAlign: TextAlign.center)
                    ],
                  )
                );
              }
            );
          }, 
          icon: const Icon(Icons.info_outline),
        )
      ],
    );
  }
}



