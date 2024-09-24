import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/services/firestore_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _currentUser;
  List<UserModel> _friends = [];
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  List<UserModel> get friends => _friends;
  bool get isLoading => _isLoading;
  double get monthlyBudgetGoal => _currentUser?.monthlySpendingGoal ?? 0.0;

  Future<void> loadCurrentUser() async {
    _isLoading = true;
    notifyListeners();
    try {
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        _currentUser = await _firestoreService.getUser(firebaseUser.uid);
        await loadFriends();
      }
    } catch (e) {
      debugPrint("Error loading current user: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFriends() async {
    if (_currentUser == null) return;
    try {
      _friends = await _firestoreService.getFriends(_currentUser!.userId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading friends: $e");
    }
  }

  Future<void> addFriend(String friendUserId) async {
    if (_currentUser == null) return;
    try {
      await _firestoreService.addFriend(_currentUser!.userId, friendUserId);
      await loadFriends(); // Reload friends list after adding a new friend
    } catch (e) {
      debugPrint("Error adding friend: $e");
    }
  }

  void updateCurrentUser(UserModel updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }

  Future<void> setMonthlyBudgetGoal(double goal) async {
    if (_currentUser != null) {
      _currentUser!.monthlySpendingGoal = goal;
      await _firestoreService.updateUser(_currentUser!);
      notifyListeners();
    }
  }
}