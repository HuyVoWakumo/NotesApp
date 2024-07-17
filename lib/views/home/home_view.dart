import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/views/home/home_view_model.dart';
import 'package:notes_app/views/note_detail/note_detail_view_model.dart';
import 'package:notes_app/widgets/note_item_widget.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeState createState() => HomeState();
}
class HomeState extends ConsumerState<HomeView> {

  @override
  void initState() {
    super.initState();
    ref.read(homeProvider).getAll();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(noteDetailProvider.select((p) => p.note), (previous, next) {
      ref.read(homeProvider).getAll();
    });

    return Scaffold(
      appBar: appBar(context),
      body: ref.watch(homeProvider).notes.isEmpty
      ? const Center(child: Text('Create some notes !'))
      : ListView(
        padding: const EdgeInsets.all(10),
        children: ref.watch(homeProvider).notes.asMap().map((index, note) => MapEntry(index, NoteItemWidget(note, backgroundColor: ref.read(homeProvider).noteBg[index % 5]))).values.toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(noteDetailProvider).isReadOnly = false;
          Navigator.pushNamed(context, '/note-detail', arguments: { 'id': null });
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
            Navigator.pushNamed(context, '/search');
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



