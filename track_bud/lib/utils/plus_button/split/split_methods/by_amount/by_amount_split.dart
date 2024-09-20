import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/plus_button/split/split_methods/by_amount/by_amount_tile.dart';
import 'package:track_bud/utils/constants.dart';

/// Widget for displaying split by amount for multiple people
class ByAmountSplitWidget extends StatelessWidget {
  // List of users involved in the split
  final List<UserModel> users; 

  const ByAmountSplitWidget({
    super.key,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: users.length,
      separatorBuilder: (context, index) => const Gap(CustomPadding.mediumSpace),
      itemBuilder: (context, index) {
        return ByAmountTile(
          user: users[index], // Pass the UserModel
        );
      },
    );
  }
}