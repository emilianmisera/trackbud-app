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
    final defaultColorScheme = Theme.of(context).colorScheme;
    return CustomShadow(
      // Apply shadow for consistency with GroupChoice
      child: GestureDetector(
        onTap: onTap,
        child: CustomShadow(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
              color: defaultColorScheme.surface,
            ),
            padding: const EdgeInsets.all(CustomPadding.mediumSpace),
            child: Row(
              children: [
                // Friend's profile picture
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: friend.profilePictureUrl.isNotEmpty
                        ? Image.network(friend.profilePictureUrl, fit: BoxFit.cover)
                        : const Icon(Icons.person, color: Colors.grey),
                  ),
                ),
                const Gap(CustomPadding.mediumSpace),
                // Friend's name
                Expanded(
                  child: Text(friend.name, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
