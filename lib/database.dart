import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final databaseProvider = Provider<MyDatabase>((ref) => MyDatabase());

class MyDatabase extends ChangeNotifier{
  MyDatabase._();
  static final MyDatabase _instance = MyDatabase._();
  static MyDatabase get instance => _instance;

  static Database? _db;
  Future<Database> get db async {
    _db ??= await _init();
    return _db!;
  }

  factory MyDatabase() {
    return _instance;
  }

  Future<Database> _init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "todo_app.db");
    return await openDatabase(path, version: 2, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Note ("
          "id VARCHAR(36) PRIMARY KEY, "
          "title TEXT, "
          "content TEXT, "
          "created_at DATETIME DEFAULT CURRENT_TIMESTAMP, "
          "id_user VARCHAR(36) NULL"
          ")");
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      await db.execute('''
          CREATE TABLE IF NOT EXISTS Note_new (
            id VARCHAR(36) PRIMARY KEY,
            title TEXT,
            content TEXT
          );

          INSERT INTO Note_new (id, title, content)
          SELECT id, title, content
          FROM Note;

          DROP TABLE Note;
          ALTER TABLE Note_new RENAME TO Note;

          ALTER TABLE Note ADD COLUMN created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
          ALTER TABLE Note ADD id_user VARCHAR(36) NULL;
          '''
          );
    });
  }
}