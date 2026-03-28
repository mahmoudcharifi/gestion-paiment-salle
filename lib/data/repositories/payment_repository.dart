import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';
import '../database/db_tables.dart';
import '../models/payment_model.dart';

class PaymentRepository {
  final AppDatabase _appDatabase = AppDatabase.instance;

  Future<PaymentModel?> getPaymentById(int paymentId) async {
    final Database db = await _appDatabase.database;

    final maps = await db.query(
      DbTables.payments,
      where: 'id = ?',
      whereArgs: [paymentId],
      limit: 1,
    );

    if (maps.isEmpty) return null;

    return PaymentModel.fromMap(maps.first);
  }
  Future<int> addPayment(PaymentModel payment) async {
    final Database db = await _appDatabase.database;

    return await db.insert(
      DbTables.payments,
      payment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<PaymentModel?> getLatestPaymentByMemberId(int memberId) async {
    final Database db = await _appDatabase.database;

    final maps = await db.query(
      DbTables.payments,
      where: 'member_id = ?',
      whereArgs: [memberId],
      orderBy: 'end_date DESC',
      limit: 1,
    );

    if (maps.isEmpty) return null;

    return PaymentModel.fromMap(maps.first);
  }
  Future<List<PaymentModel>> getPaymentsByMemberId(int memberId) async {
    final Database db = await _appDatabase.database;

    final maps = await db.query(
      DbTables.payments,
      where: 'member_id = ?',
      whereArgs: [memberId],
      orderBy: 'payment_date DESC',
    );

    return maps.map((e) => PaymentModel.fromMap(e)).toList();
  }

  Future<int> deletePayment(int id) async {
    final Database db = await _appDatabase.database;

    return await db.delete(
      DbTables.payments,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<double> getTotalPaymentsThisMonth() async {
    final Database db = await _appDatabase.database;

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1).toIso8601String();
    final endOfMonth = DateTime(now.year, now.month + 1, 1).toIso8601String();

    final result = await db.rawQuery('''
      SELECT SUM(amount_paid) as total
      FROM ${DbTables.payments}
      WHERE payment_date >= ? AND payment_date < ?
    ''', [startOfMonth, endOfMonth]);

    final total = result.first['total'];
    if (total == null) return 0;

    return (total as num).toDouble();
  }
}