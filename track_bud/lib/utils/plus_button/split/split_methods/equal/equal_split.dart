import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/plus_button/split/split_methods/equal/eqal_tile.dart';
import 'package:track_bud/utils/constants.dart';

class EqualSplitWidget extends StatelessWidget {
  final double amount;
  final List<UserModel> users;
  final bool? isGroup;
  final ValueChanged<List<double>> onAmountsChanged;

  const EqualSplitWidget({
    super.key,
    required this.amount,
    required this.users,
    this.isGroup,
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
        return EqualTile(
          user: users[index],
          splitAmount: splitAmount,
          friendSplit: isGroup ?? false,
        );
      },
    );
  }
}
