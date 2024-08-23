import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class GroupTransactionModel {
  String transactionId;
  String groupId;
  double amount;
  String description;
  String type;  // 'expense' or 'income'
  String paidBy;
  Timestamp date;
  List<String> splitBetween;

  GroupTransactionModel({
    required this.transactionId,
    required this.groupId,
    required this.amount,
    required this.description,
    required this.type,
    required this.paidBy,
    required this.date,
    required this.splitBetween,
  });

  factory GroupTransactionModel.fromMap(Map<String, dynamic> map) {
    return GroupTransactionModel(
      transactionId: map['transactionId'],
      groupId: map['groupId'],
      amount: map['amount'].toDouble(),
      description: map['description'],
      type: map['type'],
      paidBy: map['paidBy'],
      date: map['date'],
      splitBetween: List<String>.from(jsonDecode(map['splitBetween'])),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'groupId': groupId,
      'amount': amount,
      'description': description,
      'type': type,
      'paidBy': paidBy,
      'date': date,
      'splitBetween': jsonEncode(splitBetween),
    };
  }
}