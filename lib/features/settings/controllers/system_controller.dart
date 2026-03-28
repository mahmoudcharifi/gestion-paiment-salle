import 'package:flutter/material.dart';

import '../../../data/repositories/system_repository.dart';

class SystemController extends ChangeNotifier {
  final SystemRepository _systemRepository = SystemRepository();

  bool isResetting = false;

  Future<void> resetSystem() async {
    isResetting = true;
    notifyListeners();

    await _systemRepository.resetSystem();

    isResetting = false;
    notifyListeners();
  }
}