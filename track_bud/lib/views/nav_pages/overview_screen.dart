import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/monthly_expense.dart';
import 'package:track_bud/utils/overview_chart.dart';
import 'package:track_bud/utils/overview_debts_widget.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          // spacing between content and screen
          padding: EdgeInsets.only(
              top: MediaQuery.sizeOf(context).height * CustomPadding.topSpace,
              left: CustomPadding.defaultSpace,
              right: CustomPadding.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpensesOverview(),
              Gap(CustomPadding.defaultSpace),
              MonthlyExpense(),
              Gap(CustomPadding.defaultSpace),
              OverviewDebtsWidget()
            ],
          ),
        ),
      ),
    );
  }
}
