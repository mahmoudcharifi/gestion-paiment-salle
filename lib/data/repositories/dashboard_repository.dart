import '../models/dashboard_stats_model.dart';
import '../models/payment_model.dart';
import 'member_repository.dart';
import 'payment_repository.dart';
import '../../core/utils/member_status_utils.dart';

class DashboardRepository {
  final MemberRepository _memberRepository = MemberRepository();
  final PaymentRepository _paymentRepository = PaymentRepository();

  Future<DashboardStatsModel> getDashboardStats() async {
    final members = await _memberRepository.getAllMembersWithSports();

    int activeMembers = 0;
    int expiredMembers = 0;
    int expiringSoonMembers = 0;
    int noPaymentMembers = 0;

    for (final item in members) {
      final memberId = item.member.id;
      if (memberId == null) continue;

      final PaymentModel? latestPayment =
          await _paymentRepository.getLatestPaymentByMemberId(memberId);

      final statusData = MemberStatusUtils.getStatusFromPayments(
        latestPayment == null ? [] : [latestPayment],
      );

      switch (statusData.status) {
        case MemberStatus.active:
          activeMembers++;
          break;
        case MemberStatus.expired:
          expiredMembers++;
          break;
        case MemberStatus.expiringSoon:
          expiringSoonMembers++;
          break;
        case MemberStatus.noPayment:
          noPaymentMembers++;
          break;
      }
    }

    final totalPaymentsThisMonth =
        await _paymentRepository.getTotalPaymentsThisMonth();

    return DashboardStatsModel(
      totalMembers: members.length,
      activeMembers: activeMembers,
      expiredMembers: expiredMembers,
      expiringSoonMembers: expiringSoonMembers,
      noPaymentMembers: noPaymentMembers,
      totalPaymentsThisMonth: totalPaymentsThisMonth,
    );
  }
}