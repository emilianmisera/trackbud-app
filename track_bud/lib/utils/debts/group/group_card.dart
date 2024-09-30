import 'package:cached_network_image/cached_network_image.dart';
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

class GroupCard extends StatelessWidget {
  final GroupModel group; // Holds the group data to be displayed on the card

  const GroupCard({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme; // Get color scheme from theme
    final firestoreService = FirestoreService(); // Firestore service to fetch data

    // Format the group's creation date for display
    DateTime createdAt = DateTime.parse(group.createdAt);
    String formattedDate = DateFormat.yMd('de_DE').format(createdAt);

    // Fetch data from the group provider (expenses and credit info)
    final groupProvider = Provider.of<GroupProvider>(context);
    final totalExpense = groupProvider.getGroupExpense(group.groupId); // Total group expense
    final userCredit = groupProvider.getUserCredit(group.groupId); // User's credit in the group

    // Determine color scheme based on user credit balance (positive, negative, or zero)
    DebtsColorScheme colorScheme;
    if (userCredit > 0) {
      colorScheme = DebtsColorScheme.green; // Positive credit
    } else if (userCredit < 0) {
      colorScheme = DebtsColorScheme.red; // Negative credit
    } else {
      colorScheme = DebtsColorScheme.blue; // Zero credit
    }

    return GestureDetector(
      onTap: () {
        // Navigate to GroupOverviewScreen when the card is tapped
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
        // Custom widget for card shadow effect
        child: Container(
          width: MediaQuery.sizeOf(context).width, // Full width of the screen
          padding: const EdgeInsets.all(CustomPadding.defaultSpace), // Padding inside the card
          decoration: BoxDecoration(
            color: defaultColorScheme.surface, // Set background color from theme
            borderRadius: BorderRadius.circular(Constants.contentBorderRadius), // Rounded corners
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start (left)
            children: [
              ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0), // Circular profile picture
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: group.profilePictureUrl.isNotEmpty
                        ? CachedNetworkImage(
                            // Load and display group's profile picture from a URL
                            imageUrl: group.profilePictureUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const CircularProgressIndicator(), // Show loading indicator while fetching
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.group, color: Colors.grey), // Show default icon if there's an error
                          )
                        : const Icon(Icons.group, color: Colors.grey), // Default icon if no image URL
                  ),
                ),
                title: Text(
                  group.name, // Group name
                  style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary), // Style for group name text
                ),
                subtitle: Text(
                  'Erstellt am: $formattedDate', // Display formatted creation date
                  style: TextStyles.hintStyleDefault.copyWith(
                    fontSize: TextStyles.fontSizeHint,
                    color: defaultColorScheme.secondary, // Secondary text color from theme
                  ),
                ),
                trailing: Text(
                  '${totalExpense.toStringAsFixed(2)}€', // Display total group expense
                  style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary), // Style for expense text
                ),
                minVerticalPadding: 0, // Adjust padding
                contentPadding: EdgeInsets.zero, // Remove default content padding
              ),
              Divider(color: defaultColorScheme.outline), // Horizontal divider line
              const Gap(CustomPadding.mediumSpace), // Gap/spacing between widgets
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align row children with space in between
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      width: 300,
                      child: Stack(
                        children: List.generate(group.members.length, (index) {
                          final reverseIndex = group.members.length - 1 - index; // Iterate over members in reverse order
                          return FutureBuilder<UserModel?>(
                            future: firestoreService.getUser(group.members[reverseIndex]), // Fetch user data from Firestore
                            builder: (context, snapshot) {
                              return Positioned(
                                left: index * 30, // Position each member image with an offset
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: defaultColorScheme.surface, // Border color matches card surface
                                      width: 1.0, // Border width
                                    ),
                                    borderRadius: BorderRadius.circular(100.0), // Circular border for images
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0), // Circular clipped image
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: snapshot.connectionState == ConnectionState.waiting
                                          ? const CircularProgressIndicator() // Show loading indicator while fetching user data
                                          : snapshot.hasError || snapshot.data == null
                                              ? const CircleAvatar(
                                                  radius: 20,
                                                  child: Icon(Icons.person, size: 30), // Default avatar if error or no data
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: snapshot.data!.profilePictureUrl, // Display member profile picture
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      const CircularProgressIndicator(), // Show loading indicator while fetching
                                                  errorWidget: (context, url, error) =>
                                                      const Icon(Icons.person, size: 30), // Default icon if error
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
                  // Display user's balance state with color and amount
                  BalanceState(
                    colorScheme: colorScheme, // Color scheme based on balance
                    amount: userCredit == 0
                        ? null // If balance is zero, show nothing
                        : '${userCredit.abs().toStringAsFixed(2)}€', // Show absolute value of credit/debt
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
