import 'package:cloud_firestore/cloud_firestore.dart';

class FriendSplitModel {
  String splitId;
  String creditorId;
  String debtorId;
  double creditorAmount;
  double debtorAmount;
  String title;
  String category;
  String type;  // 'expense' or 'income'
  Timestamp date;
  String status;  // 'pending' or 'paid'

  FriendSplitModel({
    required this.splitId,
    required this.creditorId,
    required this.debtorId,
    required this.creditorAmount,
    required this.debtorAmount,
    required this.title,
    required this.category,
    required this.type,
    required this.date,
    required this.status,
  });

  factory FriendSplitModel.fromMap(Map<String, dynamic> map) {
    return FriendSplitModel(
      splitId: map['splitId'],
      creditorId: map['creditorId'],
      debtorId: map['debtorId'],
      creditorAmount: map['creditorAmount'].toDouble(),
      debtorAmount: map['debtorAmount'].toDouble(),
      title: map['title'],
      category: map['category'],
      type: map['type'],
      date: map['date'],
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'splitId': splitId,
      'creditorId': creditorId,
      'debtorId': debtorId,
      'creditorAmount': creditorAmount,
      'debtorAmount': debtorAmount,
      'title': title,
      'category': category,
      'type': type,
      'date': date,
      'status': status,
    };
  }
}