import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionController {
  // Cache to store previously fetched data to avoid redundant network calls
  Map<String, Map<String, dynamic>> _cache = {};

  /// Fetches and returns category totals for a given user and transaction type.
  ///
  /// [userId] is the ID of the user whose transactions are being queried.
  /// [isIncome] specifies whether to fetch 'income' or 'expense' transactions.
  /// Returns a [Future] that resolves to a [Map<String, dynamic>] where:
  /// - Each key is a category name.
  /// - The value is a [Map] containing 'totalAmount' and 'transactionCount' for that category.
  Future<Map<String, dynamic>> getCategoryTotals(String userId, bool isIncome) async {
    // Create a unique key for the cache based on user ID and transaction type
    final cacheKey = '$userId-$isIncome';

    // Return cached data if it exists
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    // Query Firestore for transactions of the specified type and user
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: isIncome ? 'income' : 'expense')
        .get();

    // Initialize a map to store category data and a variable for total sum
    Map<String, dynamic> categoryData = {};
    double totalSum = 0.0;

    // Process each document in the query results
    for (var doc in querySnapshot.docs) {
      // Extract data from the document
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      String category = data['category'];
      double amount = data['amount'];

      // Update the total sum
      totalSum += amount;

      // Update the category data
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

    // Add total sum to the category data
    categoryData['totalSum'] = totalSum;

    // Cache the fetched data
    _cache[cacheKey] = categoryData;

    // Return the category data
    return categoryData;
  }
}