import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/services/firestore_service.dart';

// Provider class to manage user data and interactions with Firestore.
class UserProvider extends ChangeNotifier {
  UserModel? _currentUser; // Holds the current user data.
  List<UserModel> _friends = []; // List of the user's friends.
  final FirestoreService _firestoreService =
      FirestoreService(); // Service for Firestore interactions.
  bool _isLoading = false; // Flag to indicate loading state.

  // Getter for the current user.
  UserModel? get currentUser => _currentUser;

  // Getter for the list of friends.
  List<UserModel> get friends => _friends;

  // Getter for loading state.
  bool get isLoading => _isLoading;

  // Getter for the monthly budget goal of the current user.
  double get monthlyBudgetGoal => _currentUser?.monthlySpendingGoal ?? 0.0;

  // Loads the current user's data from Firestore.
  Future<void> loadCurrentUser() async {
    _isLoading = true; // Set loading state to true.
    notifyListeners(); // Notify listeners to update UI.

    try {
      User? firebaseUser =
          FirebaseAuth.instance.currentUser; // Get the current Firebase user.
      if (firebaseUser != null) {
        // If a user is logged in, fetch their user model.
        _currentUser = await _firestoreService.getUser(firebaseUser.uid);
        await loadFriends(); // Load friends for the current user.
      }
    } catch (e) {
      debugPrint(
          "Error loading current user: $e"); // Log any errors encountered.
    } finally {
      _isLoading = false; // Reset loading state.
      notifyListeners(); // Notify listeners to update UI.
    }
  }

  // Loads the current user's friends from Firestore.
  Future<void> loadFriends() async {
    if (_currentUser == null) return; // Return if no current user is loaded.

    try {
      // Fetch friends of the current user from Firestore.
      _friends = await _firestoreService.getFriends(_currentUser!.userId);
      notifyListeners(); // Notify listeners to update UI with new friends list.
    } catch (e) {
      debugPrint("Error loading friends: $e"); // Log any errors encountered.
    }
  }

  // Adds a friend by their user ID.
  Future<void> addFriend(String friendUserId) async {
    if (_currentUser == null) return; // Return if no current user is loaded.

    try {
      // Call the Firestore service to add a friend.
      await _firestoreService.addFriend(_currentUser!.userId, friendUserId);
      await loadFriends(); // Reload friends list after adding a new friend.
    } catch (e) {
      debugPrint("Error adding friend: $e"); // Log any errors encountered.
    }
  }

  // Updates the current user's information with the provided updated user model.
  void updateCurrentUser(UserModel updatedUser) {
    _currentUser = updatedUser; // Update the current user data.
    notifyListeners(); // Notify listeners to update UI.
  }

  // Sets a new monthly budget goal for the current user and updates Firestore.
  Future<void> setMonthlyBudgetGoal(double goal) async {
    if (_currentUser != null) {
      _currentUser!.monthlySpendingGoal = goal; // Update the spending goal.
      await _firestoreService
          .updateUser(_currentUser!); // Update the user data in Firestore.
      notifyListeners(); // Notify listeners to update UI.
    }
  }
}
