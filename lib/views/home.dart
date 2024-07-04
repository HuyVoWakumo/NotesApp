import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/view_models/note_viewmodel.dart';
import 'package:notes_app/views/note_editor.dart';
import 'package:notes_app/widgets/note_item.dart';

final notesProvider = ChangeNotifierProvider((ref) => NoteNotifier());

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}
class HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();
    ref.read(notesProvider).getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: ref.watch(notesProvider).notes.map((note) => NoteItem(note)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NoteEditor()));
        },
        shape: const CircleBorder(side: BorderSide(width: 1)),
        child: const Icon(Icons.add),
      ),
    );
  }

  appBar() {
    return AppBar(
      title: const Text('Notes', style: TextStyle(fontSize: 20)),
      actions: [
        IconButton(
          onPressed: () {

          },
          icon: const Icon(Icons.search),
        ),
        IconButton(
          onPressed: () {

          }, 
          icon: const Icon(Icons.info_outline),
        )
      ],
    );
  }
}



