import 'package:flutter/material.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/balance_state.dart';
import 'package:track_bud/utils/enum/debts_box.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/views/subpages/friend_profile_screen.dart';

class FriendCard extends StatelessWidget {
  final UserModel friend; // The friend whose details are displayed
  final double debtAmount; // Amount of debt related to this friend

  const FriendCard({
    Key? key,
    required this.friend,
    required this.debtAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme; // Default color scheme
    final colorScheme = _getColorScheme(debtAmount); // Determine color scheme based on debt amount

    return CustomShadow(
      child: Container(
        width: MediaQuery.of(context).size.width, // Full width of the device
        decoration: BoxDecoration(
          color: defaultColorScheme.surface, // Background color of the card
          borderRadius: BorderRadius.circular(Constants.contentBorderRadius), // Rounded corners
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(100.0), // Circular profile picture
            child: SizedBox(
              width: 40,
              height: 40,
              child: friend.profilePictureUrl != ""
                  ? Image.network(friend.profilePictureUrl, fit: BoxFit.cover) // Load profile picture
                  : const Icon(Icons.person, color: Colors.grey), // Placeholder icon if no picture
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between name and balance
            children: [
              Text(
                friend.name,
                style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary), // Friend's name
              ),
              BalanceState(
                colorScheme: colorScheme,
                amount: debtAmount == 0 ? null : '${debtAmount.abs().toStringAsFixed(2)}€', // Display debt amount
              ),
            ],
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded, color: defaultColorScheme.primary), // Arrow indicating navigation
          minVerticalPadding: CustomPadding.defaultSpace, // Padding for vertical space
          onTap: () {
            // Navigate to friend's profile screen on tap
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FriendProfileScreen(friend: friend),
              ),
            );
          },
        ),
      ),
    );
  }

  // Determine color scheme based on debt amount
  DebtsColorScheme _getColorScheme(double balance) {
    if (balance > 0) {
      return DebtsColorScheme.green; // Friend owes you money
    } else if (balance < 0) {
      return DebtsColorScheme.red; // You owe friend money
    } else {
      return DebtsColorScheme.blue; // No debt
    }
  }
}
