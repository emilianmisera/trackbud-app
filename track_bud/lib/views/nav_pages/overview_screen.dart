import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/provider/user_provider.dart';
import 'package:track_bud/provider/transaction_provider.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/overview/monthly_expense.dart';
import 'package:track_bud/utils/overview/chart/overview_chart.dart';
import 'package:track_bud/utils/overview/overview_debts_chart.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/widgets/transaction_list.dart';

/// This is the Overview Screen (Homepage of App)
/// It is one of the Naviagtion Pages
/// It displays a beautiful and simple summary of Expenses, Debts-Information, Transaction-History
/// and how much money is left to reach the Budget Goal
class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  @override
  void initState() {
    super.initState();
    _initializeProviders();
  }

  /// Initializes the user and transaction providers after the first frame.
  void _initializeProviders() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

      userProvider.loadCurrentUser();
      transactionProvider.initializeBalance();
      transactionProvider.calculateTotalExpenseForCurrentMonth();
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * CustomPadding.topSpace,
            left: CustomPadding.defaultSpace,
            right: CustomPadding.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ExpensesOverviewTile(), // Tile for overall expenses
            const Gap(CustomPadding.defaultSpace),
            const MonthlyExpenseTile(), // Tile for monthly expenses
            const Gap(CustomPadding.defaultSpace),
            const OverviewDebtsTile(), // Tile for overview of debts
            const Gap(CustomPadding.defaultSpace),
            // Title for transaction history
            Text(AppTexts.yourExpenses, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
            const Gap(CustomPadding.mediumSpace),
            const TransactionHistoryList(transactionType: 'expense'), // List for transaction history
          ],
        ),
      ),
    );
  }
}
