import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/provider/group_provider.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/strings.dart';

/// This Screen shows all debts in the Group
class AllDebtsScreen extends StatelessWidget {
  final String groupId; // Identifier for the group

  const AllDebtsScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    // Access group provider to retrieve group-related data
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);
    final defaultColorScheme = Theme.of(context).colorScheme;
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
          title: Text(AppTexts.allGroupDebts, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
          centerTitle: true),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: groupProvider.getGroupDebtsOverview(groupId), // Fetch debts overview for the group
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Handle errors
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: defaultColorScheme.primary)));
          }

          List<Map<String, dynamic>> payments = snapshot.data ?? []; // Get payments data

          // Check if there are no payments
          if (payments.isEmpty) {
            return Center(
                child: Text(
              AppTexts.groupDebtsAreSettled,
              style: TextStyle(color: defaultColorScheme.primary),
            )); // Inform user if all debts are settled
          }

          return ListView.builder(
            itemCount: payments.length, // Number of payments to display
            itemBuilder: (context, index) {
              var payment = payments[index]; // Current payment

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: CustomPadding.smallSpace, horizontal: CustomPadding.mediumSpace),
                child: CustomShadow(
                  child: Container(
                    padding: const EdgeInsets.all(CustomPadding.smallSpace),
                    decoration: BoxDecoration(
                        color: defaultColorScheme.surface, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
                    child: FutureBuilder<UserModel?>(
                      future: firestoreService.getUser(payment['from']), // Fetch debtor's user model
                      builder: (context, debtorSnapshot) {
                        return FutureBuilder<UserModel?>(
                          future: firestoreService.getUser(payment['to']), // Fetch creditor's user model
                          builder: (context, creditorSnapshot) {
                            // Handle loading state for user data
                            if (debtorSnapshot.connectionState == ConnectionState.waiting ||
                                creditorSnapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            Widget debtorProfileWidget;
                            if (debtorSnapshot.hasData && debtorSnapshot.data!.profilePictureUrl.isNotEmpty) {
                              debtorProfileWidget = ClipRRect(
                                borderRadius: BorderRadius.circular(Constants.roundedCorners),
                                child: Image.network(
                                  debtorSnapshot.data!.profilePictureUrl, // Load debtor's profile picture from network
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.cover,
                                ),
                              );
                            } else {
                              // Default avatar if no profile picture is available
                              debtorProfileWidget = const CircleAvatar(radius: 20, child: Icon(Icons.person));
                            }

                            // Create widget for creditor's profile
                            Widget creditorProfileWidget;
                            if (creditorSnapshot.hasData && creditorSnapshot.data!.profilePictureUrl.isNotEmpty) {
                              creditorProfileWidget = ClipRRect(
                                borderRadius: BorderRadius.circular(Constants.roundedCorners),
                                // Load creditor's profile picture from network
                                child: Image.network(creditorSnapshot.data!.profilePictureUrl, width: 30, height: 30, fit: BoxFit.cover),
                              );
                            } else {
                              // Default avatar if no profile picture is available
                              creditorProfileWidget = const CircleAvatar(radius: 20, child: Icon(Icons.person));
                            }

                            // Create a list tile for the payment
                            return ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        // Display debtor's profile widget
                                        debtorProfileWidget,
                                        Text(
                                          payment['fromName'], // Display debtor's name
                                          style: const TextStyle(
                                            color: CustomColor.red, // Red color for debtor's name
                                            fontSize: TextStyles.fontSizeHint,
                                          ),
                                          maxLines: 2,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis, // Prevent overflow beyond two lines
                                          textAlign: TextAlign.center, // Center the text
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Centered Amount
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 60.0), // Padding around amount text
                                    child: Text('${payment['amount'].toStringAsFixed(2)}€',
                                        style: TextStyle(color: defaultColorScheme.primary, fontWeight: FontWeight.bold)),
                                  ),

                                  // Creditor Column
                                  Expanded(
                                    child: Column(
                                      children: [
                                        creditorProfileWidget, // Display creditor's profile widget
                                        Text(
                                          payment['toName'], // Display creditor's name
                                          style: const TextStyle(color: CustomColor.green, fontSize: TextStyles.fontSizeHint),
                                          maxLines: 2,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
