import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/enum/categories.dart';
import 'package:track_bud/utils/debts/group_debts_chart.dart';
import 'package:track_bud/utils/overview/chart/expenses_chart.dart';
import 'package:track_bud/utils/textfield_widgets.dart';
import 'package:track_bud/utils/tiles/time_unit_selection.dart';

// Main widget for displaying the expenses overview
class ExpensesOverviewTile extends StatefulWidget {
  const ExpensesOverviewTile({super.key});

  @override
  State<ExpensesOverviewTile> createState() => _ExpensesOverviewTileState();
}

class _ExpensesOverviewTileState extends State<ExpensesOverviewTile> {
  int _currentTimeUnit = 1;

  late List<double> _dailyExpenses;
  late List<double> _weeklyExpenses;
  late List<double> _monthlyExpenses;
  late List<double> _yearlyExpenses;

  @override
  void initState() {
    super.initState();
    _initializeExpenses();
  }

  void _initializeExpenses() {
    _dailyExpenses = [100.00];
    _weeklyExpenses = [100.00, 50.00, 20.00, 0.00, 0.00, 0, 0];
    _monthlyExpenses = List.generate(31, (index) => index < 7 ? _weeklyExpenses[index] : 0);
    _yearlyExpenses = List.generate(12, (index) => index == 0 ? _weeklyExpenses.reduce((a, b) => a + b) : 0);
  }

  Map<Categories, double> categoryAmounts = {
    Categories.lebensmittel: 3.0,
    Categories.drogerie: 2.0,
    Categories.restaurant: 1.00,
    Categories.mobility: 0.0,
    Categories.shopping: 0.0,
    Categories.unterkunft: 0.0,
    Categories.entertainment: 0.0,
    Categories.geschenk: 0.0,
    Categories.sonstiges: 0.0,
  };

  List<double> _getCurrentExpenses() {
    switch (_currentTimeUnit) {
      case 0:
        return _dailyExpenses;
      case 1:
        return _weeklyExpenses;
      case 2:
        return _monthlyExpenses;
      case 3:
        return _yearlyExpenses;
      default:
        return _weeklyExpenses;
    }
  }

  String _getTimeUnitText() {
    switch (_currentTimeUnit) {
      case 0:
        return 'Heute';
      case 1:
        return 'Diese Woche';
      case 2:
        return 'Dieser Monat';
      case 3:
        return 'Dieses Jahr';
      default:
        return 'Diese Woche';
    }
  }

  double _calculateTotalExpenses() {
    return categoryAmounts.values.reduce((a, b) => a + b);
  }

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        padding: EdgeInsets.all(CustomPadding.defaultSpace),
        decoration: BoxDecoration(
          color: CustomColor.white,
          borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // select time unit
            SelectTimeUnit(
              onValueChanged: (int? newValue) {
                setState(() {
                  _currentTimeUnit = newValue ?? 1;
                });
              },
            ),
            Gap(CustomPadding.defaultSpace),
            // Display current time period and total expense
            Row(
              children: [
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: CustomColor.hintColor,
                  size: 15,
                ),
                Text(
                  _getTimeUnitText(),
                  style: TextStyles.hintStyleDefault,
                ),
              ],
            ),
            Text(
              '${_calculateTotalExpenses().toStringAsFixed(2)}',
              style: TextStyles.headingStyle,
            ),
            Gap(CustomPadding.mediumSpace),
            // Display overview of transactions by category
            TransactionOverview(
              isOverview: true,
              categoryAmounts: categoryAmounts,
            ),
            Gap(CustomPadding.defaultSpace),
            // Display animated expenses chart
            ExpensesChart(
              currentTimeUnit: _currentTimeUnit,
              expenses: _getCurrentExpenses(),
            ),
          ],
        ),
      ),
    );
  }
}
