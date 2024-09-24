import 'package:flutter/material.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/views/subpages/friend_profile_screen.dart';

// Widget to display a friend's card in a list
class FriendCard extends StatelessWidget {
  final UserModel friend;

  const FriendCard({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return CustomShadow(
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(color: defaultColorScheme.surface, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
        child: ListTile(
          // Friend's profile picture
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: SizedBox(
              width: 40,
              height: 40,
              child: friend.profilePictureUrl != ""
                  ? Image.network(friend.profilePictureUrl, fit: BoxFit.cover)
                  : const Icon(Icons.person, color: Colors.grey),
            ),
          ),
          // Friend's name
          title: Text(friend.name, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
          // Debt or credit information
          subtitle: Text('bekommt insgesamt ...',
              style: TextStyles.hintStyleDefault.copyWith(fontSize: TextStyles.fontSizeHint, color: defaultColorScheme.secondary)),
          // Navigation arrow
          trailing: Icon(Icons.arrow_forward_ios_rounded, color: defaultColorScheme.primary),
          minVerticalPadding: CustomPadding.defaultSpace,
          // Navigate to FriendDetailScreen when tapped
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FriendProfileScreen(friend: friend), // '**FriendName**'
              ),
            );
          },
        ),
      ),
    );
  }
}
