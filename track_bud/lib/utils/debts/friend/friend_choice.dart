import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';

class FriendChoice extends StatelessWidget {
  final UserModel friend;
  final void Function() onTap;

  const FriendChoice({
    super.key,
    required this.friend,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      // Apply shadow for consistency with GroupChoice
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: CustomColor.white,
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(
            horizontal: CustomPadding.defaultSpace,
          ), // Margin to space the card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0), // Padding for the card content
            child: Row(
              children: [
                // Friend's profile picture
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: friend.profilePictureUrl.isNotEmpty
                        ? Image.network(friend.profilePictureUrl,
                            fit: BoxFit.cover)
                        : const Icon(Icons.person, color: Colors.grey),
                  ),
                ),
                const Gap(CustomPadding.mediumSpace),
                // Friend's name
                Expanded(
                  child:
                      Text(friend.name, style: TextStyles.regularStyleMedium),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
