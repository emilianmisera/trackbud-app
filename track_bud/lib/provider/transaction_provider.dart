import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class TransactionProvider extends ChangeNotifier {
  bool _shouldReloadChart = false;
  double _totalAmount = 0.0;
  double _totalMonthlyExpense = 0.0;
  double _currentBalance = 0.0;
  String _currentTransactionType = 'expense';

  bool get shouldReloadChart => _shouldReloadChart;
  double get totalAmount => _totalAmount;
  double get totalMonthlyExpense => _totalMonthlyExpense;
  double get currentBalance => _currentBalance;

  Future<void> initializeBalance() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      _currentBalance =
          (userDoc.data() as Map<String, dynamic>)['bankAccountBalance'] ?? 0.0;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing balance: $e');
    }
  }

  Future<void> addTransaction(
      String type, double amount, Map<String, dynamic> transactionData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Add transaction to Firestore
      await FirebaseFirestore.instance.collection('transactions').add({
        ...transactionData,
        'userId': user.uid,
        'type': type,
        'amount': amount,
        'date': transactionData['date'] != null
            ? Timestamp.fromDate(transactionData['date'] as DateTime)
            : FieldValue.serverTimestamp(),
      });

      // Update current balance
      if (type == 'expense') {
        _currentBalance -= amount;
      } else {
        _currentBalance += amount;
      }

      // Update user's bank account balance in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'bankAccountBalance': _currentBalance});

      _shouldReloadChart = true;

      // Recalculate the total amount for the current transaction type
      await calculateTotalAmount(_currentTransactionType);
      if (type == 'expense') {
      await calculateTotalExpenseForCurrentMonth(); 
    }

      notifyListeners();
    } catch (e) {
      debugPrint('Error adding transaction: $e');
    }
  }

  Future<void> updateTransaction(String transactionId, Map<String, dynamic> updatedData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Get the old transaction data
      DocumentSnapshot oldTransactionDoc = await FirebaseFirestore.instance
          .collection('transactions')
          .doc(transactionId)
          .get();
      
      Map<String, dynamic> oldData = oldTransactionDoc.data() as Map<String, dynamic>;

      // Update the transaction in Firestore
      await FirebaseFirestore.instance
          .collection('transactions')
          .doc(transactionId)
          .update(updatedData);

      // Adjust the current balance
      double oldAmount = oldData['amount'];
      double newAmount = updatedData['amount'];
      String oldType = oldData['type'];
      String newType = updatedData['type'];

      if (oldType == 'expense') {
        _currentBalance += oldAmount;
      } else {
        _currentBalance -= oldAmount;
      }

      if (newType == 'expense') {
        _currentBalance -= newAmount;
      } else {
        _currentBalance += newAmount;
      }

      // Update user's bank account balance in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'bankAccountBalance': _currentBalance});

      _shouldReloadChart = true;

      // Recalculate totals
      await calculateTotalAmount(_currentTransactionType);
      await calculateTotalExpenseForCurrentMonth();

      notifyListeners();
    } catch (e) {
      debugPrint('Error updating transaction: $e');
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Get the transaction data before deleting
      DocumentSnapshot transactionDoc = await FirebaseFirestore.instance
          .collection('transactions')
          .doc(transactionId)
          .get();
      
      Map<String, dynamic> data = transactionDoc.data() as Map<String, dynamic>;

      // Delete the transaction from Firestore
      await FirebaseFirestore.instance
          .collection('transactions')
          .doc(transactionId)
          .delete();

      // Adjust the current balance
      double amount = data['amount'];
      String type = data['type'];

      if (type == 'expense') {
        _currentBalance += amount;
      } else {
        _currentBalance -= amount;
      }

      // Update user's bank account balance in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'bankAccountBalance': _currentBalance});

      _shouldReloadChart = true;

      // Recalculate totals
      await calculateTotalAmount(_currentTransactionType);
      await calculateTotalExpenseForCurrentMonth();

      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
    }
  }

  Future<void> calculateTotalAmount(String transactionType) async {
    _currentTransactionType = transactionType;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('userId', isEqualTo: user.uid)
          .where('type', isEqualTo: transactionType)
          .get();

      _totalAmount = snapshot.docs.fold(0.0, (sum, doc) {
        final data = doc.data() as Map<String, dynamic>;
        return sum + (data['amount'] as num?)!.toDouble();
      });

      notifyListeners();
    } catch (e) {
      debugPrint('Error calculating total amount: $e');
    }
  }

  void resetReloadFlag() {
    _shouldReloadChart = false;
  }

  Future<void> calculateTotalExpenseForCurrentMonth() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Get the start and end of the current month
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

      _totalMonthlyExpense = snapshot.docs.fold(0.0, (sum, doc) {
        final data = doc.data() as Map<String, dynamic>;
        final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
        debugPrint("Transaction amount: $amount");
        return sum + amount;
      });

      debugPrint("Total monthly expense: $_totalMonthlyExpense");

      notifyListeners();
    } catch (e) {
      debugPrint('Error calculating total amount for current month: $e');
    }
  }
}
