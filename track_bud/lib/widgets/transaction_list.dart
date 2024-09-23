import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/tiles/transaction/transaction_tile.dart';
import 'package:track_bud/views/subpages/edit_transaction_screen.dart';

class TransactionHistoryList extends StatelessWidget {
  final String transactionType;

  const TransactionHistoryList({
    super.key,
    required this.transactionType,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('TransactionHistoryList: Building widget');
    final user = FirebaseAuth.instance.currentUser;
    debugPrint('Current user UID: ${user?.uid}');

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('transactions')
          .where('userId', isEqualTo: user?.uid)
          .where('type', isEqualTo: transactionType)
          .orderBy('date', descending: true)
          .limit(10)
          .snapshots(),
      builder: (context, snapshot) {
        debugPrint(
            'StreamBuilder: Connection state: ${snapshot.connectionState}');
        if (snapshot.hasError) {
          debugPrint('StreamBuilder Error: ${snapshot.error}');
          return Text('Etwas ist schiefgelaufen: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          debugPrint('StreamBuilder: Waiting for data');
          return const CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          debugPrint('StreamBuilder: No data available');
          return const Text('Keine Transaktionen vorhanden');
        }
        debugPrint(
            'StreamBuilder: Data received, doc count: ${snapshot.data!.docs.length}');

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: snapshot.data!.docs.length,
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
                type: transactionType == 'expense' ? 'Ausgabe' : 'Einnahme',
                onEdit: (String id) {
                  debugPrint('Editing transaction: $id');
                  // Navigate to the edit screen, passing the transaction ID
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditTransactionScreen(transactionId: id),
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
