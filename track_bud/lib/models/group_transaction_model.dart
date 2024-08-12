class GroupTransactionModel {
  String expenseId;
  String groupId;
  double amount;
  String description;
  String paidBy;
  DateTime date;
  List<String> splitBetween;

  GroupTransactionModel({
    required this.expenseId,
    required this.groupId,
    required this.amount,
    required this.description,
    required this.paidBy,
    required this.date,
    required this.splitBetween,
  });

  factory GroupTransactionModel.fromMap(Map<String, dynamic> map) {
    return GroupTransactionModel(
      expenseId: map['expenseId'],
      groupId: map['groupId'],
      amount: map['amount'].toDouble(),
      description: map['description'],
      paidBy: map['paidBy'],
      date: map['date'].toDate(),
      splitBetween: List<String>.from(map['splitBetween']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'expenseId': expenseId,
      'groupId': groupId,
      'amount': amount,
      'description': description,
      'paidBy': paidBy,
      'date': date,
      'splitBetween': splitBetween,
    };
  }
}
