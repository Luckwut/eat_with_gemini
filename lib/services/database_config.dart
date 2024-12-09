import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConfig {
  static final _databaseName = 'eat_with_gemini.db';
  static final _databaseVersion = 1;

  // Singleton Initializer
  DatabaseConfig._internal();
  static final DatabaseConfig _instance = DatabaseConfig._internal();
  factory DatabaseConfig() => _instance;

  // Access to the Database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE responses (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          response_data TEXT,
          feature_type TEXT,
          model_type TEXT,
          image_path TEXT,
          created_at TEXT
        );
        ''');
      },
    );
  }
}
