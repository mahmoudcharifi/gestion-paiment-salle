import 'package:flutter/material.dart';

import '../../../data/models/dashboard_stats_model.dart';
import '../../../data/repositories/dashboard_repository.dart';

class DashboardController extends ChangeNotifier {
  final DashboardRepository _dashboardRepository = DashboardRepository();

  DashboardStatsModel? stats;
  bool isLoading = false;

  Future<void> loadStats() async {
    isLoading = true;
    notifyListeners();

    stats = await _dashboardRepository.getDashboardStats();

    isLoading = false;
    notifyListeners();
  }
}