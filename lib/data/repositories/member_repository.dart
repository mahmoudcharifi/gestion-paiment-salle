import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';
import '../database/db_tables.dart';
import '../models/member_model.dart';

class MemberWithSports {
  final MemberModel member;
  final List<String> sports;

  MemberWithSports({
    required this.member,
    required this.sports,
  });
}

class MemberRepository {
  final AppDatabase _appDatabase = AppDatabase.instance;

  Future<int> addMemberWithSports(
    MemberModel member,
    List<int> sportIds,
  ) async {
    final Database db = await _appDatabase.database;

    return await db.transaction((txn) async {
      final memberId = await txn.insert(
        DbTables.members,
        member.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      final batch = txn.batch();

      for (final sportId in sportIds) {
        batch.insert(
          DbTables.memberSports,
          {
            'member_id': memberId,
            'sport_id': sportId,
          },
        );
      }

      await batch.commit(noResult: true);
      return memberId;
    });
  }

  Future<List<MemberWithSports>> getAllMembersWithSports() async {
    final Database db = await _appDatabase.database;

    final maps = await db.rawQuery('''
      SELECT
        m.*,
        GROUP_CONCAT(s.name, ', ') as sports_names
      FROM ${DbTables.members} m
      LEFT JOIN ${DbTables.memberSports} ms ON ms.member_id = m.id
      LEFT JOIN ${DbTables.sports} s ON s.id = ms.sport_id
      GROUP BY m.id
      ORDER BY m.id DESC
    ''');

    return maps.map((map) {
      final sportsRaw = map['sports_names'] as String?;
      final sports = sportsRaw == null || sportsRaw.isEmpty
          ? <String>[]
          : sportsRaw.split(', ');

      return MemberWithSports(
        member: MemberModel.fromMap(map),
        sports: sports,
      );
    }).toList();
  }

  Future<List<MemberWithSports>> searchMembersWithSports(String query) async {
    final Database db = await _appDatabase.database;

    final maps = await db.rawQuery('''
      SELECT
        m.*,
        GROUP_CONCAT(s.name, ', ') as sports_names
      FROM ${DbTables.members} m
      LEFT JOIN ${DbTables.memberSports} ms ON ms.member_id = m.id
      LEFT JOIN ${DbTables.sports} s ON s.id = ms.sport_id
      WHERE
        m.first_name LIKE ? OR
        m.last_name LIKE ? OR
        m.phone LIKE ? OR
        m.cin LIKE ? OR
        m.qr_code LIKE ? OR
        s.name LIKE ?
      GROUP BY m.id
      ORDER BY m.id DESC
    ''', [
      '%$query%',
      '%$query%',
      '%$query%',
      '%$query%',
      '%$query%',
      '%$query%',
    ]);

    return maps.map((map) {
      final sportsRaw = map['sports_names'] as String?;
      final sports = sportsRaw == null || sportsRaw.isEmpty
          ? <String>[]
          : sportsRaw.split(', ');

      return MemberWithSports(
        member: MemberModel.fromMap(map),
        sports: sports,
      );
    }).toList();
  }

  Future<int> deleteMember(int id) async {
    final Database db = await _appDatabase.database;

    return await db.delete(
      DbTables.members,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<MemberWithSports?> getMemberByQrCode(String qrCode) async {
      final Database db = await _appDatabase.database;

      final maps = await db.rawQuery('''
        SELECT
          m.*,
          GROUP_CONCAT(s.name, ', ') as sports_names
        FROM ${DbTables.members} m
        LEFT JOIN ${DbTables.memberSports} ms ON ms.member_id = m.id
        LEFT JOIN ${DbTables.sports} s ON s.id = ms.sport_id
        WHERE m.qr_code = ?
        GROUP BY m.id
        LIMIT 1
      ''', [qrCode]);

      if (maps.isEmpty) return null;

      final map = maps.first;
      final sportsRaw = map['sports_names'] as String?;
      final sports = sportsRaw == null || sportsRaw.isEmpty
          ? <String>[]
          : sportsRaw.split(', ');

      return MemberWithSports(
        member: MemberModel.fromMap(map),
        sports: sports,
      );
    }

    Future<int> updateMemberPhoto(int memberId, String photoPath) async {
      final Database db = await _appDatabase.database;

      return await db.update(
        DbTables.members,
        {
          'photo_path': photoPath,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [memberId],
      );
    }
    Future<MemberWithSports?> getMemberWithSportsById(int memberId) async {
        final Database db = await _appDatabase.database;

        final maps = await db.rawQuery('''
          SELECT
            m.*,
            GROUP_CONCAT(s.name, ', ') as sports_names
          FROM ${DbTables.members} m
          LEFT JOIN ${DbTables.memberSports} ms ON ms.member_id = m.id
          LEFT JOIN ${DbTables.sports} s ON s.id = ms.sport_id
          WHERE m.id = ?
          GROUP BY m.id
          LIMIT 1
        ''', [memberId]);

        if (maps.isEmpty) return null;

        final map = maps.first;
        final sportsRaw = map['sports_names'] as String?;
        final sports = sportsRaw == null || sportsRaw.isEmpty
            ? <String>[]
            : sportsRaw.split(', ');

        return MemberWithSports(
          member: MemberModel.fromMap(map),
          sports: sports,
        );
      }

      Future<void> updateMemberWithSports(
        MemberModel member,
        List<int> sportIds,
      ) async {
        final Database db = await _appDatabase.database;

        await db.transaction((txn) async {
          await txn.update(
            DbTables.members,
            member.toMap(),
            where: 'id = ?',
            whereArgs: [member.id],
          );

          await txn.delete(
            DbTables.memberSports,
            where: 'member_id = ?',
            whereArgs: [member.id],
          );

          final batch = txn.batch();

          for (final sportId in sportIds) {
            batch.insert(
              DbTables.memberSports,
              {
                'member_id': member.id,
                'sport_id': sportId,
              },
            );
          }

          await batch.commit(noResult: true);
        });
      }

      Future<List<int>> getSportIdsByMemberId(int memberId) async {
        final Database db = await _appDatabase.database;

        final maps = await db.query(
          DbTables.memberSports,
          columns: ['sport_id'],
          where: 'member_id = ?',
          whereArgs: [memberId],
        );

        return maps.map((e) => e['sport_id'] as int).toList();
      }
}