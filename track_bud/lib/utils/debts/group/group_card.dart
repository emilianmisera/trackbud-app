import 'package:cached_network_image/cached_network_image.dart'; // For loading network images efficiently with caching
import 'package:flutter/material.dart';
import 'package:gap/gap.dart'; // A package to provide spacing between widgets
import 'package:intl/intl.dart'; // Used for formatting dates
import 'package:provider/provider.dart'; // For state management (Provider pattern)
import 'package:track_bud/models/group_model.dart'; // GroupModel to represent group data
import 'package:track_bud/models/user_model.dart'; // UserModel to represent user data
import 'package:track_bud/provider/group_provider.dart'; // GroupProvider for managing group-related state
import 'package:track_bud/services/firestore_service.dart'; // FirestoreService to handle Firebase Firestore interactions
import 'package:track_bud/utils/constants.dart'; // Constants used throughout the app
import 'package:track_bud/utils/debts/balance_state.dart'; // UI component for displaying balance state
import 'package:track_bud/utils/enum/debts_box.dart'; // Enum for defining debt color schemes
import 'package:track_bud/utils/shadow.dart'; // CustomShadow for shadow effects on widgets
import 'package:track_bud/views/subpages/group_overview_screen.dart'; // GroupOverviewScreen for detailed group view

// A stateless widget to represent a card for a specific group
class GroupCard extends StatelessWidget {
  final GroupModel group;

  const GroupCard({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme; // Fetches current theme's color scheme
    final firestoreService = FirestoreService(); // Instance of FirestoreService to retrieve user info

    // Parsing the group's creation date and formatting it to 'dd/MM/yyyy' format in German locale
    DateTime createdAt = DateTime.parse(group.createdAt);
    String formattedDate = DateFormat.yMd('de_DE').format(createdAt);

    // Fetching group data from GroupProvider (such as total expenses and user credits)
    final groupProvider = Provider.of<GroupProvider>(context);
    final totalExpense = groupProvider.getGroupExpense(group.groupId);
    final userCredit = groupProvider.getUserCredit(group.groupId);

    // Selecting the color scheme based on the user's credit in the group
    DebtsColorScheme colorScheme;
    if (userCredit > 0) {
      colorScheme = DebtsColorScheme.green; // Positive credit (user is owed money)
    } else if (userCredit < 0) {
      colorScheme = DebtsColorScheme.red; // Negative credit (user owes money)
    } else {
      colorScheme = DebtsColorScheme.blue; // Neutral credit (balanced)
    }

    return GestureDetector(
      // Navigates to the GroupOverviewScreen when the card is tapped
      onTap: () {
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
      // Applies a custom shadow effect to the card
      child: CustomShadow(
        child: Container(
          width: MediaQuery.sizeOf(context).width, // Full width of the screen
          padding: const EdgeInsets.all(CustomPadding.defaultSpace), // Uniform padding
          decoration: BoxDecoration(
            color: defaultColorScheme.surface, // Background color of the card
            borderRadius: BorderRadius.circular(Constants.contentBorderRadius), // Rounded corners
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the left
            children: [
              ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0), // Circular image for the group
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: group.profilePictureUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: group.profilePictureUrl, // Loads group image
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const CircularProgressIndicator(), // Loading indicator
                            errorWidget: (context, url, error) => const Icon(Icons.group, color: Colors.grey), // Error widget
                          )
                        : const Icon(Icons.group, color: Colors.grey), // Default icon if no image URL
                  ),
                ),
                title: Text(
                  group.name, // Displays the group name
                  style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary),
                ),
                subtitle: Text(
                  'Erstellt am: $formattedDate', // Shows the formatted creation date
                  style: TextStyles.hintStyleDefault.copyWith(
                    fontSize: TextStyles.fontSizeHint,
                    color: defaultColorScheme.secondary,
                  ),
                ),
                trailing: Text(
                  '${totalExpense.toStringAsFixed(2)}€', // Displays the total expense in the group
                  style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary),
                ),
                minVerticalPadding: 0,
                contentPadding: EdgeInsets.zero, // Removes default padding
              ),
              Divider(color: defaultColorScheme.outline), // Divider between sections
              const Gap(CustomPadding.mediumSpace), // Adds space between elements
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns the content between edges
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      width: 300,
                      child: Stack(
                        // Generates avatars for all group members
                        children: List.generate(group.members.length, (index) {
                          final reverseIndex = group.members.length - 1 - index;
                          return FutureBuilder<UserModel?>(
                            future: firestoreService.getUser(group.members[reverseIndex]), // Retrieves user data from Firestore
                            builder: (context, snapshot) {
                              return Positioned(
                                left: index * 30, // Staggered avatar placement with overlapping
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: defaultColorScheme.surface,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(100.0), // Circular avatar
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: snapshot.hasError || snapshot.data == null
                                          ? CircleAvatar(
                                              // Use CircleAvatar here
                                              radius: 20,
                                              backgroundColor: defaultColorScheme.outline, // Set your desired background color
                                              child: Icon(Icons.person,
                                                  size: 30,
                                                  color: defaultColorScheme
                                                      .secondary), // You can also adjust the icon color for better contrast
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: snapshot.data!.profilePictureUrl, // Displays user profile picture
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => const CircularProgressIndicator(), // Loading indicator
                                              errorWidget: (context, url, error) => const Icon(Icons.person, size: 30), // Error icon
                                            ),
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
                    colorScheme: colorScheme, // Displays balance state (credit or debit)
                    amount: userCredit == 0 ? null : '${userCredit.abs().toStringAsFixed(2)}€', // Shows the amount only if non-zero
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
