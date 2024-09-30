import 'package:flutter/material.dart';
import 'package:track_bud/models/friend_split_model.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/services/firestore_service.dart';

class FriendSplitProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final Map<String, List<FriendSplitModel>> _friendSplits = {};
  final Map<String, double> _friendBalances = {};
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Loads the splits for each friend and calculates their balances.
  Future<void> loadFriendSplits(String currentUserId, List<UserModel> friends) async {
    _setLoadingState(true);
    try {
      for (var friend in friends) {
        final splits = await _firestoreService.getFriendSplits(currentUserId, friend.userId);
        _friendSplits[friend.userId] = splits;
        _calculateFriendBalance(currentUserId, friend.userId);
      }
    } catch (e) {
      debugPrint("Error loading friend splits: $e");
    } finally {
      _setLoadingState(false);
    }
  }

  // Sets the loading state and notifies listeners.
  void _setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  // Calculates the balance for a given friend based on their splits.
  void _calculateFriendBalance(String currentUserId, String friendId) {
    double balance = 0;

    for (var split in _friendSplits[friendId] ?? []) {
      if (split.status == 'pending') {
        balance += (split.creditorId == currentUserId) ? split.debtorAmount : -split.debtorAmount;
      }
    }

    _friendBalances[friendId] = balance;
    notifyListeners();
  }

  // Gets the balance of a specified friend.
  double getFriendBalance(String friendId) {
    return _friendBalances[friendId] ?? 0.0;
  }

  // Calculates the total debts across all friends.
  double getTotalFriendDebts() {
    return _friendBalances.values.where((balance) => balance < 0).fold(0, (sum, balance) => sum + balance.abs());
  }

  // Calculates the total credits across all friends.
  double getTotalFriendCredits() {
    return _friendBalances.values.where((balance) => balance > 0).fold(0, (sum, balance) => sum + balance);
  }
}
