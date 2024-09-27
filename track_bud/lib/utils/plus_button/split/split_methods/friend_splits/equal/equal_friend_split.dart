import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/plus_button/split/split_methods/friend_splits/equal/equal_friend_tile.dart';

class EqualFriendSplitWidget extends StatelessWidget {
  final double amount;
  final List<UserModel> users;
  final ValueChanged<List<double>> onAmountsChanged;

  const EqualFriendSplitWidget({
    super.key,
    required this.amount,
    required this.users,
    required this.onAmountsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final double splitAmount = amount / users.length;
    final List<double> amounts = List.filled(users.length, splitAmount);

    // Call onAmountsChanged with the calculated split amounts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onAmountsChanged(amounts);
    });

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: users.length,
      separatorBuilder: (context, index) =>
          const Gap(CustomPadding.mediumSpace),
      itemBuilder: (context, index) {
        return EqualFriendTile(
          user: users[index],
          splitAmount: splitAmount,
        );
      },
    );
  }
}
