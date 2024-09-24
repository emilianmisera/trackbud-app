import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';

class WeekChart extends StatefulWidget {
  final List<double> expenses;
  const WeekChart({super.key, required this.expenses});

  @override
  State<WeekChart> createState() => _WeekChartState();
}

class _WeekChartState extends State<WeekChart> with SingleTickerProviderStateMixin {
  final List<String> days = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  // Get the current day of the week (0-6, where 0 is Monday)
  int get _currentDayOfWeek => DateTime.now().weekday - 1;

  // Get expenses for a week
  List<double> _getWeekExpenses() {
    // Return the first 7 expenses if available, otherwise fill with zeros
    return widget.expenses.length >= 7 ? widget.expenses.sublist(0, 7) : List.filled(7, 0.0);
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Create height animation
    _heightAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final List<double> weekExpenses = _getWeekExpenses();
    double maxExpense = weekExpenses.reduce((a, b) => a > b ? a : b);
    final defaultColorScheme = Theme.of(context).colorScheme;

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
                color: defaultColorScheme.outline,
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
            const Gap(CustomPadding.smallSpace),
            Text(
              days[index],
              style: TextStyles.hintStyleDefault.copyWith(
                fontSize: TextStyles.fontSizeHint,
                color: isCurrentDay ? CustomColor.bluePrimary : null,
              ),
            ),
            // Blue circle indicator for current day
            if (isCurrentDay)
              Container(
                height: 10,
                width: 10,
                decoration: const BoxDecoration(
                  color: CustomColor.bluePrimary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        );
      }),
    );
  }
}
