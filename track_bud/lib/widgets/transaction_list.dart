import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:track_bud/utils/information_tiles.dart';

class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('Ein Fehler ist aufgetreten ${snapshot.error}');
          return Text('Ein Fehler ist aufgetreten');
          
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Text('Keine Transaktionen gefunden');
      }

        return ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: TransactionTile(
                title: data['title'],
                amount: data['amount'],
                date: (data['date'] as Timestamp).toDate(),
                category: data['category'],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
