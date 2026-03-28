import 'package:flutter/material.dart';

class SportChip extends StatelessWidget {
  final String label;

  const SportChip({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.20),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}