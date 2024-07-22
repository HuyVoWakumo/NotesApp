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

  final Map<int, Future<void> Function(Database)> _migrations = {
    1: _migrateFromV1toV2,
    2: _migrateFromV2toV3,
  };

  static Future<void> _migrateFromV1toV2(Database db) async {
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
    log('Migrate from V1 to V2');
  }
  
  static Future<void> _migrateFromV2toV3(Database db) async {
    await db.execute('ALTER TABLE Note ADD is_trash INTEGER DEFAULT 0');
    await db.execute('ALTER TABLE Note RENAME COLUMN created_at TO updated_at');
    log('Migrate from V2 to V3');
  }

  Future<Database> _init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "todo_app.db");
    return await openDatabase(path, version: 3, onOpen: (db) {
      log('Open database');
    }, onCreate: (db, version) async {
      log('Create database');
      await db.execute('''
        CREATE TABLE Note (
          id VARCHAR(36) PRIMARY KEY,
          title TEXT,
          content TEXT,
          updated_at DATETIME,
          id_user VARCHAR(36) NULL,
          is_trash INTEGER DEFAULT 0
        )
      ''');
    }, onUpgrade: (db, oldVersion, newVersion) async {
      log('Old version: $oldVersion');
      log('New version: $newVersion');

      for (int i = oldVersion; i < newVersion; i++) {
        await _migrations[i]!(db);
      }
    });
  }
}