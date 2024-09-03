import 'package:flutter/material.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/textfield_widgets.dart';
import 'package:track_bud/views/subpages/friend_profile_screen.dart';

// Widget to display a friend's card in a list
class FriendCard extends StatelessWidget {
  final UserModel friend;

  const FriendCard({Key? key, required this.friend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(color: CustomColor.white, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
        child: ListTile(
          // Friend's profile picture
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Container(
              width: 40,
              height: 40,
              child: friend.profilePictureUrl != ""
                  ? Image.network(friend.profilePictureUrl, fit: BoxFit.cover)
                  : Icon(Icons.person, color: Colors.grey),
            ),
          ),
          // Friend's name
          title: Text(friend.name, style: TextStyles.regularStyleMedium),
          // Debt or credit information
          subtitle: Text('bekommt insgesamt ...', style: TextStyles.hintStyleDefault.copyWith(fontSize: TextStyles.fontSizeHint)),
          // Navigation arrow
          trailing: Icon(Icons.arrow_forward_ios_rounded, color: CustomColor.black),
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
