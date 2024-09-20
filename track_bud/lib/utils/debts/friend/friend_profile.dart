import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';

// Widget to display detailed information about a friend's debts and shared groups
class FriendProfileDetails extends StatelessWidget {
  const FriendProfileDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: CustomColor.white,
        borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
      ),
      padding: const EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace, vertical: CustomPadding.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Debts section
          Text(AppTexts.debts, style: TextStyles.regularStyleDefault),
          const Gap(CustomPadding.mediumSpace),

          // TODO: add Amount Box to display debt amount
          // This should be implemented to show the current debt amount

          const Gap(CustomPadding.defaultSpace),

          // Shared groups section
          Text(AppTexts.sameGroups, style: TextStyles.regularStyleDefault),
          const Gap(CustomPadding.mediumSpace),

          // TODO: add same Groups
          // This should be implemented to show the groups shared with this friend
        ],
      ),
    );
  }
}
