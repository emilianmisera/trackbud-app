class TransactionModel {
  String transactionId;
  String userId;
  double amount;
  String type;
  String category;
  String notes;
  DateTime date;
  String billImageUrl;
  String currency;
  String recurrenceType;

  TransactionModel({
    required this.transactionId,
    required this.userId,
    required this.amount,
    required this.type,
    required this.category,
    required this.notes,
    required this.date,
    required this.billImageUrl,
    required this.currency,
    required this.recurrenceType,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      transactionId: map['transactionId'],
      userId: map['userId'],
      amount: map['amount'].toDouble(),
      type: map['type'],
      category: map['category'],
      notes: map['notes'],
      date: map['date']
          .toDate(), // Assuming date is stored as Timestamp in Firestore
      billImageUrl: map['billImageUrl'],
      currency: map['currency'],
      recurrenceType: map['recurrenceType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'userId': userId,
      'amount': amount,
      'type': type,
      'category': category,
      'notes': notes,
      'date': date, // Convert DateTime to Timestamp if using Firestore
      'billImageUrl': billImageUrl,
      'currency': currency,
      'recurrenceType': recurrenceType,
    };
  }
}
