import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        is_logged_in INTEGER NOT NULL DEFAULT 0
      );
    ''');

    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        date TEXT NOT NULL
      );
    ''');
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return await db.insert(table, values);
  }

  Future<List<Map<String, dynamic>>> getAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<int> update(String table, Map<String, dynamic> values, String where, List<dynamic> whereArgs) async {
    final db = await database;
    return await db.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String table, String where, List<dynamic> whereArgs) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<int> deleteAll(String table) async {
    final db = await database;
    return await db.delete(table);
  }

  /// Tandai pengguna tertentu sebagai login dengan username.
  Future<void> markUserAsLoggedIn(String username) async {
    final db = await database;

    // Tandai semua pengguna sebagai logout
    await db.update('users', {'is_logged_in': 0});

    // Tandai pengguna tertentu sebagai login
    await db.update(
      'users',
      {'is_logged_in': 1},
      where: 'username = ?',
      whereArgs: [username],
    );
  }

  /// Ambil data pengguna yang sedang login.
  Future<Map<String, dynamic>?> getLoggedInUser() async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'is_logged_in = ?',
      whereArgs: [1],
      limit: 1,
    );

    return result.isNotEmpty ? result.first : null;
  }

  /// Logout semua pengguna (reset `is_logged_in` menjadi 0).
  Future<void> logoutAllUsers() async {
    final db = await database;
    await db.update('users', {'is_logged_in': 0});
  }
}
