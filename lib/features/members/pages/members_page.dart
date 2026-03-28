import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/member_status_utils.dart';
import '../../../data/models/payment_model.dart';
import '../../../data/repositories/member_repository.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../shared/widgets/app_search_bar.dart';
import '../../../shared/widgets/delete_confirmation_dialog.dart';
import '../../../shared/widgets/sport_chip.dart';
import '../../../shared/widgets/status_badge.dart';
import '../controllers/members_controller.dart';
import 'add_member_page.dart';
import 'member_details_page.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  final TextEditingController _searchController = TextEditingController();
  final PaymentRepository _paymentRepository = PaymentRepository();

  List<MemberWithSports> _filteredMembers = [];
  final Map<int, MemberStatusData> _statusCache = {};

  String _searchQuery = '';
  String _selectedSport = 'Tous';
  String _selectedStatus = 'Tous';

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<MembersController>().loadInitialData();
      await _applyFilters();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _reloadData() async {
    _statusCache.clear();
    await context.read<MembersController>().loadInitialData();
    await _applyFilters();
  }

  Future<MemberStatusData> _getMemberStatus(int memberId) async {
    if (_statusCache.containsKey(memberId)) {
      return _statusCache[memberId]!;
    }

    final PaymentModel? latestPayment =
        await _paymentRepository.getLatestPaymentByMemberId(memberId);

    final statusData = MemberStatusUtils.getStatusFromPayments(
      latestPayment == null ? [] : [latestPayment],
    );

    _statusCache[memberId] = statusData;
    return statusData;
  }

  Future<void> _applyFilters() async {
    final controller = context.read<MembersController>();
    final source = controller.members;

    List<MemberWithSports> result = [];

    for (final item in source) {
      final member = item.member;
      final memberId = member.id;

      if (memberId == null) continue;

      final matchesSearch = _searchQuery.trim().isEmpty
          ? true
          : [
              member.firstName,
              member.lastName,
              member.phone,
              member.cin ?? '',
              member.qrCode,
              ...item.sports,
            ].join(' ').toLowerCase().contains(_searchQuery.toLowerCase());

      if (!matchesSearch) continue;

      final matchesSport = _selectedSport == 'Tous'
          ? true
          : item.sports.any(
              (sport) => sport.toLowerCase() == _selectedSport.toLowerCase(),
            );

      if (!matchesSport) continue;

      final statusData = await _getMemberStatus(memberId);

      final matchesStatus = _selectedStatus == 'Tous'
          ? true
          : statusData.label.toLowerCase() == _selectedStatus.toLowerCase();

      if (!matchesStatus) continue;

      result.add(item);
    }

    if (!mounted) return;

    setState(() {
      _filteredMembers = result;
    });
  }

  Future<void> _goToAddMemberPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddMemberPage()),
    );

    if (!mounted) return;
    await _reloadData();
  }

  Widget _buildSportFilters(MembersController controller) {
    final sports = ['Tous', ...controller.sports.map((e) => e.name)];

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: sports.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final sport = sports[index];
          final selected = _selectedSport == sport;

          return ChoiceChip(
            label: Text(sport),
            selected: selected,
            onSelected: (_) async {
              setState(() {
                _selectedSport = sport;
              });
              await _applyFilters();
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusFilters() {
    const statuses = [
      'Tous',
      'Actif',
      'Expire bientôt',
      'Expiré',
      'Aucun paiement',
    ];

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: statuses.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final status = statuses[index];
          final selected = _selectedStatus == status;

          return ChoiceChip(
            label: Text(status),
            selected: selected,
            onSelected: (_) async {
              setState(() {
                _selectedStatus = status;
              });
              await _applyFilters();
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MembersController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adhérents'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToAddMemberPage,
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('Ajouter'),
      ),
      body: controller.isLoading && controller.members.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _reloadData,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  const Text(
                    'Liste des adhérents',
                    style: AppTextStyles.pageTitle,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  AppSearchBar(
                    controller: _searchController,
                    hint: 'Nom, téléphone, CIN, QR, sport...',
                    onChanged: (value) async {
                      _searchQuery = value;
                      await _applyFilters();
                    },
                  ),

                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Filtrer par sport',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildSportFilters(controller),

                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Filtrer par statut',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildStatusFilters(),

                  const SizedBox(height: AppSpacing.lg),

                  if (_filteredMembers.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: Text('Aucun adhérent ne correspond aux filtres'),
                      ),
                    )
                  else
                    ..._filteredMembers.map((item) {
                      final member = item.member;

                      return FutureBuilder<MemberStatusData>(
                        future: _getMemberStatus(member.id!),
                        builder: (context, snapshot) {
                          final statusData = snapshot.data ??
                              const MemberStatusData(
                                status: MemberStatus.noPayment,
                                label: 'Aucun paiement',
                              );

                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MemberDetailsPage(item: item),
                                  ),
                                );

                                if (!mounted) return;
                                await _reloadData();
                              },
                              child: Card(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.all(AppSpacing.md),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 26,
                                        backgroundImage:
                                            member.photoPath != null &&
                                                    member.photoPath!
                                                        .trim()
                                                        .isNotEmpty
                                                ? FileImage(
                                                    File(member.photoPath!),
                                                  )
                                                : null,
                                        child: (member.photoPath == null ||
                                                member.photoPath!
                                                    .trim()
                                                    .isEmpty)
                                            ? Text(
                                                member.firstName.isNotEmpty
                                                    ? member.firstName[0]
                                                        .toUpperCase()
                                                    : '?',
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: AppSpacing.md),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${member.firstName} ${member.lastName}',
                                              style: AppTextStyles.cardTitle,
                                            ),
                                            const SizedBox(height: 4),
                                            Text('Téléphone : ${member.phone}'),
                                            const SizedBox(height: 4),
                                            Text('QR : ${member.qrCode}'),
                                            const SizedBox(height: 8),
                                            if (item.sports.isNotEmpty)
                                              Wrap(
                                                spacing: 8,
                                                runSpacing: 8,
                                                children: item.sports
                                                    .map((sport) =>
                                                        SportChip(label: sport))
                                                    .toList(),
                                              ),
                                            const SizedBox(height: 8),
                                            StatusBadge(
                                              text: statusData.label,
                                              type: MemberStatusUtils.toBadgeType(
                                                statusData.status,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete_outline,
                                            ),
                                            onPressed: () async {
                                              final confirmed =
                                                  await showDeleteConfirmationDialog(
                                                context: context,
                                                title:
                                                    'Supprimer l’adhérent',
                                                message:
                                                    'Voulez-vous vraiment supprimer ${member.firstName} ${member.lastName} ?',
                                              );

                                              if (!confirmed) return;

                                              await controller
                                                  .deleteMember(member.id!);

                                              if (!context.mounted) return;
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Adhérent supprimé',
                                                  ),
                                                ),
                                              );

                                              await _reloadData();
                                            },
                                          ),
                                          const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                ],
              ),
            ),
    );
  }
}