import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  String transactionId;
  String userId;
  String title;
  double amount;
  String type;  // 'expense' or 'income'
  String category;
  String notes;
  DateTime date;
  String billImageUrl;
  String currency;
  String recurrenceType;  // 'daily', 'weekly', 'monthly', 'one-time'

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
      date: map['date'] is Timestamp ? (map['date'] as Timestamp).toDate() : DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      billImageUrl: map['billImageUrl'],
      currency: map['currency'],
      recurrenceType: map['recurrenceType'],
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
      'date': date.millisecondsSinceEpoch,
      'billImageUrl': billImageUrl,
      'currency': currency,
      'recurrenceType': recurrenceType,
    };
  }

  Map<String, dynamic> toFirestoreMap() {
    var map = toMap();
    map['date'] = Timestamp.fromDate(date);
    return map;
  }
}