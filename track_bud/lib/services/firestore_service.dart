import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track_bud/models/transaction_model.dart';
import 'package:track_bud/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUserIfNotExists(UserModel user) async {
  try {
    // Suche nach Benutzern mit der gleichen E-Mail-Adresse
    var existingUsers = await _db
        .collection('users')
        .where('email', isEqualTo: user.email)
        .get();

    if (existingUsers.docs.isEmpty) {
      // Wenn kein Benutzer mit dieser E-Mail existiert, füge ihn hinzu
      await addUser(user);
    } else {
      print("Benutzer mit dieser E-Mail existiert bereits.");
    }
  } catch (e) {
    print("Fehler beim Hinzufügen des Benutzers: $e");
  }
}

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

  // Methode zum Abrufen der Benutzerdaten
  Future<UserModel?> getUserData(String userId) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print('Fehler beim Abrufen der Benutzerdaten: $e');
      return null;
    }
  }

  // Fetch Transactions for currentUser
  Future<List<TransactionModel>> getTransactionsForUser(String userId) async {
  try {
    // Abrufen aller Transaktionen, die zur angegebenen Benutzer-ID gehören
    var querySnapshot = await _db
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .get();

    // Liste von TransactionModel aus den Dokumenten erstellen
    return querySnapshot.docs
        .map((doc) => TransactionModel.fromMap(doc.data()))
        .toList();
  } catch (e) {
    // Fehlerbehandlung
    print("Fehler beim Abrufen der Transaktionen: $e");
    return [];
  }
}

  Future<void> updateUserNameInFirestore(String userId, String newName) async {
  try {
    await _db.collection('users').doc(userId).update({'name': newName});
  } catch (e) {
    print("Fehler beim Aktualisieren des Nutzernamens in Firestore: $e");
  }
}

Future<void> updateUserProfileImageInFirestore(String userId, String imageUrl) async {
  try {
    await _db.collection('users').doc(userId).update({'profilePictureUrl': imageUrl});
  } catch (e) {
    print("Fehler beim Aktualisieren des Profilbildes in Firestore: $e");
    throw e;  // Werfen Sie den Fehler, um ihn in der aufrufenden Methode zu behandeln
  }
}
}
