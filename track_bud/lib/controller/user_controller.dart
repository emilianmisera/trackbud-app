import 'package:cloud_firestore/cloud_firestore.dart';

class UserController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateBankAccountBalance(String userId, double amount) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'bankAccountBalance': amount,
      });
    } catch (e) {
      throw Exception("Fehler beim Aktualisieren des Bankkontos: $e");
    }
  }

  Future<void> updateBudgetGoal(String userId, double amount) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'monthlySpendingGoal': amount,
      });
    } catch (e) {
      throw Exception("Fehler beim Aktualisieren des Budgets: $e");
    }
  }

  Future<double> getBankAccountBalance(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.get('bankAccountBalance')?.toDouble() ?? 0.0;
      } else {
        throw Exception("Benutzerdokument nicht gefunden.");
      }
    } catch (e) {
      throw Exception("Fehler beim Abrufen des Bankkontostands: $e");
    }
  }

  Future<double> getBudgetGoal(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.get('monthlySpendingGoal')?.toDouble() ?? 0.0;
      } else {
        throw Exception("Benutzerdokument nicht gefunden.");
      }
    } catch (e) {
      throw Exception("Fehler beim Abrufen des Budgets: $e");
    }
  }

  Future<String> getUserName(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.get('name') as String;
      } else {
        throw Exception("Benutzerdokument nicht gefunden.");
      }
    } catch (e) {
      throw Exception("Fehler beim Abrufen des Namens: $e");
    }
  }

  Future<String> getUserEmail(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.get('email') as String;
      } else {
        throw Exception("Benutzerdokument nicht gefunden.");
      }
    } catch (e) {
      throw Exception("Fehler beim Abrufen der Email: $e");
    }
  }
}
