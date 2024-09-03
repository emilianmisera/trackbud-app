import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:track_bud/utils/analysis/chart/analysis_chart.dart';
import 'package:track_bud/utils/button_widgets/dropdown.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/tiles/information_tiles.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/widgets/transaction_list.dart';

// Main screen for displaying financial analysis
class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final double _currentBalance = 0.00;
  String _selectedOption = 'Ausgaben'; // Default option is 'Expenses'

  @override
  Widget build(BuildContext context) {
    // Determine the title and color for the InfoTile based on the selected option
    String infoTileTitle = _selectedOption == 'Ausgaben' ? 'ausgegeben' : 'erhalten';
    Color infoTileColor = _selectedOption == 'Ausgaben' ? CustomColor.red : CustomColor.green;

    return SingleChildScrollView(
      child: Padding(
        // Padding to ensure spacing around the content
        padding: EdgeInsets.only(
            top: MediaQuery.sizeOf(context).height * CustomPadding.topSpace,
            left: CustomPadding.defaultSpace,
            right: CustomPadding.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoTile(title: AppTexts.balance, amount: _currentBalance.toStringAsFixed(2), color: CustomColor.bluePrimary),
            const Gap(CustomPadding.mediumSpace),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InfoTile(
                  title: infoTileTitle,
                  amount: 'amount', // Placeholder text, replace with actual amount
                  color: infoTileColor,
                  width: MediaQuery.sizeOf(context).width / 2 - Constants.infoTileSpace,
                ),
                CustomDropDown(
                  list: const ['Ausgaben', 'Einnahmen'],
                  width: MediaQuery.sizeOf(context).width / 2 - Constants.infoTileSpace,
                  height: 88,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value;
                    });
                  },
                ),
              ],
            ),
            const Gap(CustomPadding.defaultSpace),
            DonutChart(selectedOption: _selectedOption),
            const Gap(CustomPadding.defaultSpace),
            Text(AppTexts.history, style: TextStyles.regularStyleMedium),
            const Gap(CustomPadding.mediumSpace),
            const TransactionHistoryList(),
          ],
        ),
      ),
    );
  }
}
