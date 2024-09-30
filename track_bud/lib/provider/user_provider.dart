import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/services/firestore_service.dart';

// Provider class to manage user data and interactions with Firestore.
class UserProvider extends ChangeNotifier {
  UserModel? _currentUser; // Holds the current user data.
  List<UserModel> _friends = []; // List of the user's friends.
  final FirestoreService _firestoreService = FirestoreService(); // Service for Firestore interactions.
  final FirebaseFirestore _db = FirebaseFirestore.instance; // Firestore instance.
  bool _isLoading = false; // Flag to indicate loading state.

  // Getter for the current user data.
  UserModel? get currentUser => _currentUser;

  // Getter for the list of user's friends.
  List<UserModel> get friends => _friends;

  // Getter for loading state.
  bool get isLoading => _isLoading;

  // Getter for the current user's monthly spending goal.
  double get monthlyBudgetGoal => _currentUser?.monthlySpendingGoal ?? 0.0;

  // Loads the current user's data from Firestore.
  Future<void> loadCurrentUser() async {
    _isLoading = true; // Indicate that data is loading.
    notifyListeners(); // Notify UI to reflect the loading state.

    try {
      User? firebaseUser = FirebaseAuth.instance.currentUser; // Get the current authenticated Firebase user.
      if (firebaseUser != null) {
        // If a user is logged in, fetch their user data from Firestore.
        _currentUser = await _firestoreService.getUser(firebaseUser.uid);
        await loadFriends(); // Load the user's friends after fetching user data.
      }
    } catch (e) {
      debugPrint("Error loading current user: $e"); // Log any errors encountered.
    } finally {
      _isLoading = false; // Reset the loading state.
      notifyListeners(); // Notify UI to stop showing loading indicators.
    }
  }

  // Loads the current user's friends from Firestore.
  Future<void> loadFriends() async {
    if (_currentUser == null) return; // Exit early if no current user is loaded.

    try {
      // Fetch the user's friends from Firestore based on their user ID.
      _friends = await _firestoreService.getFriends(_currentUser!.userId);
      debugPrint("Friends loaded: $_friends"); // Debugging log to display loaded friends.
      
      // Debugging logs for each friend's details.
      for (var friend in _friends) {
        debugPrint("Friend loaded: ${friend.name}, ${friend.email}, ${friend.userId}");
      }
      notifyListeners(); // Notify UI to update the friends list.
    } catch (e) {
      debugPrint("Error loading friends: $e"); // Log any errors encountered.
    }
  }

  // Adds a friend by their user ID.
  Future<void> addFriend(String friendUserId) async {
    if (_currentUser == null) return; // Exit early if no current user is loaded.

    try {
      // Use Firestore service to add a friend.
      await _firestoreService.addFriend(_currentUser!.userId, friendUserId);
      await loadFriends(); // Reload the friends list after adding a new friend.
    } catch (e) {
      debugPrint("Error adding friend: $e"); // Log any errors encountered.
    }
  }

  // Updates the current user's information with a new user model.
  void updateCurrentUser(UserModel updatedUser) {
    _currentUser = updatedUser; // Set the new user data.
    notifyListeners(); // Notify UI to update with new user data.
  }

  // Updates the current user's monthly budget goal in Firestore.
  Future<void> updateMonthlyBudgetGoal(double goal) async {
    if (_currentUser != null) {
      _currentUser!.monthlySpendingGoal = goal; // Update the spending goal locally.
      await _firestoreService.updateUser(_currentUser!); // Update the user data in Firestore.
      notifyListeners(); // Notify UI to reflect the updated goal.
    }
  }

  // Updates the current user's bank account balance in Firestore.
  Future<void> updateBankAccountBalance(double balance) async {
    if (_currentUser != null) {
      _currentUser!.bankAccountBalance = balance; // Update the balance locally.
      await _firestoreService.updateUser(_currentUser!); // Update the user data in Firestore.
      notifyListeners(); // Notify UI to reflect the updated balance.
    }
  }
  
  // Sets the user's bank account balance in Firestore by their user ID.
  Future<void> setBankAccountBalance(String userId, double amount) async {
    try {
      // Update the user's bank account balance in Firestore.
      await _db.collection('users').doc(userId).update({
        'bankAccountBalance': amount,
      });
    } catch (e) {
      throw Exception("Error updating bank account balance: $e"); // Throw an exception in case of an error.
    }
  }

  // Sets the user's monthly spending goal in Firestore by their user ID.
  Future<void> setBudgetGoal(String userId, double amount) async {
    try {
      // Update the user's monthly budget goal in Firestore.
      await _db.collection('users').doc(userId).update({
        'monthlySpendingGoal': amount,
      });
    } catch (e) {
      throw Exception("Error updating budget goal: $e"); // Throw an exception in case of an error.
    }
  }
}