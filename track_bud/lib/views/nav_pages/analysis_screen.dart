import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:track_bud/utils/analysis_chart.dart';
import 'package:track_bud/utils/button_widgets/dropdown.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/information_tiles.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/widgets/transaction_list.dart';

// Main screen for displaying financial analysis
class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  double _currentBalance = 0.00;
  String _selectedOption = 'Ausgaben'; // Default option is 'Expenses'

  @override
  Widget build(BuildContext context) {
    // Determine the title and color for the InfoTile based on the selected option
    String _infoTileTitle = _selectedOption == 'Ausgaben' ? 'ausgegeben' : 'erhalten';
    Color _infoTileColor = _selectedOption == 'Ausgaben' ? CustomColor.red : CustomColor.green;

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
            InfoTile(title: AppTexts.balance, amount: '${_currentBalance.toStringAsFixed(2)}', color: CustomColor.bluePrimary),
            Gap(
              CustomPadding.mediumSpace,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InfoTile(
                  title: _infoTileTitle,
                  amount: 'amount', // Placeholder text, replace with actual amount
                  color: _infoTileColor,
                  width: MediaQuery.sizeOf(context).width / 2 - Constants.infoTileSpace,
                ),
                CustomDropDown(
                  list: ['Ausgaben', 'Einnahmen'],
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
            Gap(CustomPadding.defaultSpace),
            DonutChart(selectedOption: _selectedOption),
            Gap(CustomPadding.defaultSpace),
            Text(AppTexts.history, style: TextStyles.regularStyleMedium),
            Gap(CustomPadding.mediumSpace),
            TransactionHistoryList(),
          ],
        ),
      ),
    );
  }
}
