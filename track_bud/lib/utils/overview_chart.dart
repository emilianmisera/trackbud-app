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

  Map<String, double> categoryAmounts = {
    'Lebensmittel': 3.0,
    'Drogerie': 2.0,
    'Restaurant': 1.00,
    'Mobilität': 0.0,
    'Shopping': 0.0,
    'Unterkunft': 0.0,
    'Entertainment': 0.0,
    'Geschenk': 0.0,
    'Sonstiges': 0.0,
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
            SizedBox(height: CustomPadding.defaultSpace),
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
            SizedBox(height: CustomPadding.mediumSpace),
            // Display overview of transactions by category
            TransactionOverview(
              isOverview: true,
              categoryAmounts: categoryAmounts,
            ),
            SizedBox(height: CustomPadding.defaultSpace),
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

  // Get the current day of the week (0-6, where 0 is Monday)
  int get _currentDayOfWeek => DateTime.now().weekday - 1;

  // Get the current day of the month (1-31)
  int get _currentDayOfMonth => DateTime.now().day - 1;

  // Get the current month (0-11)
  int get _currentMonth => DateTime.now().month - 1;

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
    if (oldWidget.currentTimeUnit != widget.currentTimeUnit || oldWidget.expenses != widget.expenses) {
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

  Widget _buildWeekChart() {
    final List<String> days = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
    final List<double> weekExpenses = _getWeekExpenses();
    double maxExpense = weekExpenses.reduce((a, b) => a > b ? a : b);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        bool isCurrentDay = index == _currentDayOfWeek;
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
            Text(
              days[index],
              style: TextStyles.hintStyleDefault.copyWith(
                fontSize: 14,
                color: isCurrentDay ? CustomColor.bluePrimary : null,
              ),
            ),
            // Blue circle indicator for current day
            if (isCurrentDay)
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: CustomColor.bluePrimary,
                  shape: BoxShape.circle,
                ),
              ),
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
          bool isCurrentDay = index == _currentDayOfMonth;
          return Column(
            children: [
              Container(
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
              ),
              SizedBox(height: 4),
              // Blue circle indicator for current day
              if (isCurrentDay)
                Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: CustomColor.bluePrimary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
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
        bool isCurrentMonth = index == _currentMonth;
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
                    return Container(
                      width: 20,
                      height: maxExpense > 0 ? (yearExpenses[index] / maxExpense) * 75 * _heightAnimation.value : 0,
                      decoration: BoxDecoration(
                        color: yearExpenses[index] > widget.budgetGoal ? CustomColor.red : CustomColor.bluePrimary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(
              months[index],
              style: TextStyles.hintStyleDefault.copyWith(
                fontSize: 13,
                color: isCurrentMonth ? CustomColor.bluePrimary : null,
              ),
            ),
            // Blue circle indicator for current month
            if (isCurrentMonth)
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: CustomColor.bluePrimary,
                  shape: BoxShape.circle,
                ),
              ),
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
