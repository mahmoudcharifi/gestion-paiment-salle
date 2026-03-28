import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/theme/app_text_styles.dart';
import 'package:provider/provider.dart';

import '../../../shared/widgets/delete_confirmation_dialog.dart';
import '../controllers/system_controller.dart';
import '../../dashboard/pages/dashboard_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  String _themeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Clair';
      case ThemeMode.dark:
        return 'Sombre';
      case ThemeMode.system:
        return 'Système';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const Text(
            'Préférences',
            style: AppTextStyles.pageTitle,
          ),
          const SizedBox(height: AppSpacing.lg),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Apparence',
                    style: AppTextStyles.sectionTitle,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  RadioListTile<ThemeMode>(
                    value: ThemeMode.light,
                    groupValue: controller.themeMode,
                    title: const Text('Mode clair'),
                    subtitle: const Text('Toujours utiliser le thème clair'),
                    onChanged: (value) {
                      if (value != null) {
                        controller.setThemeMode(value);
                      }
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.dark,
                    groupValue: controller.themeMode,
                    title: const Text('Mode sombre'),
                    subtitle: const Text('Toujours utiliser le thème sombre'),
                    onChanged: (value) {
                      if (value != null) {
                        controller.setThemeMode(value);
                      }
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.system,
                    groupValue: controller.themeMode,
                    title: const Text('Mode système'),
                    subtitle: const Text(
                      'Suivre le thème du téléphone',
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        controller.setThemeMode(value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          Card(
            child: ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: const Text('Thème actuel'),
              subtitle: Text(_themeLabel(controller.themeMode)),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Zone dangereuse',
                    style: AppTextStyles.sectionTitle,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Cette action supprime toutes les données de l’application : adhérents, sports, paiements et historique.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        final confirmed = await showDeleteConfirmationDialog(
                          context: context,
                          title: 'Réinitialiser le système',
                          message:
                              'Voulez-vous vraiment supprimer toutes les données de l’application ? Cette action est irréversible.',
                          confirmText: 'Réinitialiser',
                          cancelText: 'Annuler',
                        );

                        if (!confirmed) return;

                        await context.read<SystemController>().resetSystem();

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Système réinitialisé avec succès'),
                          ),
                        );

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const DashboardPage()),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.delete_forever_rounded),
                      label: const Text('Réinitialiser le système'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}