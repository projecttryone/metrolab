import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper instance = DBHelper._();

  static Database? _db;
  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'medapp2.db');

    // If the database doesn't exist, copy from assets:
    if (!await File(path).exists()) {
      // Make sure the folder exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      // Copy the file
      final data = await rootBundle.load('assets/medapp2.db');
      final bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes, flush: true);
    }

    // Open the existing database
    return await openDatabase(path, readOnly: false);
  }

  // Example query method
  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    final dbClient = await db;
    return dbClient.query(table);
  }

// Inside class DBHelper { ... } in your db_helper.dart

Future<void> debugDbInfo() async {
  // Make sure you have these imports at the top of this file:
  // import 'dart:io';
  // import 'package:path/path.dart';
  // import 'package:sqflite/sqflite.dart';

  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'medapp2.db'); // same name you open in _initDB()
  final f = File(path);

  final exists = await f.exists();
  final size = exists ? await f.length() : 0;

  print('--- DB DEBUG ---');
  print('Runtime DB path : $path');
  print('Exists          : $exists');
  print('Size (bytes)    : $size');

  final dbc = await db; // opens it
  final tables = await dbc.rawQuery(
    "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;"
  );
  print('Tables          : $tables');

  try {
    final cnt = Sqflite.firstIntValue(
      await dbc.rawQuery('SELECT COUNT(*) FROM customer')
    );
    print('customer rows   : $cnt');
  } catch (e) {
    print('customer table? : error -> $e');
  }
  print('----------------');
}


}
