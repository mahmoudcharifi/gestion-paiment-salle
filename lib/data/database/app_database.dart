import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'db_tables.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();
  static Database? _database;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fight_gym_manager.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${DbTables.members} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        phone TEXT NOT NULL,
        cin TEXT,
        guardian_name TEXT,
        guardian_phone TEXT,
        birth_date TEXT,
        photo_path TEXT,
        qr_code TEXT NOT NULL UNIQUE,
        registration_date TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        notes TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DbTables.sports} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DbTables.memberSports} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        member_id INTEGER NOT NULL,
        sport_id INTEGER NOT NULL,
        FOREIGN KEY (member_id) REFERENCES ${DbTables.members}(id) ON DELETE CASCADE,
        FOREIGN KEY (sport_id) REFERENCES ${DbTables.sports}(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DbTables.payments} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        member_id INTEGER NOT NULL,
        payment_date TEXT NOT NULL,
        amount_paid REAL NOT NULL,
        start_date TEXT NOT NULL,
        end_date TEXT NOT NULL,
        payment_method TEXT NOT NULL,
        note TEXT,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (member_id) REFERENCES ${DbTables.members}(id) ON DELETE CASCADE
      )
    ''');

    await _insertDefaultSports(db);
  }

  Future<void> _insertDefaultSports(Database db) async {
    final sports = [
      'Kickboxing',
      'MMA',
      'Boxe',
      'Jiu-jitsu',
      'Muay Thai',
    ];

    for (final sport in sports) {
      await db.insert(
        DbTables.sports,
        {'name': sport},
      );
    }
  }

  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fight_gym_manager.db');

    if (_database != null) {
      await _database!.close();
      _database = null;
    }

    await deleteDatabase(path);
    _database = await _initDatabase();
  }
}