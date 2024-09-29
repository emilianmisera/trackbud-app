import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/tiles/transaction/transaction_tile.dart';
import 'package:track_bud/views/subpages/edit_transaction_screen.dart';

class TransactionHistoryList extends StatefulWidget {
  final String transactionType;
  final String? selectedCategory; // Accept the selected category

  const TransactionHistoryList({
    super.key,
    required this.transactionType,
    this.selectedCategory,
  });

  @override
  State<TransactionHistoryList> createState() => _TransactionHistoryListState();
}

class _TransactionHistoryListState extends State<TransactionHistoryList> {
  @override
  Widget build(BuildContext context) {
    debugPrint('TransactionHistoryList: Building widget');
    final user = FirebaseAuth.instance.currentUser;
    debugPrint('Current user UID: ${user?.uid}');
    final defaultColorScheme = Theme.of(context).colorScheme;

    Query transactionsQuery = FirebaseFirestore.instance
        .collection('transactions')
        .where('userId', isEqualTo: user?.uid)
        .where('type', isEqualTo: widget.transactionType);

    if (widget.selectedCategory != null) {
      transactionsQuery = transactionsQuery.where('category', isEqualTo: widget.selectedCategory);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: transactionsQuery.orderBy('date', descending: true).limit(10).snapshots(),
      builder: (context, snapshot) {
        debugPrint('StreamBuilder: Connection state: ${snapshot.connectionState}');
        if (snapshot.hasError) {
          debugPrint('StreamBuilder Error: ${snapshot.error}');
          return Text('Etwas ist schiefgelaufen: ${snapshot.error}', style: TextStyle(color: defaultColorScheme.primary));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          debugPrint('StreamBuilder: Waiting for data');
          return const CircularProgressIndicator(color: CustomColor.bluePrimary);
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          debugPrint('StreamBuilder: No data available');
          return Text('Keine Transaktionen vorhanden', style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.secondary));
        }
        debugPrint('StreamBuilder: Data received, doc count: ${snapshot.data!.docs.length}');

        final transactions = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            DocumentSnapshot doc = snapshot.data!.docs[index];
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            debugPrint('Building item $index: ${data['title']}');
            return Padding(
              padding: const EdgeInsets.only(bottom: CustomPadding.mediumSpace),
              child: TransactionTile(
                title: data['title'] ?? 'Unbekannter Titel',
                amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
                date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
                category: data['category'] ?? 'Keine Kategorie',
                transactionId: doc.id,
                note: data['note'] ?? '',
                recurrence: data['recurrence'] ?? 'Einmalig',
                type: widget.transactionType,
                onEdit: (String id) {
                  debugPrint('Editing transaction: $id');
                  // Navigate to the edit screen, passing the transaction ID
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditTransactionScreen(transactionId: id),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
