import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/provider/user_provider.dart';
import 'package:track_bud/provider/transaction_provider.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/overview/monthly_expense.dart';
import 'package:track_bud/utils/overview/chart/overview_chart.dart';
import 'package:track_bud/utils/overview/debts.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/widgets/transaction_list.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Using context.read to access providers without listening for changes
      final userProvider = context.read<UserProvider>();
      final transactionProvider = context.read<TransactionProvider>();

      userProvider.loadCurrentUser();
      transactionProvider.initializeBalance();
      transactionProvider.calculateTotalExpenseForCurrentMonth();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * CustomPadding.topSpace,
          left: CustomPadding.defaultSpace,
          right: CustomPadding.defaultSpace,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ExpensesOverviewTile(),
            const Gap(CustomPadding.defaultSpace),
            const MonthlyExpenseTile(),
            const Gap(CustomPadding.defaultSpace),
            const OverviewDebtsTile(),
            const Gap(CustomPadding.defaultSpace),
            Text(AppTexts.history, style: TextStyles.regularStyleMedium),
            const Gap(CustomPadding.mediumSpace),
            const TransactionHistoryList(transactionType: 'expense')
          ],
        ),
      ),
    );
  }
}
