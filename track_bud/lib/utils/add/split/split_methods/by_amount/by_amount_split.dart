import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/add/split/split_methods/by_amount/by_amount_tile.dart';
import 'package:track_bud/utils/constants.dart';


/// Widget for displaying split by amount for multiple people
class ByAmountSplitWidget extends StatelessWidget {
  // List of names of people involved in the split
  final List<String> names;

  const ByAmountSplitWidget({
    Key? key,
    required this.names,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: names.length,
      separatorBuilder: (context, index) => Gap(CustomPadding.mediumSpace),
      itemBuilder: (context, index) {
        return ByAmountTile(name: names[index]);
      },
    );
  }
}
