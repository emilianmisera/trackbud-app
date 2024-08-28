import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/information_tiles.dart';
import 'package:track_bud/views/subpages/edit_transaction_screen.dart';

// A StatefulWidget that displays a list of transactions, with options to filter, edit, and delete.
class TransactionList extends StatefulWidget {
  // Callback function to notify the parent widget when transactions change
  final VoidCallback onTransactionChangeCallback;
  // The selected type of transactions to display ('income' or 'expense')
  final String? selectedOption;
  // The selected category to filter transactions by (optional)
  final String? selectedCategory;

  // Constructor with optional category and required callback and type
  const TransactionList({
    super.key,
    required this.onTransactionChangeCallback,
    required this.selectedOption,
    this.selectedCategory,
  });

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  // List to store all fetched transactions
  List<DocumentSnapshot> _allTransactions = [];
  // List to store filtered transactions based on selected category
  List<DocumentSnapshot> _filteredTransactions = [];
  // Loading state indicator
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Load transactions when the widget is first created
    _loadTransactions();
  }

  /// Deletes a transaction by its ID and reloads the transaction list.
  ///
  /// [transactionId] is the ID of the transaction to be deleted.
  Future<void> _deleteTransaction(String transactionId) async {
    try {
      // Delete the transaction document from Firestore
      await FirebaseFirestore.instance
          .collection('transactions')
          .doc(transactionId)
          .delete();
      // Reload transactions immediately after deletion
      _loadTransactions();
    } catch (e) {
      // Print error message if deletion fails
      print('Error deleting transaction: $e');
    }
  }

  /// Navigates to the edit transaction screen for a given transaction ID.
  ///
  /// [transactionId] is the ID of the transaction to be edited.
  void _editTransaction(String transactionId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditTransactionScreen(transactionId: transactionId),
      ),
    ).then((_) {
      // Reload transactions after returning from the edit screen
      if (mounted) _loadTransactions();
    });
  }

  /// Loads transactions from Firestore based on the current user and selected filters.
  Future<void> _loadTransactions() async {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    // Determine transaction type based on selected option
    String transactionType =
        widget.selectedOption == 'Einnahmen' ? 'income' : 'expense';

    try {
      // Fetch transactions from Firestore with the specified filters
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: transactionType)
          .orderBy('date', descending: true)
          .get();

      // Update state with fetched transactions and apply category filter
      setState(() {
        _allTransactions = querySnapshot.docs;
        _filteredTransactions = _applyCategoryFilter(_allTransactions);
        _isLoading = false;
      });
      // Notify the parent widget about the transaction changes
      widget.onTransactionChangeCallback();
    } catch (e) {
      // Handle and print error if fetching transactions fails
      print('Fehler beim Laden der Transaktionen: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Applies a category filter to the list of transactions.
  ///
  /// [transactions] is the list of transactions to filter.
  /// Returns a list of transactions that match the selected category.
  List<DocumentSnapshot> _applyCategoryFilter(
      List<DocumentSnapshot> transactions) {
    if (widget.selectedCategory == null || widget.selectedCategory!.isEmpty) {
      // Return all transactions if no category is selected
      return transactions;
    }
    // Filter transactions by selected category
    return transactions.where((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return data['category'] == widget.selectedCategory;
    }).toList();
  }

  @override
  void didUpdateWidget(covariant TransactionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload transactions if the selected option changes
    if (oldWidget.selectedOption != widget.selectedOption) {
      setState(() {
        _isLoading = true;
      });
      _loadTransactions();
    } else if (oldWidget.selectedCategory != widget.selectedCategory) {
      // Apply category filter if the selected category changes
      setState(() {
        _filteredTransactions = _applyCategoryFilter(_allTransactions);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Display loading indicator if transactions are still loading
    if (_isLoading) {
      return CircularProgressIndicator();
    }

    // Display message if no transactions are found
    if (_filteredTransactions.isEmpty) {
      return Text('Keine Transaktionen gefunden');
    }

    // Build a ListView of transaction tiles
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: _filteredTransactions.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return Padding(
          padding: const EdgeInsets.only(bottom: CustomPadding.mediumSpace),
          child: TransactionTile(
            title: data['title'],
            amount: data['amount'],
            date: (data['date'] as Timestamp).toDate(),
            category: data['category'],
            transactionId: document.id,
            notes: data['notes'],
            recurrenceType: data['recurrenceType'],
            type: data['type'],
            onDelete: _deleteTransaction,
            onEdit: _editTransaction,
          ),
        );
      }).toList(),
    );
  }
}