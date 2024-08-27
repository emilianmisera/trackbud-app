import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/date_picker.dart';
import 'package:track_bud/utils/group_debts_chart.dart';
import 'package:track_bud/utils/textfield_widget.dart';

// Main widget for displaying the expenses overview
class ExpensesOverview extends StatefulWidget {
  const ExpensesOverview({super.key});

  @override
  State<ExpensesOverview> createState() => _ExpensesOverviewState();
}

class _ExpensesOverviewState extends State<ExpensesOverview> {
  // Current time unit selected (0: Day, 1: Week, 2: Month, 3: Year)
  int _currentTimeUnit = 1;
  
  // Sample expense data for a week
  List<double> _expenses = [100.00, 50.00, 20.00, 0.00, 0.00, 0, 0];

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        padding: EdgeInsets.all(CustomPadding.defaultSpace),
        decoration: BoxDecoration(
          color: CustomColor.white,
          borderRadius: BorderRadius.circular(Constants.buttonBorderRadius),
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
            SizedBox(height: CustomPadding.defaultSpace),
            // Display current time period and total expense
            Row(
              children: [
                Icon(Icons.arrow_back_ios_new_rounded, color: CustomColor.hintColor, size: 15,),
                Text('Diese Woche', style: CustomTextStyle.hintStyleDefault,),
              ],
            ),
            Text('50,00', style: CustomTextStyle.headingStyle,),
            SizedBox(height: CustomPadding.mediumSpace),
            // Display overview of transactions by category
            TransactionOverview(
              isOverview: true,
              categoryAmounts: {
                'Lebensmittel': 3.0,
                'Drogerie': 2.0,
                'Restaurant': 1.00,
                'Mobilität': 0.0,
                'Shopping': 0.0,
                'Unterkunft': 0.0,
                'Entertainment': 0.0,
                'Geschenk': 0.0,
                'Sonstiges': 0.0,
              },
            ),
            SizedBox(height: CustomPadding.defaultSpace),
            // Display animated expenses chart
            ExpensesChart(
              currentTimeUnit: _currentTimeUnit,
              expenses: _expenses,
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for displaying an animated chart of expenses
class ExpensesChart extends StatefulWidget {
  final int currentTimeUnit;
  final List<double> expenses;
  final double budgetGoal;

  const ExpensesChart({
    Key? key,
    required this.currentTimeUnit,
    required this.expenses,
    this.budgetGoal = 400.00,
  }) : super(key: key);

  @override
  _ExpensesChartState createState() => _ExpensesChartState();
}

class _ExpensesChartState extends State<ExpensesChart> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    // Create height animation
    _heightAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _startAnimation();
  }

  @override
  void didUpdateWidget(ExpensesChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Restart animation if time unit or expenses change
    if (oldWidget.currentTimeUnit != widget.currentTimeUnit ||
        oldWidget.expenses != widget.expenses) {
      _startAnimation();
    }
  }

  // Start or restart the animation
  void _startAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build appropriate chart based on current time unit
    switch (widget.currentTimeUnit) {
      case 0:
        return SizedBox(); // Day view, show nothing
      case 1:
        return _buildWeekChart();
      case 2:
        return _buildMonthChart();
      case 3:
        return _buildYearChart();
      default:
        return SizedBox();
    }
  }

  // Build chart for weekly expenses
  Widget _buildWeekChart() {
    final List<String> days = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
    final List<double> weekExpenses = _getWeekExpenses();
    double maxExpense = weekExpenses.reduce((a, b) => a > b ? a : b);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        return Column(
          children: [
            Container(
              height: 75,
              width: 30,
              decoration: BoxDecoration(
                color: CustomColor.grey,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedBuilder(
                  animation: _heightAnimation,
                  builder: (context, child) {
                    // Animate the height of each bar
                    return Container(
                      width: 30,
                      height: maxExpense > 0 ? (weekExpenses[index] / maxExpense) * 75 * _heightAnimation.value : 0,
                      decoration: BoxDecoration(
                        color: CustomColor.bluePrimary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(days[index], style: CustomTextStyle.hintStyleDefault.copyWith(fontSize: 14),),
          ],
        );
      }),
    );
  }

  // Build chart for monthly expenses
  Widget _buildMonthChart() {
    int daysInMonth = 31;
    final List<double> monthExpenses = _getMonthExpenses();
    double maxExpense = monthExpenses.reduce((a, b) => a > b ? a : b);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(daysInMonth, (index) {
          return Container(
            height: 75,
            width: 8,
            margin: EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: CustomColor.grey,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedBuilder(
                animation: _heightAnimation,
                builder: (context, child) {
                  // Animate the height of each bar
                  return Container(
                    width: 8,
                    height: maxExpense > 0 ? (monthExpenses[index] / maxExpense) * 75 * _heightAnimation.value : 0,
                    decoration: BoxDecoration(
                      color: CustomColor.bluePrimary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }

  // Build chart for yearly expenses
  Widget _buildYearChart() {
    final List<String> months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
    final List<double> yearExpenses = _getYearExpenses();
    double maxExpense = yearExpenses.reduce((a, b) => a > b ? a : b);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(12, (index) {
        return Column(
          children: [
            Container(
              height: 75,
              width: 20,
              decoration: BoxDecoration(
                color: CustomColor.grey,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedBuilder(
                  animation: _heightAnimation,
                  builder: (context, child) {
                    // Animate the height of each bar
                    return Container(
                      width: 20,
                      height: maxExpense > 0 ? (yearExpenses[index] / maxExpense) * 75 * _heightAnimation.value : 0,
                      decoration: BoxDecoration(
                        // Color the bar red if expenses exceed budget goal
                        color: yearExpenses[index] > widget.budgetGoal ? CustomColor.red : CustomColor.bluePrimary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(months[index], style: CustomTextStyle.hintStyleDefault.copyWith(fontSize: 13),),
          ],
        );
      }),
    );
  }

  // Get expenses for a week
  List<double> _getWeekExpenses() {
    // Return the first 7 expenses if available, otherwise fill with zeros
    return widget.expenses.length >= 7 ? widget.expenses.sublist(0, 7) : List.filled(7, 0.0);
  }

  // Get expenses for a month
  List<double> _getMonthExpenses() {
    List<double> monthExpenses = List.filled(31, 0.0);
    // Fill with available expenses, leaving the rest as zeros
    for (int i = 0; i < widget.expenses.length && i < 31; i++) {
      monthExpenses[i] = widget.expenses[i];
    }
    return monthExpenses;
  }

  // Get expenses for a year
  List<double> _getYearExpenses() {
    List<double> yearExpenses = List.filled(12, 0.0);
    int weeksInYear = 52;
    // Aggregate weekly expenses into monthly expenses
    for (int i = 0; i < 12; i++) {
      int startWeek = i * 4;
      int endWeek = (i + 1) * 4;
      if (endWeek > weeksInYear) endWeek = weeksInYear;
      for (int j = startWeek * 7; j < endWeek * 7 && j < widget.expenses.length; j++) {
        yearExpenses[i] += widget.expenses[j];
      }
    }
    return yearExpenses;
  }
}