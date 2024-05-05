import 'dart:io';

import 'package:notes/Models/note_mode.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteDB {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;
  // only have a single app-wide reference to the database

  static final SqfliteDB instance = SqfliteDB._init();

  static Database? _database;

  SqfliteDB._init();

  Future<Database> get database async => _database ??= await _initDatabase();

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }
  
  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT,
        date TEXT
      )
    ''');
  }

  Future<int> insert(NoteModel note) async {
    Database db = await database;
    return await db.insert('notes', note.toJson());
  }

  Future<List<NoteModel>> getNotes() async {
    Database db = await database;
    List<Map> maps = await db.query('notes');
    return List.generate(maps.length, (i) {
      return NoteModel(
          id: maps[i]['id'],
          description: maps[i]['description'],
          date: DateTime.now().toString());
    });
  }

  Future<int> update(NoteModel note) async {
    Database db = await database;
    return await db
        .update('notes', note.toJson(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> delete(int id) async {
    Database db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
