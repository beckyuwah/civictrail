import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static Database? _database;
  static const int _dbVersion = 1;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'civic.db');

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            email TEXT,
            password TEXT,
            location TEXT,
            is_admin INTEGER DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE projects (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            description TEXT,
            state TEXT,
            show_on_home INTEGER
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE users ADD COLUMN location TEXT',
          );
          await db.execute(
            'ALTER TABLE users ADD COLUMN is_admin INTEGER DEFAULT 0',
          );
        }
      },
    );
  }
/// ======================
  /// Testing Helpers
  /// ======================

  /// Create a fresh in-memory database for tests
  static Future<Database> testInstance() async {
    final db = await openDatabase(inMemoryDatabasePath, version: _dbVersion,
        onCreate: (db, version) async {
      // Create only the tables needed for testing
      await db.execute('''
        CREATE TABLE projects (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          description TEXT,
          state TEXT,
          show_on_home INTEGER
        )
      ''');
    });
    _database = db; // So ProjectDao uses this DB during tests
    return db;
  }

  /// Close the database (for cleanup in tests)
  static Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}