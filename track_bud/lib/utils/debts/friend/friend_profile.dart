import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/models/group_model.dart';
import 'package:track_bud/provider/group_provider.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/balance_state.dart';
import 'package:track_bud/utils/enum/debts_box.dart';
import 'package:track_bud/utils/strings.dart';

/// This Widget is used in FriendProdileScreen
/// it shows the debts information and the shared groups
class FriendProfileDetails extends StatelessWidget {
  final double totalDebt; // Total debt amount for the friend
  final String friendId;

  const FriendProfileDetails({super.key, required this.totalDebt, required this.friendId});

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
    final defaultColorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(AppTexts.debts, style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
        // Null for 'quitt' state to trigger default in BalanceState
        // Display total debt formatted as currency
        BalanceState(colorScheme: colorScheme, amount: totalDebt == 0 ? null : '${totalDebt.abs().toStringAsFixed(2)}€'),
      ],
    );
  }

  // Builds the shared groups section header
  Widget _buildSharedGroupsSection(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(AppTexts.sameGroups, style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
        Expanded(
          child: FutureBuilder<List<GroupModel>>(
            future: Provider.of<GroupProvider>(context, listen: false).getSharedGroups(friendId), // Fetch shared groups
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Show loading indicator
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}',
                    style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.secondary)); // Display error message
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('Keine gemeinsame Gruppen.',
                    style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.secondary)); // No shared groups found
              } else {
                return SizedBox(
                  height: Constants.sameGroupImages,
                  child: Stack(
                    alignment: Alignment.center,
                    children: List.generate(snapshot.data!.length, (index) {
                      GroupModel group = snapshot.data![index]; // Get the group data
                      return Positioned(
                        right: index * 25.0, // Position images with some overlap
                        child: Container(
                          decoration:
                              BoxDecoration(shape: BoxShape.circle, border: Border.all(color: defaultColorScheme.surface, width: 1)),
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
    final defaultColorScheme = Theme.of(context).colorScheme;
    final colorScheme = _determineColorScheme(totalDebt);

    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(color: defaultColorScheme.surface, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
      padding: const EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace, vertical: CustomPadding.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Build the debts section
          _buildDebtsSection(context, colorScheme),
          const Gap(CustomPadding.defaultSpace),
          // Build the shared groups section
          _buildSharedGroupsSection(context),
        ],
      ),
    );
  }
}
