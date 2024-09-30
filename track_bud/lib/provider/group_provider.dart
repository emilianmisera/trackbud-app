import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:track_bud/models/group_model.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/utils/enum/categories.dart';

class GroupProvider with ChangeNotifier {
  final List<GroupModel> _groups = [];
  bool _isLoading = false;

  final Map<String, double> _groupExpenses = {};
  final Map<String, double> _userCredits = {};
  final Map<String, double> _currentUserExpenses = {};
  final Map<String, double> _netBalances = {};
  final FirestoreService _firestoreService = FirestoreService();
  final Map<String, Future<List<Map<String, dynamic>>>> _debtsOverviewCache = {};
  final Map<String, Map<Categories, double>> _groupCategoryAmounts = {};
  Map<Categories, double> getCategoryAmounts(String groupId) => _groupCategoryAmounts[groupId] ?? {};

  // Exposes the list of groups
  List<GroupModel> get groups => _groups;

  // Indicates whether data is currently loading
  bool get isLoading => _isLoading;

  // Retrieves total expenses and user credits for specified group IDs
  double getGroupExpense(String groupId) => _groupExpenses[groupId] ?? 0.0;
  double getUserCredit(String groupId) => _userCredits[groupId] ?? 0.0;
  double getCurrentUserExpenses(String groupId) => _currentUserExpenses[groupId] ?? 0.0;

  // Retrieves the net balance for a user in a specified group
  double getNetBalance(String groupId, String userId) => _netBalances[userId] ?? 0.0;

  // Loads all groups for the current user
  Future<void> loadGroups() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        debugPrint("Loading groups for user ID: ${user.uid}");
        final groups = await _firestoreService.getUserGroups(user.uid);
        debugPrint("Retrieved ${groups.length} groups for the user.");

        _groups
          ..clear()
          ..addAll(groups);

        await _calculateAllGroupData();
      } else {
        debugPrint("No user found, clearing groups.");
        _groups.clear();
      }
    } catch (e) {
      debugPrint("Error loading groups: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retrieves shared groups with a specific friend
  Future<List<GroupModel>> getSharedGroups(String friendId) async {
    String currentUserId = await _firestoreService.getCurrentUserId();
    List<GroupModel> sharedGroups = [];

    // Get groups for the current user
    List<GroupModel> userGroups = await _firestoreService.getUserGroups(currentUserId);

    // Get groups for the friend
    List<GroupModel> friendGroups = await _firestoreService.getUserGroups(friendId);

    // Find common groups
    for (var userGroup in userGroups) {
      if (friendGroups.any((friendGroup) => friendGroup.groupId == userGroup.groupId)) {
        sharedGroups.add(userGroup);
      }
    }

    return sharedGroups;
  }

  // Calculates data for all groups
  Future<void> _calculateAllGroupData() async {
    await Future.wait(_groups.map((group) => _calculateGroupData(group.groupId)));
  }

  // Calculates expenses and credits for a specified group
  Future<void> _calculateGroupData(String groupId) async {
    String currentUserId = await _firestoreService.getCurrentUserId();
    var splits = await _firestoreService.getGroupSplits(groupId);

    double totalGroupExpense = 0;
    double currentUserCredit = 0;
    double currentUserExpenses = 0;

    for (var split in splits) {
      totalGroupExpense += split.totalAmount;

      var currentUserShare = split.splitShares.firstWhere(
        (share) => share['userId'] == currentUserId,
        orElse: () => {'amount': 0.0},
      );

      if (split.paidBy == currentUserId) {
        currentUserExpenses += split.totalAmount;
        currentUserCredit += split.totalAmount - currentUserShare['amount'];
      } else {
        currentUserCredit -= currentUserShare['amount'] as double;
      }
    }

    // Update internal state with calculated data
    _groupExpenses[groupId] = totalGroupExpense;
    _userCredits[groupId] = currentUserCredit;
    _currentUserExpenses[groupId] = currentUserExpenses;

    notifyListeners();
  }

  // Calculates the amount for every category
  Future<void> calculateGroupCategoryAmounts(String groupId) async {
    var splits = await _firestoreService.getGroupSplits(groupId);
    Map<Categories, double> categoryAmounts = {};

    for (var split in splits) {
      Categories category = Categories.values.firstWhere(
        (c) => c.categoryName == split.category,
        orElse: () => Categories.sonstiges,
      );
      categoryAmounts[category] = (categoryAmounts[category] ?? 0) + split.totalAmount;
    }

    _groupCategoryAmounts[groupId] = categoryAmounts;
    notifyListeners();
  }

  // Refreshes data for a specific group
  Future<void> refreshGroupData(String groupId) async {
    await _calculateGroupData(groupId);
    await calculateGroupCategoryAmounts(groupId);
    notifyListeners();
  }

  // Retrieves group member information by their ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      return await _firestoreService.getUser(userId);
    } catch (e) {
      debugPrint("Error fetching user by ID: $e");
      return null;
    }
  }

  // Retrieves the debts overview for a specified group
  Future<List<Map<String, dynamic>>> getGroupDebtsOverview(String groupId) async {
    if (!_debtsOverviewCache.containsKey(groupId)) {
      _debtsOverviewCache[groupId] = _fetchGroupDebtsOverview(groupId);
    }
    return _debtsOverviewCache[groupId]!;
  }

  // Fetches detailed debts overview for a specified group
  Future<List<Map<String, dynamic>>> _fetchGroupDebtsOverview(String groupId) async {
    await calculateNetBalances(groupId);
    List<Map<String, dynamic>> payments = suggestPayments(groupId);

    // Only proceed if there are payments to be made
    if (payments.isNotEmpty) {
      return await Future.wait(payments.map((payment) async {
        UserModel? fromUser = await getUserById(payment['from']);
        UserModel? toUser = await getUserById(payment['to']);
        return {
          ...payment,
          'fromName': fromUser?.name ?? 'Unknown',
          'toName': toUser?.name ?? 'Unknown',
        };
      }));
    } else {
      return [];
    }
  }

  // Calculate total debts for the current user across all groups
  double getTotalDebts() {
    return _userCredits.values.where((credit) => credit < 0).map((credit) => -credit).fold(0.0, (summe, item) => summe + item);
  }

  // Calculate total credits for the current user across all groups
  double getTotalCredits() {
    return _userCredits.values.where((credit) => credit > 0).fold(0.0, (summe, credit) => summe + credit);
  }

  // Invalidates the cache for the debts overview of a specified group
  void invalidateDebtsOverviewCache(String groupId) {
    _debtsOverviewCache.remove(groupId);
    notifyListeners();
  }

  // Calculates net balances for all members in a specified group
  Future<void> calculateNetBalances(String groupId) async {
    var splits = await _firestoreService.getGroupSplits(groupId);
    String currentUserId = await _firestoreService.getCurrentUserId();

    // Reset net balances for this group
    _netBalances.clear();

    for (var split in splits) {
      double totalAmount = split.totalAmount;

      // Credit the payer
      _netBalances[split.paidBy] = (_netBalances[split.paidBy] ?? 0.0) + totalAmount;

      // Debit each participant based on their shares
      for (var share in split.splitShares) {
        String userId = share['userId'] as String;
        double amount = share['amount'] as double;
        _netBalances[userId] = (_netBalances[userId] ?? 0.0) - amount;
      }
    }

    // Update user credits for this group
    _userCredits[groupId] = _netBalances[currentUserId] ?? 0.0;
    notifyListeners();
  }

  // Suggests payments to settle all debts within a specified group (help from ChatGPT)
  List<Map<String, dynamic>> suggestPayments(String groupId) {
    List<Map<String, dynamic>> suggestedPayments = [];

    List<MapEntry<String, double>> creditors = _netBalances.entries.where((e) => e.value > 0).toList();
    List<MapEntry<String, double>> debtors = _netBalances.entries.where((e) => e.value < 0).toList();

    creditors.sort((a, b) => b.value.compareTo(a.value)); // Sort creditors in descending order
    debtors.sort((a, b) => a.value.compareTo(b.value)); // Sort debtors in ascending order

    while (creditors.isNotEmpty && debtors.isNotEmpty) {
      var creditor = creditors.first;
      var debtor = debtors.first;

      double amountToSettle = min(creditor.value, -debtor.value);

      suggestedPayments.add({
        'from': debtor.key,
        'to': creditor.key,
        'amount': amountToSettle,
      });

      // Update balances after payment suggestion
      creditor = MapEntry(creditor.key, creditor.value - amountToSettle);
      debtor = MapEntry(debtor.key, debtor.value + amountToSettle);

      if (creditor.value <= 0) {
        creditors.removeAt(0); // Remove creditor if fully paid
      } else {
        creditors[0] = creditor; // Update creditor's balance
      }

      if (debtor.value >= 0) {
        debtors.removeAt(0); // Remove debtor if fully settled
      } else {
        debtors[0] = debtor; // Update debtor's balance
      }
    }

    return suggestedPayments;
  }

  // Creates a new group and uploads an optional image to Firebase Storage
  Future<void> createGroup(GroupModel group, File? imageFile) async {
    try {
      // Create the group in Firestore
      await _firestoreService.createGroup(group);

      // If an image file is provided, upload it to Firebase Storage and retrieve the URL
      if (imageFile != null) {
        String? imageUrl = await uploadGroupImage(imageFile, group.groupId);

        // If the image was uploaded successfully, update the group document with the image URL
        if (imageUrl != null) {
          await FirebaseFirestore.instance.collection('groups').doc(group.groupId).update({'profilePictureUrl': imageUrl});
        }
      }

      // Add the newly created group to the local list and notify listeners
      _groups.add(group);
      notifyListeners();
    } catch (e) {
      debugPrint("Error creating group: $e");
      rethrow; // Re-throw error for further handling if necessary
    }
  }

  // Uploads a group image to Firebase Storage and returns the download URL
  Future<String?> uploadGroupImage(File imageFile, String groupId) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('group_images').child('$groupId.jpg');

      // Upload the image file to Firebase Storage
      await storageRef.putFile(imageFile);

      // Retrieve and return the download URL of the uploaded image
      return await storageRef.getDownloadURL();
    } catch (e) {
      debugPrint("Error uploading image: $e");
      return null; // Return null if the upload fails
    }
  }
}
