class TransactionModel {
  String transactionId;
  String userId;
  String title;
  double amount;
  String type;  // 'expense' or 'income'
  String category;
  String notes;
  String date;
  String billImageUrl;
  String currency;
  String recurrenceType;  // 'daily', 'weekly', 'monthly', 'one-time'
  bool isSynced;

  TransactionModel({
    required this.transactionId,
    required this.userId,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.notes,
    required this.date,
    required this.billImageUrl,
    required this.currency,
    required this.recurrenceType,
    this.isSynced = false,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      transactionId: map['transactionId'],
      userId: map['userId'],
      title: map['title'],
      amount: map['amount'].toDouble(),
      type: map['type'],
      category: map['category'],
      notes: map['notes'],
      date: map['date'],
      billImageUrl: map['billImageUrl'],
      currency: map['currency'],
      recurrenceType: map['recurrenceType'],
      isSynced: map['isSynced'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'userId': userId,
      'title': title,
      'amount': amount,
      'type': type,
      'category': category,
      'notes': notes,
      'date': date,
      'billImageUrl': billImageUrl,
      'currency': currency,
      'recurrenceType': recurrenceType,
      'isSynced': isSynced ? 1 : 0,
    };
  }
}