class PaymentModel {
  final int? id;
  final int memberId;
  final String paymentDate;
  final double amountPaid;
  final String startDate;
  final String endDate;
  final String paymentMethod;
  final String? note;
  final String status;
  final String createdAt;

  PaymentModel({
    this.id,
    required this.memberId,
    required this.paymentDate,
    required this.amountPaid,
    required this.startDate,
    required this.endDate,
    required this.paymentMethod,
    this.note,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'member_id': memberId,
      'payment_date': paymentDate,
      'amount_paid': amountPaid,
      'start_date': startDate,
      'end_date': endDate,
      'payment_method': paymentMethod,
      'note': note,
      'status': status,
      'created_at': createdAt,
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'],
      memberId: map['member_id'],
      paymentDate: map['payment_date'] ?? '',
      amountPaid: (map['amount_paid'] as num).toDouble(),
      startDate: map['start_date'] ?? '',
      endDate: map['end_date'] ?? '',
      paymentMethod: map['payment_method'] ?? '',
      note: map['note'],
      status: map['status'] ?? '',
      createdAt: map['created_at'] ?? '',
    );
  }
}