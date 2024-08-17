import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:track_bud/utils/buttons_widget.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';

class ChartTile extends StatelessWidget {
  final Widget chartChild;
  const ChartTile({super.key, required this.chartChild});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.only(top: CustomPadding.bigSpace, bottom: CustomPadding.defaultSpace),
      decoration: BoxDecoration(
        color: CustomColor.white,
        borderRadius: BorderRadius.circular(Constants.buttonBorderRadius),
      ),
      child: chartChild,
    );
  }
}
