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
        .set(transaction.toFirestoreMap());
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

  Future<void> updateUserNameInFirestore(String userId, String newName) async {
    try {
      await _db.collection('users').doc(userId).update({'name': newName});
    } catch (e) {
      print("Fehler beim Aktualisieren des Nutzernamens in Firestore: $e");
    }
  }

  Future<void> updateUserProfileImageInFirestore(
      String userId, String imageUrl) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .update({'profilePictureUrl': imageUrl});
    } catch (e) {
      print("Fehler beim Aktualisieren des Profilbildes in Firestore: $e");
      throw e; // Werfen Sie den Fehler, um ihn in der aufrufenden Methode zu behandeln
    }
  }

  // Temporarily store new email address
  Future<void> storeNewEmail(String userId, String newEmail) async {
    await _db.collection('users').doc(userId).update({
      'pendingNewEmail': newEmail,
    });
  }

  // Retrieve the stored email after verification
  Future<String?> getPendingNewEmail(String userId) async {
    DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
    return doc.get('pendingNewEmail') as String?;
  }

  // Clear the stored email after update
  Future<void> clearPendingNewEmail(String userId) async {
    await _db.collection('users').doc(userId).update({
      'pendingNewEmail': FieldValue.delete(),
    });
  }

  // add Friend
  Future<void> addFriend(String currentUserId, String friendUserId) async {
    try {
      DocumentSnapshot currentUserDoc =
          await _db.collection('users').doc(currentUserId).get();

      if (currentUserDoc.exists) {
        List<String> currentFriends =
            (currentUserDoc.get('friends') as List<dynamic>?)?.cast<String>() ??
                [];

        if (!currentFriends.contains(friendUserId)) {
          currentFriends.add(friendUserId);

          await _db.collection('users').doc(currentUserId).update({
            'friends': currentFriends,
          });

          // Aktualisiere auch die Freundesliste des anderen Benutzers
          DocumentSnapshot friendUserDoc =
              await _db.collection('users').doc(friendUserId).get();
          if (friendUserDoc.exists) {
            List<String> friendFriends =
                (friendUserDoc.get('friends') as List<dynamic>?)
                        ?.cast<String>() ??
                    [];
            if (!friendFriends.contains(currentUserId)) {
              friendFriends.add(currentUserId);
              await _db.collection('users').doc(friendUserId).update({
                'friends': friendFriends,
              });
            }
          }
          print("Freund erfolgreich hinzugefügt");
        } else {
          print("Freundschaft besteht bereits.");
        }
      } else {
        print("Benutzer nicht gefunden.");
      }
    } catch (e) {
      print("Fehler beim Hinzufügen des Freundes: $e");
      throw e;
    }
  }

  Future<List<UserModel>> getFriends(String userId) async {
    try {
      DocumentSnapshot currentUserDoc =
          await _db.collection('users').doc(userId).get();

      if (currentUserDoc.exists) {
        List<String> friendsIds =
            List<String>.from(currentUserDoc.get('friends'));
        List<UserModel> friends = [];

        for (String friendId in friendsIds) {
          DocumentSnapshot friendDoc =
              await _db.collection('users').doc(friendId).get();
          if (friendDoc.exists) {
            friends.add(
                UserModel.fromMap(friendDoc.data() as Map<String, dynamic>));
          }
        }

        return friends;
      } else {
        print("Benutzer nicht gefunden.");
        return [];
      }
    } catch (e) {
      print("Fehler beim Abrufen der Freunde: $e");
      return [];
    }
  }
}
