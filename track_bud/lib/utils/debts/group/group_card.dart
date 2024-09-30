import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/models/group_model.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/provider/group_provider.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/balance_state.dart';
import 'package:track_bud/utils/enum/debts_box.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/views/subpages/group_overview_screen.dart';

// This widget represents a single group in the DebtsScreen or YourGroupScreen.
class GroupCard extends StatelessWidget {
  final GroupModel group; // The GroupModel instance passed to this widget.

  const GroupCard({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme; // Get the default color scheme from the theme.
    final firestoreService = FirestoreService(); // Create an instance of FirestoreService to interact with Firestore.

    // Parse the group's creation date and format it.
    DateTime createdAt = DateTime.parse(group.createdAt);
    String formattedDate = DateFormat.yMd('de_DE').format(createdAt);

    // Access the GroupProvider to retrieve expenses and user credits.
    final groupProvider = Provider.of<GroupProvider>(context);
    final totalExpense = groupProvider.getGroupExpense(group.groupId);
    final userCredit = groupProvider.getUserCredit(group.groupId);

    // Determine the color scheme for displaying user balance based on credit.
    DebtsColorScheme colorScheme;
    if (userCredit > 0) {
      colorScheme = DebtsColorScheme.green; // User is owed money.
    } else if (userCredit < 0) {
      colorScheme = DebtsColorScheme.red; // User owes money.
    } else {
      colorScheme = DebtsColorScheme.blue; // User's balance is zero.
    }

    return GestureDetector(
      onTap: () {
        // Navigate to the GroupOverviewScreen when the group card is tapped.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupOverviewScreen(
              groupName: group.name,
              groupId: group.groupId,
            ),
          ),
        );
      },
      child: CustomShadow(
        child: Container(
          width: MediaQuery.sizeOf(context).width, // Set the width of the container to the screen width.
          padding: const EdgeInsets.all(CustomPadding.defaultSpace), // Add default padding around the container.
          decoration: BoxDecoration(
            color: defaultColorScheme.surface, // Set the background color of the container.
            borderRadius: BorderRadius.circular(Constants.contentBorderRadius), // Round the corners of the container.
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start of the column.
            children: [
              ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0), // Create a circular profile picture.
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: group.profilePictureUrl.isNotEmpty
                        ? Image.network(group.profilePictureUrl, fit: BoxFit.cover) // Load group profile picture from URL.
                        : const Icon(Icons.group, color: Colors.grey), // Default icon if no profile picture is available.
                  ),
                ),
                title: Text(
                  group.name,
                  style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary), // Display group name with styling.
                ),
                subtitle: Text(
                  'Erstellt am: $formattedDate', // Show the formatted creation date.
                  style: TextStyles.hintStyleDefault.copyWith(
                    fontSize: TextStyles.fontSizeHint,
                    color: defaultColorScheme.secondary, // Style for the subtitle.
                  ),
                ),
                trailing: Text(
                  '${totalExpense.toStringAsFixed(2)}€', // Display total expenses formatted as currency.
                  style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary), // Style for the trailing text.
                ),
                minVerticalPadding: 0, // Set minimum vertical padding to zero.
                contentPadding: EdgeInsets.zero, // Remove content padding.
              ),
              Divider(color: defaultColorScheme.outline), // Add a divider below the ListTile.
              const Gap(CustomPadding.mediumSpace), // Add medium space between elements.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space elements evenly within the row.
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44, // Set the height of the members' stack.
                      width: 300,
                      child: Stack(
                        children: List.generate(group.members.length, (index) {
                          final reverseIndex = group.members.length - 1 - index; // Calculate the reversed index for stacking members.
                          return FutureBuilder<UserModel?>(
                            future: firestoreService.getUser(group.members[reverseIndex]), // Fetch user data for each member.
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const SizedBox.shrink(); // Placeholder while user data is loading.
                              }
                              if (snapshot.hasError || snapshot.data == null) {
                                return const Icon(Icons.person, color: Colors.grey); // Display default icon on error or if user not found.
                              }
                              final member = snapshot.data!; // Get the member data from snapshot.
                              return Positioned(
                                left: index * 30, // Position members with some overlap based on their index.
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: defaultColorScheme.surface, // Set border color around the profile picture.
                                      width: 1.0, // Set border width.
                                    ),
                                    borderRadius: BorderRadius.circular(100.0), // Make the picture circular.
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0), // Round the corners of the profile picture.
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: member.profilePictureUrl.isNotEmpty
                                          ? Image.network(member.profilePictureUrl,
                                              fit: BoxFit.cover) // Load member profile picture from URL.
                                          : const Icon(Icons.person,
                                              color: Colors.grey), // Default icon if no profile picture is available.
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ),
                  ),
                  BalanceState(
                    colorScheme: colorScheme, // Pass the determined color scheme for balance.
                    amount: userCredit == 0
                        ? null // Set amount to null for 'quitt' to trigger the default state in BalanceState.
                        : '${userCredit.abs().toStringAsFixed(2)}€', // Display user credit formatted as currency.
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
