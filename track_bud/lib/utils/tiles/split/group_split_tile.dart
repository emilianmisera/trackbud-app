import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:track_bud/models/group_split_model.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/categories/category_icon.dart';
import 'package:track_bud/utils/enum/categories.dart';
import 'package:track_bud/utils/shadow.dart';

class GroupSplitTile extends StatelessWidget {
  final GroupSplitModel split; // The group split model containing split details
  final String currentUserId; // ID of the current user

  const GroupSplitTile({
    super.key,
    required this.split,
    required this.currentUserId,
  });

  // Fetches and returns the participant avatars as a list of widgets
  Future<List<Widget>> _getParticipantAvatars(GroupSplitModel split, ColorScheme colorScheme) async {
    List<Widget> avatars = [];
    FirestoreService firestoreService = FirestoreService();

    // Iterate through each split share to create avatar widgets
    for (int i = 0; i < split.splitShares.length; i++) {
      var share = split.splitShares[i];
      String userId = share['userId']; // Get user ID from share
      var user = await firestoreService.getUser(userId); // Fetch user data

      if (user != null && user.profilePictureUrl.isNotEmpty) {
        // If user has a profile picture, create an image avatar
        avatars.add(
          Positioned(
            right: i * 20.0, // Positioning for avatars to overlap slightly
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.surface, width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: Image.network(user.profilePictureUrl, fit: BoxFit.cover), // Display user's profile picture
                ),
              ),
            ),
          ),
        );
      } else {
        // Default avatar if no profile picture is available
        avatars.add(
          Positioned(
            right: i * 20.0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.surface, width: 1),
              ),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: colorScheme.outline,
                child: Icon(Icons.person, size: 20, color: colorScheme.secondary), // Placeholder icon
              ),
            ),
          ),
        );
      }
    }

    return avatars; // Return the list of avatar widgets
  }

  // Fetches and returns the name of the user who paid the amount
  Future<String> _getPaidByName(String userId) async {
    FirestoreService firestoreService = FirestoreService();
    var user = await firestoreService.getUser(userId); // Fetch user data
    return user?.name ?? 'Unknown'; // Return user's name or 'Unknown' if not found
  }

  // Builds the header section of the group split tile
  Widget _buildHeader(ColorScheme defaultColorScheme) {
    final categoryData = Categories.values.firstWhere(
      (category) => category.categoryName.toLowerCase() == split.category.toLowerCase(),
      orElse: () => Categories.sonstiges,
    );

    final bool isCurrentUserPayer = split.paidBy == currentUserId;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: categoryData.color.withOpacity(0.2), // Category color with transparency
          ),
          padding: const EdgeInsets.only(right: CustomPadding.defaultSpace),
          child: Row(
            children: [
              CategoryIcon(
                color: categoryData.color,
                iconWidget: categoryData.icon,
              ),
              const Gap(CustomPadding.mediumSpace),
              FutureBuilder<String>(
                future: _getPaidByName(split.paidBy), // Fetch the payer's name
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Show loading indicator while fetching data
                  }
                  return Text(
                    isCurrentUserPayer ? 'Du' : snapshot.data ?? 'Unbekannt', // Display payer's name
                    style: TextStyles.regularStyleDefault.copyWith(
                      fontSize: TextStyles.fontSizeHint,
                      color: defaultColorScheme.primary,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Text(
          split.type == 'expense'
              ? '-${split.totalAmount.toStringAsFixed(2)}€'
              : '+${split.totalAmount.toStringAsFixed(2)}€', // Display total amount
          style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary),
        ),
      ],
    );
  }

  // Builds the detail section of the group split tile
  Widget _buildDetailSection(double amountToDisplay, Color amountColor, ColorScheme defaultColorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          split.title, // Display the title of the split
          style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary),
        ),
        if (amountToDisplay != 0) // Only display if there's an amount to show
          Text(
            '${amountToDisplay.toStringAsFixed(2)}€', // Display the amount
            style: TextStyles.regularStyleDefault.copyWith(color: amountColor),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme; // Get the default color scheme

    final currentUserShare = split.splitShares.firstWhere(
      (share) => share['userId'] == currentUserId,
      orElse: () => {'amount': 0.0},
    )['amount'] as double; // Get the current user's share amount

    final bool isCurrentUserPayer = split.paidBy == currentUserId;
    double amountToDisplay = isCurrentUserPayer
        ? split.totalAmount - currentUserShare // Amount others owe the current user
        : currentUserShare; // Amount the current user owes

    return CustomShadow(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(CustomPadding.defaultSpace), // Padding for the tile
        decoration: BoxDecoration(
          color: defaultColorScheme.surface, // Background color of the tile
          borderRadius: BorderRadius.circular(Constants.contentBorderRadius), // Rounded corners
        ),
        child: Column(children: [
          _buildHeader(defaultColorScheme), // Build the header section
          const Gap(CustomPadding.defaultSpace), // Space between sections
          _buildDetailSection(
              amountToDisplay, isCurrentUserPayer ? Colors.green : Colors.red, defaultColorScheme), // Build the detail section
          Divider(color: defaultColorScheme.outline), // Divider line
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('dd.MM.yyyy, HH:mm').format(split.date.toDate()), // Format and display the date
                style: TextStyles.hintStyleDefault.copyWith(
                  fontSize: TextStyles.fontSizeHint,
                  color: defaultColorScheme.secondary,
                ),
              ),
              // Display participant avatars in a stack
              SizedBox(
                width: 220,
                height: 30,
                child: FutureBuilder<List<Widget>>(
                  future: _getParticipantAvatars(split, defaultColorScheme), // Fetch participant avatars
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(), // Loading indicator for avatars
                      );
                    } else if (snapshot.hasError) {
                      return const Icon(Icons.error); // Show error icon if fetching fails
                    } else if (snapshot.hasData) {
                      return Stack(children: snapshot.data!); // Stack the avatar widgets
                    } else {
                      return const SizedBox.shrink(); // Empty widget if no data
                    }
                  },
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
