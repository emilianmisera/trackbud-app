import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/plus_button/split/split_methods/equal/eqal_tile.dart';
import 'package:track_bud/utils/constants.dart';

// Widget for displaying equal split for multiple people
class EqualSplitWidget extends StatelessWidget {
  // Total amount to be split
  final double amount;
  // List of names of people involved in the split
  final List<UserModel> users; // Whether this is a group split
  final bool? isGroup;

  const EqualSplitWidget({
    super.key,
    required this.amount,
    required this.users,
    this.isGroup,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the split amount for each person
    final double splitAmount = amount / users.length;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: users.length,
      separatorBuilder: (context, index) =>
          const Gap(CustomPadding.mediumSpace),
      itemBuilder: (context, index) {
        return EqualTile(
          user: users[index],
          splitAmount: splitAmount,
          friendSplit: isGroup ?? false,
        );
      },
    );
  }
}
