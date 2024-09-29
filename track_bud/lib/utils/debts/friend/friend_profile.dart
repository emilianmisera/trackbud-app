import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/models/group_model.dart';
import 'package:track_bud/provider/group_provider.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/balance_state.dart';
import 'package:track_bud/utils/enum/debts_box.dart';
import 'package:track_bud/utils/strings.dart';

class FriendProfileDetails extends StatelessWidget {
  final double totalDebt; // Total debt amount for the friend
  final String friendId; // Identifier for the friend

  const FriendProfileDetails({
    super.key,
    required this.totalDebt,
    required this.friendId,
  });

  // Determines the appropriate color scheme based on the total debt
  DebtsColorScheme _determineColorScheme(double totalDebt) {
    if (totalDebt > 0) {
      return DebtsColorScheme.green; // Money owed to you
    } else if (totalDebt < 0) {
      return DebtsColorScheme.red; // Money you owe
    } else {
      return DebtsColorScheme.blue; // No debt
    }
  }

  // Builds the debts section of the profile
  Widget _buildDebtsSection(BuildContext context, DebtsColorScheme colorScheme) {
    final defaultColorScheme = Theme.of(context).colorScheme; // Retrieve current theme's color scheme

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between text and balance
      children: [
        Text(
          AppTexts.debts, // Title for the debts section
          style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary),
        ),
        BalanceState(
          colorScheme: colorScheme,
          amount: totalDebt == 0
              ? null // Null for 'quitt' state to trigger default in BalanceState
              : '${totalDebt.abs().toStringAsFixed(2)}€', // Display total debt formatted as currency
        ),
      ],
    );
  }

  // Builds the shared groups section header
  Widget _buildSharedGroupsSection(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme; // Current theme's color scheme

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Align text and images at the start
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppTexts.sameGroups, // Title for shared groups section
          style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary),
        ),
        Expanded(
          child: FutureBuilder<List<GroupModel>>(
            future: Provider.of<GroupProvider>(context, listen: false).getSharedGroups(friendId), // Fetch shared groups
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Show loading indicator
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}'); // Display error message
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('Keine gemeinsame Gruppen.'); // No shared groups found
              } else {
                return SizedBox(
                  height: 30, // Fixed height for group images
                  child: Stack(
                    alignment: Alignment.center, // Center the CircleAvatars in the stack
                    children: List.generate(snapshot.data!.length, (index) {
                      GroupModel group = snapshot.data![index]; // Get the group data
                      return Positioned(
                        right: index * 25.0, // Position images with some overlap
                        child: Container(
                          // Wrap CircleAvatar with a container for border
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: defaultColorScheme.surface, // Border color
                              width: 1, // Border width
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 15, // Radius of the avatar
                            backgroundImage: NetworkImage(group.profilePictureUrl), // Load group's profile picture
                            child: group.profilePictureUrl.isEmpty
                                ? const Icon(Icons.group, color: Colors.grey) // Default icon if no picture
                                : null,
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme; // Retrieve current theme's color scheme
    final colorScheme = _determineColorScheme(totalDebt); // Determine color scheme based on total debt

    return Container(
      width: MediaQuery.sizeOf(context).width, // Full width of the device
      decoration: BoxDecoration(
        color: defaultColorScheme.surface, // Background color for the details section
        borderRadius: BorderRadius.circular(Constants.contentBorderRadius), // Rounded corners
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: CustomPadding.defaultSpace,
        vertical: CustomPadding.defaultSpace,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
        children: [
          _buildDebtsSection(context, colorScheme), // Build the debts section
          const Gap(CustomPadding.defaultSpace), // Space between sections
          _buildSharedGroupsSection(context), // Build the shared groups section
        ],
      ),
    );
  }
}
