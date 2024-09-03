// Widget for individual category icon
import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';

class CategoryIcon extends StatelessWidget {
  final Color color;
  final Image iconWidget;

  const CategoryIcon({
    super.key,
    required this.color,
    required this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        CustomPadding.categoryIconSpace,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: color,
      ),
      child: iconWidget, // Display category icon
    );
  }
}