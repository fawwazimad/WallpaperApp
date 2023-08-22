import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('favorite_wallpapers.db');
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id TEXT PRIMARY KEY,
        imageUrl TEXT
      )
    ''');
  }

  Future<int> insertFavorite(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('favorites', row);
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await instance.database;
    return await db.query('favorites');
  }

  Future<int> deleteFavorite(String id) async {
    final db = await instance.database;
    return await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> resetDatabase() async {
    final db = await instance.database;
    await db.execute('DROP TABLE IF EXISTS favorites');
    await _createDB(db, 1); // Recreate the table
  }
}
