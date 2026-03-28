class DashboardStatsModel {
  final int totalMembers;
  final int activeMembers;
  final int expiredMembers;
  final int expiringSoonMembers;
  final int noPaymentMembers;
  final double totalPaymentsThisMonth;

  const DashboardStatsModel({
    required this.totalMembers,
    required this.activeMembers,
    required this.expiredMembers,
    required this.expiringSoonMembers,
    required this.noPaymentMembers,
    required this.totalPaymentsThisMonth,
  });
}