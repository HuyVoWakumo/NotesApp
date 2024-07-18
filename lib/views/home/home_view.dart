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
    ref.read(homeViewModel).getAll();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(noteDetailViewModel.select((p) => p.note), (previous, next) {
      ref.read(homeViewModel).getAll();
    });

    return Scaffold(
      appBar: _appBar(context),
      body: Column(
        children: [
          _connectionNoti(),
          _notesZone(),
        ],
      ),
      floatingActionButton: _floatingActionButton(),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text('Notes', style: TextStyle(fontSize: 20)),
      actions: [
        _searchNavBtn(context),
        _accountBtn(context),
        _appInfoBtn(context),
      ],
    );
  }

  Widget _searchNavBtn(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pushNamed(context, '/search');
      },
      icon: const Icon(Icons.search),
    );
  }

  Widget _accountBtn(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                ref.read(homeViewModel).checkCurrentUser() == null 
                ? 'Not sign in'
                : ref.read(homeViewModel).checkCurrentUser()!.email!
              ),
              actions: [
                ElevatedButton(
                  onPressed: ref.read(homeViewModel).checkCurrentUser() == null
                  ? () {
                    Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
                  }
                  : () {
                    ref.read(homeViewModel).signOut();
                    Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
                  }, 
                  child: Text(
                    ref.read(homeViewModel).checkCurrentUser() == null
                    ? 'Sign in'
                    : 'Sign out'
                  )
                )
              ]);
          });
      },
      icon: const Icon(Icons.person)
    );
  }
  
  Widget _appInfoBtn(BuildContext context) {
    return IconButton(
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
              ));
          });
      }, 
      icon: const Icon(Icons.info_outline),
    );
  }

  Widget _connectionNoti() {
    return ref.watch(homeViewModel).hasInternetConnection
    ? const SizedBox()
    : const Text('No internet connection....', textAlign: TextAlign.center);
  }

  Widget _notesZone() {
    return ref.watch(homeViewModel).notes.isEmpty
      ? const Center(child: Text('Create some notes !'))
      : ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(10),
        children: ref.watch(homeViewModel).notes.asMap().map((index, note) => MapEntry(index, NoteItemWidget(note, backgroundColor: ref.read(homeViewModel).noteBg[index % 5]))).values.toList(),
    );
  }

  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        ref.read(noteDetailViewModel).isReadOnly = false;
        Navigator.pushNamed(context, '/note-detail', arguments: { 'id': null });
      },
      shape: const CircleBorder(),
      backgroundColor: Colors.black54,
      child: const Icon(Icons.add),
    );
  }
}



