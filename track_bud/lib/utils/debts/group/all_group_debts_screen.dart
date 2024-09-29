import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/provider/group_provider.dart';
import 'package:track_bud/services/firestore_service.dart'; // Import Firestore service for database interactions
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/strings.dart';

class AllDebtsScreen extends StatelessWidget {
  final String groupId; // Identifier for the group

  const AllDebtsScreen({super.key, required this.groupId}); // Constructor

  @override
  Widget build(BuildContext context) {
    // Access group provider to retrieve group-related data
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);
    final defaultColorScheme = Theme.of(context).colorScheme; // Get current theme's color scheme
    final firestoreService = FirestoreService(); // Initialize Firestore service

    return Scaffold(
      appBar: AppBar(
        title: Text(AppTexts.allGroupDebts, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
        centerTitle: true, // Center the title
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: groupProvider.getGroupDebtsOverview(groupId), // Fetch debts overview for the group
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Show loading indicator
          }
          // Handle errors
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}', style: TextStyle(color: defaultColorScheme.primary))); // Show error message
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
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: CustomPadding.mediumSpace,
                ),
                child: CustomShadow(
                  child: Container(
                    padding: const EdgeInsets.all(CustomPadding.smallSpace), // Padding within the container
                    decoration: BoxDecoration(
                      color: defaultColorScheme.surface, // Set background color
                      borderRadius: BorderRadius.circular(Constants.contentBorderRadius), // Rounded corners
                    ),
                    child: FutureBuilder<UserModel?>(
                      future: firestoreService.getUser(payment['from']), // Fetch debtor's user model
                      builder: (context, debtorSnapshot) {
                        return FutureBuilder<UserModel?>(
                          future: firestoreService.getUser(payment['to']), // Fetch creditor's user model
                          builder: (context, creditorSnapshot) {
                            // Handle loading state for user data
                            if (debtorSnapshot.connectionState == ConnectionState.waiting ||
                                creditorSnapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator(); // Show loading indicator
                            }

                            // Create widget for debtor's profile
                            Widget debtorProfileWidget;
                            if (debtorSnapshot.hasData && debtorSnapshot.data!.profilePictureUrl.isNotEmpty) {
                              debtorProfileWidget = ClipRRect(
                                borderRadius: BorderRadius.circular(100.0), // Circular clipping for profile picture
                                child: Image.network(
                                  debtorSnapshot.data!.profilePictureUrl, // Load debtor's profile picture from network
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.cover,
                                ),
                              );
                            } else {
                              // Default avatar if no profile picture is available
                              debtorProfileWidget = const CircleAvatar(
                                radius: 20,
                                child: Icon(Icons.person),
                              );
                            }

                            // Create widget for creditor's profile
                            Widget creditorProfileWidget;
                            if (creditorSnapshot.hasData && creditorSnapshot.data!.profilePictureUrl.isNotEmpty) {
                              creditorProfileWidget = ClipRRect(
                                borderRadius: BorderRadius.circular(100.0), // Circular clipping for profile picture
                                child: Image.network(
                                  creditorSnapshot.data!.profilePictureUrl, // Load creditor's profile picture from network
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.cover,
                                ),
                              );
                            } else {
                              // Default avatar if no profile picture is available
                              creditorProfileWidget = const CircleAvatar(
                                radius: 20,
                                child: Icon(Icons.person),
                              );
                            }

                            // Create a list tile for the payment
                            return ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between debtor and creditor sections
                                children: [
                                  // Debtor Column
                                  Expanded(
                                    child: Column(
                                      children: [
                                        debtorProfileWidget, // Display debtor's profile widget
                                        Text(
                                          payment['fromName'], // Display debtor's name
                                          style: const TextStyle(
                                            color: CustomColor.red, // Red color for debtor's name
                                            fontSize: 14,
                                          ),
                                          maxLines: 2, // Allow name to wrap into two lines
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
                                    child: Text(
                                      '${payment['amount'].toStringAsFixed(2)}€', // Display amount formatted to two decimal places
                                      style: TextStyle(
                                        color: defaultColorScheme.primary, // Color for amount text
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  // Creditor Column
                                  Expanded(
                                    child: Column(
                                      children: [
                                        creditorProfileWidget, // Display creditor's profile widget
                                        Text(
                                          payment['toName'], // Display creditor's name
                                          style: const TextStyle(
                                            color: CustomColor.green, // Green color for creditor's name
                                            fontSize: 14,
                                          ),
                                          maxLines: 2, // Allow name to wrap into two lines
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis, // Prevent overflow beyond two lines
                                          textAlign: TextAlign.center, // Center the text
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
