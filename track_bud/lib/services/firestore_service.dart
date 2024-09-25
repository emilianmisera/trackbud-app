import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:track_bud/models/friend_split_model.dart';
import 'package:track_bud/models/group_model.dart';
import 'package:track_bud/models/group_split_model.dart';
import 'package:track_bud/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUserIfNotExists(UserModel user) async {
    try {
      DocumentSnapshot userDoc =
          await _db.collection('users').doc(user.userId).get();

      if (!userDoc.exists) {
        await addUser(user);
        debugPrint("Neuer Benutzer hinzugefügt: ${user.userId}");
      } else {
        debugPrint("Benutzer existiert bereits: ${user.userId}");
        // Optional: Aktualisieren Sie hier vorhandene Benutzerdaten, falls erforderlich
      }
    } catch (e) {
      debugPrint("Fehler beim Hinzufügen/Überprüfen des Benutzers: $e");
    }
  }

  Future<void> addUser(UserModel user) {
    return _db.collection('users').doc(user.userId).set(user.toMap());
  }

  // Fetch User
  Future<UserModel?> getUser(String userId) async {
    try {
      var snapshot = await _db.collection('users').doc(userId).get();
      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data()!;
        // Ensure userId is included in the data
        data['userId'] = snapshot.id;
        return UserModel.fromMap(data);
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching user: $e");
      return null;
    }
  }

  Future<List<UserModel>> getUsersByIds(List<String> userIds) async {
    try {
      final List<UserModel> users = [];
      for (final userId in userIds) {
        final userSnapshot = await _db.collection('users').doc(userId).get();
        if (userSnapshot.exists) {
          final userData = userSnapshot.data() as Map<String, dynamic>;
          users.add(UserModel.fromMap(userData));
        }
      }
      return users;
    } catch (e) {
      debugPrint("Error fetching users by IDs: $e");
      return [];
    }
  }

  // Methode zum Abrufen der Benutzerdaten
  Future<UserModel?> getUserData(String userId) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        debugPrint(
            'Fehler beim Abrufen der Benutzerdaten: Kein Benutzerdatensatz gefunden für userId: $userId');
        return null;
      }
    } catch (e) {
      debugPrint(
          'Fehler beim Abrufen der Benutzerdaten: $e'); // Ausgabe der Exception
      return null;
    }
  }

  Future<bool> checkUserExists(String userId) async {
    try {
      final userDoc = await _db.collection('users').doc(userId).get();
      return userDoc
          .exists; // Return true if the document exists, false otherwise
    } catch (e) {
      debugPrint("Error checking if user exists: $e");
      return false;
    }
  }

  Future<void> updateUserNameInFirestore(String userId, String newName) async {
    try {
      await _db.collection('users').doc(userId).update({'name': newName});
    } catch (e) {
      debugPrint("Fehler beim Aktualisieren des Nutzernamens in Firestore: $e");
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
      debugPrint("Fehler beim Aktualisieren des Profilbildes in Firestore: $e");
      rethrow;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _db.collection('users').doc(user.userId).update(user.toMap());
    } catch (e) {
      debugPrint("Error updating user: $e");
      rethrow;
    }
  }

  /*
  ----------------------------------- CHANGE EMAIL -----------------------------------
  */

  Future<void> updateEmailInFirestore(String userId, String newEmail) async {
    try {
      await _db.collection('users').doc(userId).update({'email': newEmail});
      debugPrint('Email successfully updated in Firestore for user $userId');
    } catch (e) {
      debugPrint('Error updating email in Firestore: $e');
      rethrow; // Rethrow the error to handle it in the calling method
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

  /*
  --------------------------- FRIENDS -----------------------------------------
  */

  // add Friend
  Future<void> addFriend(String currentUserId, String friendUserId) async {
    try {
      DocumentSnapshot currentUserDoc =
          await _db.collection('users').doc(currentUserId).get();

      if (currentUserDoc.exists) {
        UserModel currentUser =
            UserModel.fromMap(currentUserDoc.data() as Map<String, dynamic>);

        if (!currentUser.friends.contains(friendUserId)) {
          currentUser.friends.add(friendUserId);

          await _db.collection('users').doc(currentUserId).update({
            'friends': currentUser.friends,
          });

          DocumentSnapshot friendUserDoc =
              await _db.collection('users').doc(friendUserId).get();
          if (friendUserDoc.exists) {
            UserModel friendUser =
                UserModel.fromMap(friendUserDoc.data() as Map<String, dynamic>);
            if (!friendUser.friends.contains(currentUserId)) {
              friendUser.friends.add(currentUserId);
              await _db.collection('users').doc(friendUserId).update({
                'friends': friendUser.friends,
              });
            }
          }
          debugPrint("Freund erfolgreich hinzugefügt");
        } else {
          debugPrint("Freundschaft besteht bereits.");
        }
      } else {
        debugPrint("Benutzer nicht gefunden.");
      }
    } catch (e) {
      debugPrint("Fehler beim Hinzufügen des Freundes: $e");
      rethrow;
    }
  }

  Future<List<UserModel>> getFriends(String userId) async {
    try {
      DocumentSnapshot currentUserDoc =
          await _db.collection('users').doc(userId).get();

      if (currentUserDoc.exists) {
        List<String> friendsIds =
            List<String>.from(currentUserDoc.get('friends') ?? []);
        List<UserModel> friends = [];

        for (String friendId in friendsIds) {
          DocumentSnapshot friendDoc =
              await _db.collection('users').doc(friendId).get();
          if (friendDoc.exists) {
            Map<String, dynamic> friendData =
                friendDoc.data() as Map<String, dynamic>;
            friendData['userId'] =
                friendDoc.id; // Stellen Sie sicher, dass die userId gesetzt ist
            friends.add(UserModel.fromMap(friendData));
          }
        }

        debugPrint(
            "Abgerufene Freunde: ${friends.map((f) => f.userId).toList()}");
        return friends;
      } else {
        debugPrint("Benutzer nicht gefunden: $userId");
        return [];
      }
    } catch (e) {
      debugPrint("Fehler beim Abrufen der Freunde: $e");
      return [];
    }
  }

  /*
  ------------------------------ FRIEND SPLIT ------------------------------------
  */

  Future<void> addFriendSplit(FriendSplitModel split) async {
    try {
      await _db
          .collection('friend_splits')
          .doc(split.splitId)
          .set(split.toMap());
      debugPrint("Friend split added successfully: ${split.splitId}");
    } catch (e) {
      debugPrint("Error adding friend split: $e");
      rethrow;
    }
  }

  // Get Friend Splits for a User
  Future<List<FriendSplitModel>> getFriendSplits(
      String userId, String friendId) async {
    try {
      QuerySnapshot splitSnapshot = await _db
          .collection('friend_splits')
          .where('creditorId', isEqualTo: userId)
          .where('debtorId', isEqualTo: friendId)
          .get();

      QuerySnapshot reverseSplitSnapshot = await _db
          .collection('friend_splits')
          .where('creditorId', isEqualTo: friendId)
          .where('debtorId', isEqualTo: userId)
          .get();

      List<FriendSplitModel> splits = splitSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['splitId'] = doc.id;
        return FriendSplitModel.fromMap(data);
      }).toList();

      splits.addAll(reverseSplitSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['splitId'] = doc.id;
        return FriendSplitModel.fromMap(data);
      }));

      splits.sort((a, b) => b.date.compareTo(a.date));

      return splits;
    } catch (e) {
      debugPrint("Error fetching friend splits: $e");
      return [];
    }
  }

  Future<void> payOffFriendSplits(String currentUserId, String friendId) async {
    try {
      QuerySnapshot splitSnapshot = await _db
          .collection('friend_splits')
          .where('creditorId', isEqualTo: currentUserId)
          .where('debtorId', isEqualTo: friendId)
          .where('status', isEqualTo: 'pending')
          .get();

      QuerySnapshot reverseSplitSnapshot = await _db
          .collection('friend_splits')
          .where('creditorId', isEqualTo: friendId)
          .where('debtorId', isEqualTo: currentUserId)
          .where('status', isEqualTo: 'pending')
          .get();

      List<String> splitIdsToUpdate = [];

      for (var doc in splitSnapshot.docs) {
        splitIdsToUpdate.add(doc.id);
      }
      for (var doc in reverseSplitSnapshot.docs) {
        splitIdsToUpdate.add(doc.id);
      }

      for (var splitId in splitIdsToUpdate) {
        await _db
            .collection('friend_splits')
            .doc(splitId)
            .update({'status': 'paid'});
      }

      debugPrint(
          "All pending splits between $currentUserId and $friendId have been marked as paid.");
    } catch (e) {
      debugPrint("Error paying off friend splits: $e");
      rethrow;
    }
  }

  /*
  ------------------------------- GROUPS ---------------------------------------
  */

  Future<void> createGroup(GroupModel group) async {
    try {
      // Überprüfen Sie, ob alle Mitglieder-IDs gültig sind
      for (String memberId in group.members) {
        DocumentSnapshot memberDoc =
            await _db.collection('users').doc(memberId).get();
        if (!memberDoc.exists) {
          debugPrint(
              "Warnung: Mitglied $memberId existiert nicht in der Datenbank.");
        }
      }

      await _db.collection('groups').doc(group.groupId).set(group.toMap());
      debugPrint("Gruppe erfolgreich erstellt: ${group.groupId}");
      debugPrint("Gruppenmitglieder: ${group.members}");
    } catch (e) {
      debugPrint("Fehler beim Erstellen der Gruppe: $e");
      rethrow;
    }
  }

  Future<List<GroupModel>> getUserGroups(String userId) async {
    try {
      QuerySnapshot groupsSnapshot = await _db
          .collection('groups')
          .where('members', arrayContains: userId)
          .get();

      if (groupsSnapshot.docs.isEmpty) {
        debugPrint("No groups found for userId: $userId");
      }

      return groupsSnapshot.docs
          .map((doc) => GroupModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint("Error fetching groups for userId $userId: $e");
      return [];
    }
  }

  Future<void> addMemberToGroup(String groupId, String userId) async {
    try {
      await _db.collection('groups').doc(groupId).update({
        'members': FieldValue.arrayUnion([userId])
      });
      debugPrint("Mitglied erfolgreich zur Gruppe hinzugefügt");
    } catch (e) {
      debugPrint("Fehler beim Hinzufügen des Mitglieds zur Gruppe: $e");
      rethrow;
    }
  }

  /*
------------------------------------------- GROUP SPLITS --------------------------------------------
  */

  Future<void> saveGroupSplit(GroupSplitModel groupSplit) async {
    try {
      await _db
          .collection('group_splits')
          .doc(groupSplit.groupSplitId)
          .set(groupSplit.toMap());
      debugPrint("Group split added successfully: ${groupSplit.groupSplitId}");
    } catch (e) {
      debugPrint("Error adding group split: $e");
      rethrow;
    }
  }
}
