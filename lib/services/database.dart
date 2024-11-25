import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  // Getter untuk mendapatkan database SQLite
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  // Inisialisasi database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Membuat tabel
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
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

  // **1. Tambahkan Data ke Tabel**
  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return await db.insert(table, values);
  }

  // **2. Ambil Semua Data dari Tabel**
  Future<List<Map<String, dynamic>>> getAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  // **3. Update Data di Tabel**
  Future<int> update(String table, Map<String, dynamic> values, String where, List<dynamic> whereArgs) async {
    final db = await database;
    return await db.update(table, values, where: where, whereArgs: whereArgs);
  }

  // **4. Hapus Data dari Tabel**
  Future<int> delete(String table, String where, List<dynamic> whereArgs) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  // **5. Hapus Semua Data dari Tabel (Opsional)**
  Future<int> deleteAll(String table) async {
    final db = await database;
    return await db.delete(table);
  }
}
