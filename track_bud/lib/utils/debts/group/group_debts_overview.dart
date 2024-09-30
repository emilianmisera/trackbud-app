import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/provider/group_provider.dart';
import 'package:track_bud/provider/user_provider.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/balance_state.dart';
import 'package:track_bud/utils/enum/debts_box.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/services/firestore_service.dart';

/// This Widgets dispalys an Overview of all Debts in GroupOverviewScreen
class DebtsOverview extends StatelessWidget {
  final String groupId; // Identifier for the group
  const DebtsOverview({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    // Access providers to get group and user data
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final defaultColorScheme = Theme.of(context).colorScheme;
    final firestoreService = FirestoreService();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: groupProvider.getGroupDebtsOverview(groupId), // Fetch debts overview for the group
      builder: (context, snapshot) {
        // Handle loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}', style: TextStyle(color: defaultColorScheme.primary)); // Show error message
        }

        List<Map<String, dynamic>> allPayments = snapshot.data ?? []; // Get all payments data
        String currentUserId = userProvider.currentUser?.userId ?? ''; // Get current user ID

        // Filter payments to get only the ones involving the current user
        List<Map<String, dynamic>> userPayments =
            allPayments.where((payment) => payment['from'] == currentUserId || payment['to'] == currentUserId).toList();

        // Check if the user has any payments
        if (userPayments.isEmpty) {
          // Inform user if no debts or credits
          return Text('You have no outstanding debts or credits.', style: TextStyle(color: defaultColorScheme.primary));
        }

        return CustomShadow(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(CustomPadding.smallSpace),
            decoration:
                BoxDecoration(color: defaultColorScheme.surface, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Map through user payments to create list items, source: ClaudeAI
                ...userPayments.map((payment) {
                  bool isDebtor = payment['from'] == currentUserId;
                  String otherPersonId = isDebtor ? payment['to'] : payment['from'];
                  String otherPerson = isDebtor ? payment['toName'] : payment['fromName'];
                  // Get the amount
                  double amount = payment['amount'].toDouble();
                  // Set color scheme based on debt status
                  DebtsColorScheme colorScheme = isDebtor ? DebtsColorScheme.red : DebtsColorScheme.green;

                  return FutureBuilder<UserModel?>(
                    future: firestoreService.getUser(otherPersonId), // Fetch other person's user model
                    builder: (context, userSnapshot) {
                      // Handle loading state for user data
                      if (userSnapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // Show loading indicator
                      }

                      Widget leadingWidget; // Widget for leading icon
                      if (userSnapshot.hasData && userSnapshot.data!.profilePictureUrl.isNotEmpty) {
                        // Check if the user has a profile picture
                        leadingWidget = ClipRRect(
                          borderRadius: BorderRadius.circular(Constants.roundedCorners),
                          child: Image.network(userSnapshot.data!.profilePictureUrl, width: 30, height: 30, fit: BoxFit.cover),
                        );
                      } else {
                        // Default avatar if no profile picture is available
                        leadingWidget = CircleAvatar(
                            radius: 15,
                            backgroundColor: defaultColorScheme.outline,
                            child: Icon(Icons.person, color: defaultColorScheme.secondary));
                      }

                      // Create a list tile for the payment
                      return ListTile(
                        leading: leadingWidget,
                        title: Text(otherPerson, style: TextStyle(color: defaultColorScheme.primary)),
                        // Display amount
                        trailing: BalanceState(colorScheme: colorScheme, amount: '${amount.abs().toStringAsFixed(2)}€'),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
