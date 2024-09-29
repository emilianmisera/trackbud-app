import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:track_bud/models/friend_split_model.dart';
import 'package:track_bud/models/group_model.dart';
import 'package:track_bud/models/group_split_model.dart';
import 'package:track_bud/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Adds a new user to the database if they do not already exist
  Future<void> addUserIfNotExists(UserModel user) async {
    try {
      DocumentSnapshot userDoc = await _db.collection('users').doc(user.userId).get();

      // Check if the user already exists in the database
      if (!userDoc.exists) {
        await addUser(user);
        debugPrint("New user added: ${user.userId}");
      } else {
        debugPrint("User already exists: ${user.userId}");
        // Optional: Update existing user data if necessary
      }
    } catch (e) {
      debugPrint("Error adding/checking user: $e");
    }
  }

// Add a user to the database
  Future<void> addUser(UserModel user) {
    return _db.collection('users').doc(user.userId).set(user.toMap());
  }

// Fetch a user from the database by their user ID
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

// Get the current signed-in user's ID
  Future<String> getCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception('No user signed in');
    }
  }

// Retrieve user data for a specific user ID
  Future<UserModel?> getUserData(String userId) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        debugPrint('Error retrieving user data: No user record found for userId: $userId');
        return null;
      }
    } catch (e) {
      debugPrint('Error retrieving user data: $e'); // Output the exception
      return null;
    }
  }

// Check if a user exists in the database by user ID
  Future<bool> checkUserExists(String userId) async {
    try {
      final userDoc = await _db.collection('users').doc(userId).get();
      return userDoc.exists; // Return true if the document exists, false otherwise
    } catch (e) {
      debugPrint("Error checking if user exists: $e");
      return false;
    }
  }

// Update a user's name in the Firestore database
  Future<void> updateUserNameInFirestore(String userId, String newName) async {
    try {
      await _db.collection('users').doc(userId).update({'name': newName});
    } catch (e) {
      debugPrint("Error updating username in Firestore: $e");
    }
  }

// Update a user's profile image in the Firestore database
  Future<void> updateUserProfileImageInFirestore(String userId, String imageUrl) async {
    try {
      await _db.collection('users').doc(userId).update({'profilePictureUrl': imageUrl});
    } catch (e) {
      debugPrint("Error updating profile picture in Firestore: $e");
      rethrow;
    }
  }

// Update user data in the Firestore database
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

  // Add a friend to the current user's friend list
  Future<void> addFriend(String currentUserId, String friendUserId) async {
    try {
      DocumentSnapshot currentUserDoc = await _db.collection('users').doc(currentUserId).get();

      if (currentUserDoc.exists) {
        UserModel currentUser = UserModel.fromMap(currentUserDoc.data() as Map<String, dynamic>);

        // Check if the friend is not already in the current user's friend list
        if (!currentUser.friends.contains(friendUserId)) {
          currentUser.friends.add(friendUserId);

          // Update the current user's friends list in the database
          await _db.collection('users').doc(currentUserId).update({
            'friends': currentUser.friends,
          });

          // Check if the friend user exists
          DocumentSnapshot friendUserDoc = await _db.collection('users').doc(friendUserId).get();
          if (friendUserDoc.exists) {
            UserModel friendUser = UserModel.fromMap(friendUserDoc.data() as Map<String, dynamic>);
            // Add the current user to the friend's friends list if not already present
            if (!friendUser.friends.contains(currentUserId)) {
              friendUser.friends.add(currentUserId);
              await _db.collection('users').doc(friendUserId).update({
                'friends': friendUser.friends,
              });
            }
          }
          debugPrint("Friend successfully added");
        } else {
          debugPrint("Friendship already exists.");
        }
      } else {
        debugPrint("User not found.");
      }
    } catch (e) {
      debugPrint("Error adding friend: $e");
      rethrow;
    }
  }

// Retrieve the list of friends for a given user
  Future<List<UserModel>> getFriends(String userId) async {
    try {
      DocumentSnapshot currentUserDoc = await _db.collection('users').doc(userId).get();

      if (currentUserDoc.exists) {
        // Get the list of friend IDs
        List<String> friendsIds = List<String>.from(currentUserDoc.get('friends') ?? []);
        List<UserModel> friends = [];

        // Fetch each friend's details
        for (String friendId in friendsIds) {
          DocumentSnapshot friendDoc = await _db.collection('users').doc(friendId).get();
          if (friendDoc.exists) {
            Map<String, dynamic> friendData = friendDoc.data() as Map<String, dynamic>;
            friendData['userId'] = friendDoc.id; // Ensure the userId is included
            friends.add(UserModel.fromMap(friendData));
          }
        }

        debugPrint("Retrieved friends: ${friends.map((f) => f.userId).toList()}");
        return friends;
      } else {
        debugPrint("User not found: $userId");
        return [];
      }
    } catch (e) {
      debugPrint("Error fetching friends: $e");
      return [];
    }
  }

/*
------------------------------ FRIEND SPLIT ------------------------------------
*/

// Add a new friend split record to the database
  Future<void> addFriendSplit(FriendSplitModel split) async {
    try {
      await _db.collection('friend_splits').doc(split.splitId).set(split.toMap());
      debugPrint("Friend split added successfully: ${split.splitId}");
    } catch (e) {
      debugPrint("Error adding friend split: $e");
      rethrow;
    }
  }

// Get friend splits for a specific user and their friend
  Future<List<FriendSplitModel>> getFriendSplits(String userId, String friendId) async {
    try {
      // Fetch splits where the user is the creditor
      QuerySnapshot splitSnapshot =
          await _db.collection('friend_splits').where('creditorId', isEqualTo: userId).where('debtorId', isEqualTo: friendId).get();

      // Fetch splits where the friend is the creditor
      QuerySnapshot reverseSplitSnapshot =
          await _db.collection('friend_splits').where('creditorId', isEqualTo: friendId).where('debtorId', isEqualTo: userId).get();

      // Convert query results to a list of FriendSplitModel
      List<FriendSplitModel> splits = splitSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['splitId'] = doc.id;
        return FriendSplitModel.fromMap(data);
      }).toList();

      // Add reverse splits to the list
      splits.addAll(reverseSplitSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['splitId'] = doc.id;
        return FriendSplitModel.fromMap(data);
      }));

      // Sort splits by date in descending order
      splits.sort((a, b) => b.date.compareTo(a.date));

      return splits;
    } catch (e) {
      debugPrint("Error fetching friend splits: $e");
      return [];
    }
  }

// Mark all pending splits between the current user and their friend as paid
  Future<void> payOffFriendSplits(String currentUserId, String friendId) async {
    try {
      // Fetch pending splits where the current user is the creditor
      QuerySnapshot splitSnapshot = await _db
          .collection('friend_splits')
          .where('creditorId', isEqualTo: currentUserId)
          .where('debtorId', isEqualTo: friendId)
          .where('status', isEqualTo: 'pending')
          .get();

      // Fetch pending splits where the friend is the creditor
      QuerySnapshot reverseSplitSnapshot = await _db
          .collection('friend_splits')
          .where('creditorId', isEqualTo: friendId)
          .where('debtorId', isEqualTo: currentUserId)
          .where('status', isEqualTo: 'pending')
          .get();

      List<String> splitIdsToUpdate = [];

      // Collect the IDs of all pending splits
      for (var doc in splitSnapshot.docs) {
        splitIdsToUpdate.add(doc.id);
      }
      for (var doc in reverseSplitSnapshot.docs) {
        splitIdsToUpdate.add(doc.id);
      }

      // Update the status of all pending splits to 'paid'
      for (var splitId in splitIdsToUpdate) {
        await _db.collection('friend_splits').doc(splitId).update({'status': 'paid'});
      }

      debugPrint("All pending splits between $currentUserId and $friendId have been marked as paid.");
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
      // Validate all member IDs to ensure they exist in the database
      for (String memberId in group.members) {
        DocumentSnapshot memberDoc = await _db.collection('users').doc(memberId).get();
        if (!memberDoc.exists) {
          debugPrint("Warning: Member $memberId does not exist in the database.");
        }
      }

      // Create the group in the database
      await _db.collection('groups').doc(group.groupId).set(group.toMap());
      debugPrint("Group successfully created: ${group.groupId}");
      debugPrint("Group members: ${group.members}");
    } catch (e) {
      debugPrint("Error creating group: $e");
      rethrow;
    }
  }

  Future<List<GroupModel>> getUserGroups(String userId) async {
    try {
      // Fetch groups that contain the user as a member
      QuerySnapshot groupsSnapshot = await _db.collection('groups').where('members', arrayContains: userId).get();

      if (groupsSnapshot.docs.isEmpty) {
        debugPrint("No groups found for userId: $userId");
      }

      // Convert query results to a list of GroupModel
      return groupsSnapshot.docs.map((doc) => GroupModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint("Error fetching groups for userId $userId: $e");
      return [];
    }
  }

  Future<GroupModel> getGroup(String groupId) async {
    try {
      debugPrint('Fetching group with groupId: $groupId');
      DocumentSnapshot groupSnapshot = await _db.collection('groups').doc(groupId).get();

      if (groupSnapshot.exists) {
        debugPrint('Group found: ${groupSnapshot.data()}');
        // Convert the document data to GroupModel
        return GroupModel.fromMap(groupSnapshot.data() as Map<String, dynamic>);
      } else {
        debugPrint('Group not found.');
        throw Exception('Group not found.'); // Handle group not found scenario
      }
    } catch (e) {
      debugPrint('Error fetching group: $e');
      rethrow;
    }
  }

  Future<void> addMemberToGroup(String groupId, String userId) async {
    try {
      // Add the user to the group's member list
      await _db.collection('groups').doc(groupId).update({
        'members': FieldValue.arrayUnion([userId])
      });
      debugPrint("Member successfully added to the group");
    } catch (e) {
      debugPrint("Error adding member to group: $e");
      rethrow;
    }
  }

/*
------------------------------------------- GROUP SPLITS --------------------------------------------
*/

  Future<void> addGroupSplit(GroupSplitModel groupSplit) async {
    try {
      // Add a new group split to the database
      await _db.collection('group_splits').doc(groupSplit.groupSplitId).set(groupSplit.toMap());
      debugPrint("Group split added successfully: ${groupSplit.groupSplitId}");
    } catch (e) {
      debugPrint("Error adding group split: $e");
      rethrow;
    }
  }

  Future<List<GroupSplitModel>> getGroupSplits(String groupId) async {
    try {
      // Retrieve all group splits associated with the specified groupId
      QuerySnapshot splitSnapshot = await _db.collection('group_splits').where('groupId', isEqualTo: groupId).get();

      // Convert query results to a list of GroupSplitModel
      List<GroupSplitModel> splits = splitSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['groupSplitId'] = doc.id; // Add document ID to the data
        return GroupSplitModel.fromMap(data);
      }).toList();

      return splits;
    } catch (e) {
      debugPrint("Error fetching group splits: $e");
      return [];
    }
  }

// Stream for fetching group splits based on groupId
  Stream<QuerySnapshot<GroupSplitModel>> getGroupSplitsStream(String groupId) {
    return _db
        .collection('group_splits')
        .where('groupId', isEqualTo: groupId)
        .orderBy('date', descending: true)
        .withConverter<GroupSplitModel>(
          fromFirestore: (snapshot, _) => GroupSplitModel.fromMap(snapshot.data()!),
          toFirestore: (groupSplit, _) => groupSplit.toMap(),
        )
        .snapshots();
  }
}
