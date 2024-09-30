import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';

/// Widget for individual category icon
class CategoryIcon extends StatelessWidget {
  final Color color;
  final Image iconWidget;

  const CategoryIcon({super.key, required this.color, required this.iconWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(CustomPadding.categoryIconSpace),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Constants.categoryBorderRadius), color: color),
      child: iconWidget, // Display category icon
    );
  }
}
