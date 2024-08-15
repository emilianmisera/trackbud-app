class DebtModel {
  String debtId;
  String creditorId;
  String debtorId;
  double amount;
  String description;
  String date;
  String status;  // 'pending' or 'paid'

  DebtModel({
    required this.debtId,
    required this.creditorId,
    required this.debtorId,
    required this.amount,
    required this.description,
    required this.date,
    required this.status,
  });

  factory DebtModel.fromMap(Map<String, dynamic> map) {
    return DebtModel(
      debtId: map['debtId'],
      creditorId: map['creditorId'],
      debtorId: map['debtorId'],
      amount: map['amount'].toDouble(),
      description: map['description'],
      date: map['date'],
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'debtId': debtId,
      'creditorId': creditorId,
      'debtorId': debtorId,
      'amount': amount,
      'description': description,
      'date': date,
      'status': status,
    };
  }
}