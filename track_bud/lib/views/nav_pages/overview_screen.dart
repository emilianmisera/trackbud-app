import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/group_widget.dart';
import 'package:track_bud/utils/overview/monthly_expense.dart';
import 'package:track_bud/utils/overview/overview_chart.dart';
import 'package:track_bud/utils/overview/debts.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/widgets/transaction_list.dart';

// Homescreen of the App, showing Information about Expenses and Debts
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
              // Tile showing Expenses with column chart
              ExpensesOverviewTile(),
              Gap(CustomPadding.defaultSpace),
              // Tile showing with Progress Bar how much money User has left to reach his budget goal
              MonthlyExpenseTile(),
              Gap(CustomPadding.defaultSpace),
              // Tile showing Information if User has debts or credits left
              OverviewDebtsTile(),
              Gap(CustomPadding.defaultSpace),
              Text(AppTexts.history, style: TextStyles.regularStyleMedium),
              TransactionHistoryList()
            ],
          ),
        ),
      ),
    );
  }
}
