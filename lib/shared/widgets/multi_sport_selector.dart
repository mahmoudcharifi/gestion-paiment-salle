import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../data/models/sport_model.dart';
import 'sport_chip.dart';

class MultiSportSelector extends StatelessWidget {
  final List<SportModel> sports;
  final List<int> selectedSportIds;
  final ValueChanged<List<int>> onChanged;

  const MultiSportSelector({
    super.key,
    required this.sports,
    required this.selectedSportIds,
    required this.onChanged,
  });

  Future<void> _openSelector(BuildContext context) async {
    final result = await showModalBottomSheet<List<int>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        final tempSelected = [...selectedSportIds];

        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Choisir les sports',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: sports.map((sport) {
                        final isSelected = tempSelected.contains(sport.id);

                        return FilterChip(
                          label: Text(sport.name),
                          selected: isSelected,
                          onSelected: (selected) {
                            setModalState(() {
                              if (selected) {
                                tempSelected.add(sport.id!);
                              } else {
                                tempSelected.remove(sport.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context, selectedSportIds);
                            },
                            child: const Text('Annuler'),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, tempSelected);
                            },
                            child: const Text('Valider'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedSports = sports
        .where((sport) => selectedSportIds.contains(sport.id))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _openSelector(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.sports_mma_rounded),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    selectedSports.isEmpty
                        ? 'Choisir un ou plusieurs sports'
                        : '${selectedSports.length} sport(s) sélectionné(s)',
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        ),
        if (selectedSports.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: selectedSports
                .map((sport) => SportChip(label: sport.name))
                .toList(),
          ),
        ],
      ],
    );
  }
}