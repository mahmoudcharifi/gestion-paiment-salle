import '../../data/models/payment_model.dart';
import '../../shared/widgets/status_badge.dart';

enum MemberStatus {
  active,
  expiringSoon,
  expired,
  noPayment,
}

class MemberStatusData {
  final MemberStatus status;
  final String label;

  const MemberStatusData({
    required this.status,
    required this.label,
  });
}

class MemberStatusUtils {
  static MemberStatusData getStatusFromPayments(List<PaymentModel> payments) {
    if (payments.isEmpty) {
      return const MemberStatusData(
        status: MemberStatus.noPayment,
        label: 'Aucun paiement',
      );
    }

    final sortedPayments = [...payments]
      ..sort(
        (a, b) => DateTime.parse(b.endDate).compareTo(DateTime.parse(a.endDate)),
      );

    final latestPayment = sortedPayments.first;
    final endDate = DateTime.parse(latestPayment.endDate);
    final today = DateTime.now();

    final normalizedToday = DateTime(today.year, today.month, today.day);
    final normalizedEndDate = DateTime(endDate.year, endDate.month, endDate.day);

    if (normalizedEndDate.isBefore(normalizedToday)) {
      return const MemberStatusData(
        status: MemberStatus.expired,
        label: 'Expiré',
      );
    }

    final difference = normalizedEndDate.difference(normalizedToday).inDays;

    if (difference <= 5) {
      return const MemberStatusData(
        status: MemberStatus.expiringSoon,
        label: 'Expire bientôt',
      );
    }

    return const MemberStatusData(
      status: MemberStatus.active,
      label: 'Actif',
    );
  }

  static StatusType toBadgeType(MemberStatus status) {
    switch (status) {
      case MemberStatus.active:
        return StatusType.success;
      case MemberStatus.expiringSoon:
        return StatusType.warning;
      case MemberStatus.expired:
        return StatusType.danger;
      case MemberStatus.noPayment:
        return StatusType.info;
    }
  }
}