import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';
import '../database/db_tables.dart';
import '../models/sport_model.dart';

class SportRepository {
  final AppDatabase _appDatabase = AppDatabase.instance;

  Future<List<SportModel>> getAllSports() async {
    final Database db = await _appDatabase.database;

    final maps = await db.query(
      DbTables.sports,
      orderBy: 'name ASC',
    );

    return maps.map((e) => SportModel.fromMap(e)).toList();
  }

  Future<int> addSport(String name) async {
    final Database db = await _appDatabase.database;

    return await db.insert(
      DbTables.sports,
      {'name': name.trim()},
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<int> updateSport(int id, String name) async {
    final Database db = await _appDatabase.database;

    return await db.update(
      DbTables.sports,
      {'name': name.trim()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteSport(int id) async {
    final Database db = await _appDatabase.database;

    return await db.delete(
      DbTables.sports,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}