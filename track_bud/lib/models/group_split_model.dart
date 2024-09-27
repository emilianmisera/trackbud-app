import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupSplitModel {
  String groupSplitId;
  String groupId; // Link to the group this split belongs to
  double totalAmount;
  String title;
  String category;
  String type; // 'expense' or 'income'
  Timestamp date;
  String paidBy; // The person who initially paid for the expense
  List<Map<String, dynamic>> splitShares; // Details of each participant's share

  GroupSplitModel({
    required this.groupSplitId,
    required this.groupId,
    required this.totalAmount,
    required this.title,
    required this.category,
    required this.type,
    required this.date,
    required this.paidBy,
    required this.splitShares,
  });

  factory GroupSplitModel.fromMap(Map<String, dynamic> map) {
    debugPrint('Mapping document to GroupSplitModel: $map');
    return GroupSplitModel(
      groupSplitId: map['groupSplitId'],
      groupId: map['groupId'],
      totalAmount: map['totalAmount'].toDouble(),
      title: map['title'],
      category: map['category'],
      type: map['type'],
      date: map['date'],
      paidBy: map['paidBy'],
      splitShares: List<Map<String, dynamic>>.from(map['splitShares']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupSplitId': groupSplitId,
      'groupId': groupId,
      'totalAmount': totalAmount,
      'title': title,
      'category': category,
      'type': type,
      'date': date,
      'paidBy': paidBy,
      'splitShares': splitShares,
    };
  }
}
