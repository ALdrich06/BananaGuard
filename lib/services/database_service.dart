import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/scan_result.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('banana_guard.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE scans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        diseaseName TEXT NOT NULL,
        confidence REAL NOT NULL,
        imagePath TEXT NOT NULL,
        dateScanned TEXT NOT NULL,
        severity TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT,
        language TEXT DEFAULT 'English',
        darkMode INTEGER DEFAULT 0,
        notificationsEnabled INTEGER DEFAULT 1
      )
    ''');
  }

  Future<int> insertScan(ScanResult result) async {
    final db = await database;
    return await db.insert('scans', result.toMap());
  }

  Future<List<ScanResult>> getAllScans() async {
    final db = await database;
    final result = await db.query('scans', orderBy: 'dateScanned DESC');
    return result.map((json) => ScanResult.fromMap(json)).toList();
  }

  Future<ScanResult?> getLatestScan() async {
    final db = await database;
    final result = await db.query('scans', orderBy: 'dateScanned DESC', limit: 1);
    if (result.isEmpty) return null;
    return ScanResult.fromMap(result.first);
  }

  Future<int> getScanCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM scans');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getHealthyCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM scans WHERE diseaseName = ?',
      ['Healthy'],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<double> getAverageConfidence() async {
    final db = await database;
    final result = await db.rawQuery('SELECT AVG(confidence) as avg FROM scans');
    final avg = result.first['avg'];
    if (avg == null) return 0.0;
    return (avg as num).toDouble();
  }

  Future<int> deleteScan(int id) async {
    final db = await database;
    return await db.delete('scans', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllScans() async {
    final db = await database;
    return await db.delete('scans');
  }

  Future<void> saveUser({
    required String name,
    required String email,
    String language = 'English',
    bool darkMode = false,
    bool notificationsEnabled = true,
  }) async {
    final db = await database;
    await db.insert(
      'users',
      {
        'id': 1,
        'name': name,
        'email': email,
        'language': language,
        'darkMode': darkMode ? 1 : 0,
        'notificationsEnabled': notificationsEnabled ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUser() async {
    final db = await database;
    final result = await db.query('users', where: 'id = ?', whereArgs: [1]);
    if (result.isEmpty) return null;
    return result.first;
  }

  Future close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}
