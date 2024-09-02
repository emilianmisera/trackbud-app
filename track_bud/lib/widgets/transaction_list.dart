import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/information_tiles.dart';
import 'package:track_bud/views/subpages/edit_transaction_screen.dart';

class TransactionList extends StatefulWidget {
  final VoidCallback onTransactionChangeCallback;
  final String? selectedOption; // income or expense
  final String? selectedCategory;

  const TransactionList(
      {super.key,
      required this.onTransactionChangeCallback,
      required this.selectedOption,
      this.selectedCategory});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  List<DocumentSnapshot> _allTransactions = [];
  List<DocumentSnapshot> _filteredTransactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _deleteTransaction(String transactionId) async {
    try {
      await FirebaseFirestore.instance
          .collection('transactions')
          .doc(transactionId)
          .delete();
      // Reload transactions immediately after deletion
      _loadTransactions();
    } catch (e) {
      print('Error deleting transaction: $e');
    }
  }

  void _editTransaction(String transactionId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditTransactionScreen(transactionId: transactionId),
      ),
    ).then((_) {
      // Reload transactions immediately after editing
      if (mounted) _loadTransactions();
    });
  }

  Future<void> _loadTransactions() async {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    String transactionType =
        widget.selectedOption == 'Einnahmen' ? 'income' : 'expense';

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: transactionType)
          .orderBy('date', descending: true)
          .get();

      setState(() {
        _allTransactions = querySnapshot.docs;
        _filteredTransactions = _applyCategoryFilter(_allTransactions);
        _isLoading = false;
      });
      // Notify the parent widget about the change
      widget.onTransactionChangeCallback();
    } catch (e) {
      print('Fehler beim Laden der Transaktionen: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<DocumentSnapshot> _applyCategoryFilter(
      List<DocumentSnapshot> transactions) {
    if (widget.selectedCategory == null || widget.selectedCategory!.isEmpty) {
      return transactions;
    }
    return transactions.where((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return data['category'] == widget.selectedCategory;
    }).toList();
  }

  @override
  void didUpdateWidget(covariant TransactionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedOption != widget.selectedOption) {
      setState(() {
        _isLoading = true;
      });
      _loadTransactions();
    } else if (oldWidget.selectedCategory != widget.selectedCategory) {
      setState(() {
        _filteredTransactions = _applyCategoryFilter(_allTransactions);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return CircularProgressIndicator();
    }

    if (_filteredTransactions.isEmpty) {
      return Text('Keine Transaktionen gefunden');
    }

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
