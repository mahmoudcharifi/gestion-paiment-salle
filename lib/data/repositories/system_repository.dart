import '../database/app_database.dart';

class SystemRepository {
  final AppDatabase _appDatabase = AppDatabase.instance;

  Future<void> resetSystem() async {
    await _appDatabase.resetDatabase();
  }
}