import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track_bud/models/transaction_model.dart';
import 'package:track_bud/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add User
  Future<void> addUser(UserModel user) {
    return _db.collection('users').doc(user.userId).set(user.toMap());
  }

  // Add Transaction
  Future<void> addTransaction(TransactionModel transaction) {
    return _db
        .collection('transactions')
        .doc(transaction.transactionId)
        .set(transaction.toMap());
  }

  // Fetch User
  Future<UserModel> getUser(String userId) async {
    var snapshot = await _db.collection('users').doc(userId).get();
    return UserModel.fromMap(snapshot.data()!);
  }

  // Fetch Transaction
  Future<TransactionModel> getTransaction(String transactionId) async {
    var snapshot =
        await _db.collection('transactions').doc(transactionId).get();
    return TransactionModel.fromMap(snapshot.data()!);
  }
}
