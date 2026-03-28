import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/section_title.dart';
import '../../../shared/widgets/stat_card.dart';
import '../../members/pages/members_page.dart';
import '../../scanner/pages/qr_scanner_page.dart';
import '../../sports/pages/sports_page.dart';
import '../controllers/dashboard_controller.dart';
import '../../settings/pages/settings_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<DashboardController>().loadStats();
    });
  }

  Future<void> _refresh() async {
    await context.read<DashboardController>().loadStats();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DashboardController>();
    final stats = controller.stats;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.14),
                    theme.cardColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.22),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gestion de la salle',
                    style: AppTextStyles.pageTitle,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Vue globale sur les adhérents, paiements et accès rapides.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            if (controller.isLoading && stats == null)
              const Padding(
                padding: EdgeInsets.only(top: 80),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              const SectionTitle(title: 'Statistiques'),
              const SizedBox(height: AppSpacing.md),

              StatCard(
                title: 'Total adhérents',
                value: '${stats?.totalMembers ?? 0}',
                icon: Icons.people_alt_rounded,
                subtitle: 'Tous les profils enregistrés',
              ),
              const SizedBox(height: AppSpacing.md),

              StatCard(
                title: 'Actifs',
                value: '${stats?.activeMembers ?? 0}',
                icon: Icons.verified_user_rounded,
                subtitle: 'Abonnement valide',
              ),
              const SizedBox(height: AppSpacing.md),

              StatCard(
                title: 'Expirés',
                value: '${stats?.expiredMembers ?? 0}',
                icon: Icons.warning_amber_rounded,
                subtitle: 'Abonnements dépassés',
              ),
              const SizedBox(height: AppSpacing.md),

              StatCard(
                title: 'Expire bientôt',
                value: '${stats?.expiringSoonMembers ?? 0}',
                icon: Icons.timelapse_rounded,
                subtitle: 'À renouveler rapidement',
              ),
              const SizedBox(height: AppSpacing.md),

              StatCard(
                title: 'Sans paiement',
                value: '${stats?.noPaymentMembers ?? 0}',
                icon: Icons.info_outline_rounded,
                subtitle: 'Aucun historique',
              ),
              const SizedBox(height: AppSpacing.md),

              StatCard(
                title: 'Paiements du mois',
                value:
                    '${(stats?.totalPaymentsThisMonth ?? 0).toStringAsFixed(0)} DH',
                icon: Icons.payments_rounded,
                subtitle: 'Montant encaissé',
              ),
              const SizedBox(height: AppSpacing.xl),

              const SectionTitle(title: 'Accès rapide'),
              const SizedBox(height: AppSpacing.md),

              _QuickAccessTile(
                icon: Icons.groups_rounded,
                title: 'Gérer les adhérents',
                subtitle: 'Ajouter, modifier, rechercher',
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MembersPage()),
                  );
                  if (!mounted) return;
                  _refresh();
                },
              ),
              const SizedBox(height: AppSpacing.sm),

              _QuickAccessTile(
                icon: Icons.fitness_center_rounded,
                title: 'Gérer les sports',
                subtitle: 'Ajouter, modifier, supprimer',
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SportsPage()),
                  );
                  if (!mounted) return;
                  _refresh();
                },
              ),
              const SizedBox(height: AppSpacing.sm),

              _QuickAccessTile(
                icon: Icons.qr_code_scanner_rounded,
                title: 'Scanner QR',
                subtitle: 'Ouvrir rapidement une fiche',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QrScannerPage()),
                  );
                },
              ),

              const SizedBox(height: AppSpacing.sm),

              _QuickAccessTile(
                icon: Icons.settings_rounded,
                title: 'Paramètres',
                subtitle: 'Thème, préférences de l’application',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _QuickAccessTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickAccessTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: colorScheme.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
        onTap: onTap,
      ),
    );
  }
}