import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class MyDatabase {
  MyDatabase._();
  static final MyDatabase instance = MyDatabase._();
  static late final Database db;

  init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + "todo_app.db";
    db = await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Note ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "content TEXT,"
          ")");
    });
  }
}