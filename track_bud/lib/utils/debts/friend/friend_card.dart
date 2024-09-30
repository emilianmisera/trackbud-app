import 'package:flutter/material.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/balance_state.dart';
import 'package:track_bud/utils/enum/debts_box.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/views/subpages/friend_profile_screen.dart';

/// This Widget shows information about a friend
class FriendCard extends StatelessWidget {
  // The friend whose details are displayed
  final UserModel friend;
  // Amount of debt related to this friend
  final double debtAmount;

  const FriendCard({super.key, required this.friend, required this.debtAmount});

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

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final colorScheme = _getColorScheme(debtAmount);

    return CustomShadow(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: defaultColorScheme.surface, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
        child: ListTile(
          leading: ClipRRect(
              borderRadius: BorderRadius.circular(100.0), // make profilepicture rounded
              child: SizedBox(
                  width: 40,
                  height: 40,
                  child: friend.profilePictureUrl != ""
                      ? Image.network(friend.profilePictureUrl, fit: BoxFit.cover) // Load profile picture,
                      : const Icon(Icons.person, color: Colors.grey))), //Placeholder icon if no picture
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between name and balance
            children: [
              // Friend name
              Text(friend.name, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
              // Display debt amount
              BalanceState(colorScheme: colorScheme, amount: debtAmount == 0 ? null : '${debtAmount.abs().toStringAsFixed(2)}€'),
            ],
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded, color: defaultColorScheme.primary),
          minVerticalPadding: CustomPadding.defaultSpace,
          onTap: () {
            // Navigate to friend's profile screen on tap
            Navigator.push(context, MaterialPageRoute(builder: (context) => FriendProfileScreen(friend: friend)));
          },
        ),
      ),
    );
  }
}
