import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionController {

  Future<Map<String, dynamic>> getCategoryTotals(
      String userId, bool isIncome) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('transactions')
      .where('userId', isEqualTo: userId)
      .where('type', isEqualTo: isIncome ? 'income' : 'expense')
      .get();

  Map<String, dynamic> categoryData = {};

  for (var doc in querySnapshot.docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String category = data['category'];
    double amount = data['amount'];

    if (categoryData.containsKey(category)) {
      categoryData[category]['totalAmount'] += amount;
      categoryData[category]['transactionCount'] += 1;
    } else {
      categoryData[category] = {
        'totalAmount': amount,
        'transactionCount': 1,
      };
    }
  }

  return categoryData;
  }
}
