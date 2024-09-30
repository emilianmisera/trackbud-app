import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:track_bud/models/group_split_model.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/categories/category_icon.dart';
import 'package:track_bud/utils/enum/categories.dart';
import 'package:track_bud/utils/shadow.dart';

/// This Widgets shows the info about splits between you and your friendGroup
/// in GroupOverviewScreen
class GroupSplitTile extends StatelessWidget {
  final GroupSplitModel split; // The group split model containing split details
  final String currentUserId; // ID of the current user

  const GroupSplitTile({super.key, required this.split, required this.currentUserId});

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
        // create an image avatar
        avatars.add(
          Positioned(
            right: i * 20.0, // Positioning for avatars to overlap slightly
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: colorScheme.surface, width: 1)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Constants.roundedCorners),
                child: SizedBox(width: 28, height: 28, child: Image.network(user.profilePictureUrl, fit: BoxFit.cover)),
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
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: colorScheme.surface, width: 1)),
              child: CircleAvatar(
                  radius: 14, backgroundColor: colorScheme.outline, child: Icon(Icons.person, size: 20, color: colorScheme.secondary)),
            ),
          ),
        );
      }
    }

    return avatars;
  }

  // Fetches and returns the name of the user who paid the amount
  Future<String> _getPaidByName(String userId) async {
    FirestoreService firestoreService = FirestoreService();
    var user = await firestoreService.getUser(userId);
    return user?.name ?? 'Unknown';
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
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(Constants.roundedCorners), color: categoryData.color.withOpacity(0.2)),
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
                    return const CircularProgressIndicator();
                  }
                  return Text(
                    isCurrentUserPayer ? 'Du' : snapshot.data ?? 'Unbekannt', // Display payer's name
                    style: TextStyles.regularStyleDefault.copyWith(fontSize: TextStyles.fontSizeHint, color: defaultColorScheme.primary),
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
        // Display the title of the split
        Text(split.title, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
        if (amountToDisplay != 0) // Only display if there's an amount to show
          // Display the amount
          Text('${amountToDisplay.toStringAsFixed(2)}€', style: TextStyles.regularStyleDefault.copyWith(color: amountColor)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;

    final currentUserShare = split.splitShares.firstWhere(
      (share) => share['userId'] == currentUserId,
      orElse: () => {'amount': 0.0},
    )['amount'] as double;

    final bool isCurrentUserPayer = split.paidBy == currentUserId;
    double amountToDisplay = isCurrentUserPayer
        ? split.totalAmount - currentUserShare // Amount others owe the current user
        : currentUserShare; // Amount the current user owes

    return CustomShadow(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(CustomPadding.defaultSpace),
        decoration: BoxDecoration(color: defaultColorScheme.surface, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
        child: Column(children: [
          _buildHeader(defaultColorScheme),
          const Gap(CustomPadding.defaultSpace),
          _buildDetailSection(amountToDisplay, isCurrentUserPayer ? Colors.green : Colors.red, defaultColorScheme),
          Divider(color: defaultColorScheme.outline),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Format and display the date
              Text(
                DateFormat('dd.MM.yyyy, HH:mm').format(split.date.toDate()),
                style: TextStyles.hintStyleDefault.copyWith(fontSize: TextStyles.fontSizeHint, color: defaultColorScheme.secondary),
              ),
              // Display participant avatars in a stack
              SizedBox(
                width: 220,
                height: 30,
                child: FutureBuilder<List<Widget>>(
                  future: _getParticipantAvatars(split, defaultColorScheme), // Fetch participant avatars
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(width: 20, height: 20, child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Icon(Icons.error);
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
