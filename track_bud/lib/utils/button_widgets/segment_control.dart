import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/enum/debts_box.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/strings.dart';

/// This Widget is used in AddTransaction
/// You have to choose between Income or Outcome
class CustomSegmentControl extends StatefulWidget {
  final Function(int?) onValueChanged; // callback
  const CustomSegmentControl({
    super.key,
    required this.onValueChanged,
  });

  @override
  State<CustomSegmentControl> createState() => _CustomSegmentControlState();
}

class _CustomSegmentControlState extends State<CustomSegmentControl> {
  // Tracks the currently selected segment (0 for expense, 1 for income)
  int? _sliding = 0;

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return CustomShadow(
      child: SizedBox(
        width: double.infinity,
        child: CupertinoSlidingSegmentedControl(
          thumbColor: _sliding == 0 ? DebtsColorScheme.red.getColor(context) : DebtsColorScheme.green.getColor(context),
          children: {
            // Expense segment
            0: Container(
              height: MediaQuery.sizeOf(context).height * Constants.segmentedControlHeight,
              alignment: Alignment.center,
              child: Text(AppTexts.expense,
                  // Applies different styles based on selection state
                  style: _sliding == 0 ? TextStyles.slidingStyleExpense : TextStyles.slidingStyleDefault),
            ),
            // Income segment
            1: Container(
              height: MediaQuery.sizeOf(context).height * Constants.segmentedControlHeight,
              alignment: Alignment.center,
              child: Text(AppTexts.income, style: _sliding == 1 ? TextStyles.slidingStyleIncome : TextStyles.slidingStyleDefault),
            ),
          },
          // Current selection
          groupValue: _sliding,
          onValueChanged: (int? newValue) {
            setState(() {
              // update user selection
              _sliding = newValue;
            });
            widget.onValueChanged(newValue); // Call the callback
          },
          backgroundColor: defaultColorScheme.surface,
        ),
      ),
    );
  }
}
