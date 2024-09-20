import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  String transactionId;
  String userId;
  String title;
  double amount;
  String type; // 'expense' or 'income'
  String category;
  String note;
  DateTime date;
  String billImageUrl;
  String currency;
  String recurrence; // 'daily', 'weekly', 'monthly', 'one-time'

  TransactionModel({
    required this.transactionId,
    required this.userId,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.note,
    required this.date,
    required this.billImageUrl,
    required this.currency,
    required this.recurrence,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      transactionId: map['transactionId'],
      userId: map['userId'],
      title: map['title'],
      amount: map['amount'].toDouble(),
      type: map['type'],
      category: map['category'],
      note: map['note'],
      date: map['date'] is Timestamp
          ? (map['date'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      billImageUrl: map['billImageUrl'],
      currency: map['currency'],
      recurrence: map['recurrence'],
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
      'note': note,
      'date': date.millisecondsSinceEpoch,
      'billImageUrl': billImageUrl,
      'currency': currency,
      'recurrence': recurrence,
    };
  }

  Map<String, dynamic> toFirestoreMap() {
    var map = toMap();
    map['date'] = Timestamp.fromDate(date);
    return map;
  }
}
