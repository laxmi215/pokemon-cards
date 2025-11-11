import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'pokemon_cards.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cards (
        id TEXT PRIMARY KEY,
        name TEXT,
        imageSmall TEXT,
        imageLarge TEXT
      )
    ''');
  }

  Future<int> insertCard(Map<String, dynamic> card) async {
    Database db = await database;
    return await db.insert(
      'cards',
      card,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getCards() async {
    Database db = await database;
    return await db.query('cards');
  }

  Future<int> getCardCount() async {
    Database db = await database;
    var result = await db.rawQuery('SELECT COUNT(*) as count FROM cards');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> deleteAllCards() async {
    Database db = await database;
    await db.delete('cards');
  }
}
