import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class TransactionProvider extends ChangeNotifier {
  bool _shouldReloadChart = false;
  double _totalAmount = 0.0;
  double _totalMonthlyExpense = 0.0;
  double _currentBalance = 0.0;
  String _currentTransactionType = 'expense';
  double _totalExpenseForTimeUnit = 0.0;
  List<double> _expensesForTimeUnit = [];
  Map<String, double> _categoryAmounts = {};
  final List<double> _dailyExpenses = [];

  // Getters for private fields
  bool get shouldReloadChart => _shouldReloadChart;
  double get totalAmount => _totalAmount;
  double get totalMonthlyExpense => _totalMonthlyExpense;
  double get currentBalance => _currentBalance;
  double get totalExpenseForTimeUnit => _totalExpenseForTimeUnit;
  List<double> get expensesForTimeUnit => _expensesForTimeUnit;
  Map<String, double> get categoryAmounts => _categoryAmounts;
  List<double> get dailyExpenses => _dailyExpenses;

  // Fetches the current balance from Firestore for the authenticated user
  Future<void> initializeBalance() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      _currentBalance = (userDoc.data() as Map<String, dynamic>)['bankAccountBalance'] ?? 0.0;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing balance: $e');
    }
  }

  // Adds a new transaction and updates the user's balance accordingly
  Future<void> addTransaction(String type, double amount, Map<String, dynamic> transactionData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Add transaction data to Firestore
      await FirebaseFirestore.instance.collection('transactions').add({
        ...transactionData,
        'userId': user.uid,
        'type': type,
        'amount': amount,
        'date': transactionData['date'] != null ? Timestamp.fromDate(transactionData['date'] as DateTime) : FieldValue.serverTimestamp(),
      });

      // Update current balance based on transaction type
      if (type == 'expense') {
        _currentBalance -= amount;
      } else {
        _currentBalance += amount;
      }

      // Update user's bank account balance in Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'bankAccountBalance': _currentBalance});

      _shouldReloadChart = true;

      // Recalculate total amounts for the current transaction type and monthly expenses if it's an expense
      await calculateTotalAmount(_currentTransactionType);
      if (type == 'expense') {
        await calculateTotalExpenseForCurrentMonth();
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error adding transaction: $e');
    }
  }

  // Updates an existing transaction and adjusts the balance accordingly
  Future<void> updateTransaction(String transactionId, Map<String, dynamic> updatedData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Retrieve old transaction data before updating
      DocumentSnapshot oldTransactionDoc = await FirebaseFirestore.instance.collection('transactions').doc(transactionId).get();
      Map<String, dynamic> oldData = oldTransactionDoc.data() as Map<String, dynamic>;

      // Update transaction in Firestore
      await FirebaseFirestore.instance.collection('transactions').doc(transactionId).update(updatedData);

      // Adjust balance based on old and new transaction data
      double oldAmount = oldData['amount'];
      double newAmount = updatedData['amount'];
      String oldType = oldData['type'];
      String newType = updatedData['type'];

      // Revert the old transaction impact
      if (oldType == 'expense') {
        _currentBalance += oldAmount;
      } else {
        _currentBalance -= oldAmount;
      }

      // Apply the updated transaction impact
      if (newType == 'expense') {
        _currentBalance -= newAmount;
      } else {
        _currentBalance += newAmount;
      }

      // Update the new balance in Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'bankAccountBalance': _currentBalance});

      _shouldReloadChart = true;

      // Recalculate the total amounts after updating
      await calculateTotalAmount(_currentTransactionType);
      await calculateTotalExpenseForCurrentMonth();

      notifyListeners();
    } catch (e) {
      debugPrint('Error updating transaction: $e');
    }
  }

  // Deletes a transaction and updates the balance accordingly
  Future<void> deleteTransaction(String transactionId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Retrieve the transaction data before deletion
      DocumentSnapshot transactionDoc = await FirebaseFirestore.instance.collection('transactions').doc(transactionId).get();
      Map<String, dynamic> data = transactionDoc.data() as Map<String, dynamic>;

      // Delete the transaction from Firestore
      await FirebaseFirestore.instance.collection('transactions').doc(transactionId).delete();

      // Adjust balance based on transaction type
      double amount = data['amount'];
      String type = data['type'];

      if (type == 'expense') {
        _currentBalance += amount;
      } else {
        _currentBalance -= amount;
      }

      // Update the balance in Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'bankAccountBalance': _currentBalance});

      _shouldReloadChart = true;

      // Recalculate totals after deletion
      await calculateTotalAmount(_currentTransactionType);
      await calculateTotalExpenseForCurrentMonth();

      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
    }
  }

  // Calculates the total amount for a specific transaction type (income or expense)
  Future<void> calculateTotalAmount(String transactionType) async {
    _currentTransactionType = transactionType;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('userId', isEqualTo: user.uid)
          .where('type', isEqualTo: transactionType)
          // Uncomment this line if you want to filter by date
          /*.where('date', isLessThanOrEqualTo: Timestamp.fromDate(DateTime.now()))*/
          .get();

      // Summing up the total amount for the specified transaction type
      _totalAmount = snapshot.docs.fold(0.0, (summe, doc) {
        final data = doc.data() as Map<String, dynamic>;
        return summe + (data['amount'] as num?)!.toDouble();
      });

      notifyListeners();
    } catch (e) {
      debugPrint('Error calculating total amount: $e');
    }
  }

  // Resets the reload flag for the chart
  void resetReloadFlag() {
    _shouldReloadChart = false;
  }

  // Calculates total expenses for the current month
  Future<void> calculateTotalExpenseForCurrentMonth() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Get the start and end dates of the current month
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      debugPrint("Calculating total expense for current month...");
      debugPrint("Start of month: $startOfMonth");
      debugPrint("End of month: $endOfMonth");

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('userId', isEqualTo: user.uid)
          .where('type', isEqualTo: 'expense')
          .where('date', isGreaterThanOrEqualTo: startOfMonth)
          .where('date', isLessThanOrEqualTo: endOfMonth)
          .get();

      debugPrint("Number of transactions found: ${snapshot.docs.length}");

      // Summing up all expenses for the current month
      _totalMonthlyExpense = snapshot.docs.fold(0.0, (summe, doc) {
        final data = doc.data() as Map<String, dynamic>;
        final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
        debugPrint("Transaction amount: $amount");
        return summe + amount;
      });

      debugPrint("Total monthly expense: $_totalMonthlyExpense");

      notifyListeners();
    } catch (e) {
      debugPrint('Error calculating total amount for current month: $e');
    }
  }

  // Calculates total expenses for a given time unit (e.g., day, month, year)
  Future<void> calculateTotalExpenseForTimeUnit(int timeUnit) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      DateTime startDate;
      DateTime endDate = DateTime.now();

      // Define the start date based on the given time unit (0: Day, 1: Month, 2: Year)
      switch (timeUnit) {
        case 0: // Day
          startDate = DateTime(endDate.year, endDate.month, endDate.day);
          break;
        /*
        case 1: // Week (Focuses on the last 7 days instead of the week of the month)
          startDate = endDate.subtract(const Duration(days: 6)); // 7 days back
          break;
        */
        case 1: // Month
          startDate = DateTime(endDate.year, endDate.month, 1);
          break;
        case 2: // Year
          startDate = DateTime(endDate.year, 1, 1);
          break;
        default:
          // Week (starts from the first day of the current week)
          startDate = endDate.subtract(Duration(days: endDate.weekday - 1));
      }

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('userId', isEqualTo: user.uid)
          .where('type', isEqualTo: 'expense')
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .orderBy('date', descending: false)
          .get();

      // Initialize values for the new time unit
      _totalExpenseForTimeUnit = 0.0;
      _expensesForTimeUnit = [];
      _categoryAmounts = {};

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final amount = (data['amount'] as num).toDouble();
        final category = data['category'] as String;
        final date = (data['date'] as Timestamp).toDate();

        // Aggregate totals
        _totalExpenseForTimeUnit += amount;
        _categoryAmounts[category] = (_categoryAmounts[category] ?? 0) + amount;

        // Aggregate expenses based on the time unit
        switch (timeUnit) {
          case 0: // Day
            _expensesForTimeUnit.add(amount);
            break;
          /*
          case 1: // Week
            while (_expensesForTimeUnit.length <
                date.difference(startDate).inDays + 1) {
              _expensesForTimeUnit.add(0);
            }
            _expensesForTimeUnit[date.difference(startDate).inDays] += amount;
            break;
          */
          case 1: // Month
            while (_expensesForTimeUnit.length < date.day) {
              _expensesForTimeUnit.add(0);
            }
            _expensesForTimeUnit[date.day - 1] += amount;
            break;
          case 2: // Year
            while (_expensesForTimeUnit.length < date.month) {
              _expensesForTimeUnit.add(0);
            }
            _expensesForTimeUnit[date.month - 1] += amount;
            break;
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error calculating total expense for time unit: $e');
    }
  }
}