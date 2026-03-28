import 'package:flutter/material.dart';

import '../../../data/models/payment_model.dart';
import '../../../data/repositories/payment_repository.dart';

class PaymentsController extends ChangeNotifier {
  final PaymentRepository _paymentRepository = PaymentRepository();

  List<PaymentModel> payments = [];
  bool isLoading = false;

  Future<void> loadMemberPayments(int memberId) async {
    isLoading = true;
    notifyListeners();

    payments = await _paymentRepository.getPaymentsByMemberId(memberId);

    isLoading = false;
    notifyListeners();
  }

  Future<void> addPayment(PaymentModel payment) async {
    isLoading = true;
    notifyListeners();

    await _paymentRepository.addPayment(payment);
    payments = await _paymentRepository.getPaymentsByMemberId(payment.memberId);

    isLoading = false;
    notifyListeners();
  }

  Future<void> deletePayment(int paymentId, int memberId) async {
    isLoading = true;
    notifyListeners();

    await _paymentRepository.deletePayment(paymentId);
    payments = await _paymentRepository.getPaymentsByMemberId(memberId);

    isLoading = false;
    notifyListeners();
  }
}