import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

enum StatusType { success, warning, danger, info }

class StatusBadge extends StatelessWidget {
  final String text;
  final StatusType type;

  const StatusBadge({
    super.key,
    required this.text,
    required this.type,
  });

  Color _backgroundColor() {
    switch (type) {
      case StatusType.success:
        return AppColors.success.withValues(alpha: 0.12);
      case StatusType.warning:
        return AppColors.warning.withValues(alpha: 0.12);
      case StatusType.danger:
        return AppColors.danger.withValues(alpha: 0.12);
      case StatusType.info:
        return AppColors.info.withValues(alpha: 0.12);
    }
  }

  Color _textColor() {
    switch (type) {
      case StatusType.success:
        return AppColors.success;
      case StatusType.warning:
        return AppColors.warning;
      case StatusType.danger:
        return AppColors.danger;
      case StatusType.info:
        return AppColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _backgroundColor(),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: _textColor(),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}