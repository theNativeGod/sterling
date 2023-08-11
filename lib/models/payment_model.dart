class Payment {
  String? transactionNo;
  String? paymentDate;
  String? amount;
  String? paymentSource;
  String? status;
  String? tripId;

  Payment({
    required this.transactionNo,
    required this.amount,
    required this.paymentDate,
    required this.paymentSource,
    required this.status,
    required this.tripId,
  });
}
