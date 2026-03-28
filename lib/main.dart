import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'data/database/app_database.dart';
import 'features/dashboard/controllers/dashboard_controller.dart';
import 'features/dashboard/pages/dashboard_page.dart';
import 'features/members/controllers/members_controller.dart';
import 'features/payments/controllers/payments_controller.dart';
import 'features/sports/controllers/sports_controller.dart';
import 'features/settings/controllers/system_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.instance.database;

  final themeController = ThemeController();
  await themeController.loadTheme();

  runApp(
    FightGymManagerApp(themeController: themeController),
  );
}

class FightGymManagerApp extends StatelessWidget {
  final ThemeController themeController;

  const FightGymManagerApp({
    super.key,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeController>.value(value: themeController),
        ChangeNotifierProvider(create: (_) => MembersController()),
        ChangeNotifierProvider(create: (_) => SportsController()),
        ChangeNotifierProvider(create: (_) => PaymentsController()),
        ChangeNotifierProvider(create: (_) => DashboardController()),
        ChangeNotifierProvider(create: (_) => SystemController()),
      ],
      child: Consumer<ThemeController>(
        builder: (context, themeController, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Fight Gym Manager',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeController.themeMode,
            home: const DashboardPage(),
          );
        },
      ),
    );
  }
}