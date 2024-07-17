import 'dart:developer';
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
      log('Open database');
    }, onCreate: (db, version) async {
      log('Create database');
      await db.execute('''
        CREATE TABLE Note (
          id VARCHAR(36) PRIMARY KEY,
          title TEXT,
          content TEXT,
          created_at DATETIME,
          id_user VARCHAR(36) NULL
        )
      ''');
    }, onUpgrade: (db, oldVersion, newVersion) async {
      log(oldVersion.toString());
      log(newVersion.toString());

      if (oldVersion == 1 && newVersion == 2) {
        await db.execute('''
          CREATE TABLE Note_new (
            id VARCHAR(36) PRIMARY KEY,
            title TEXT,
            content TEXT
          )
        ''');
        await db.execute('''
          INSERT INTO Note_new (id, title, content)
          SELECT id, title, content
          FROM Note
        ''');
        await db.execute("DROP TABLE Note");
        await db.execute("ALTER TABLE Note_new RENAME TO Note");
        await db.execute("ALTER TABLE Note ADD created_at DATETIME");
        await db.execute("ALTER TABLE Note ADD id_user VARCHAR(36) NULL");
        
      }
    });
  }
}