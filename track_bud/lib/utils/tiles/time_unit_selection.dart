import 'package:flutter/cupertino.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/strings.dart';

class SelectTimeUnit extends StatefulWidget {
  final Function(int?) onValueChanged; // callback
  const SelectTimeUnit({
    super.key,
    required this.onValueChanged,
  });

  @override
  State<SelectTimeUnit> createState() => _SelectTimeUnitState();
}

class _SelectTimeUnitState extends State<SelectTimeUnit> {
  // _sliding: Tracks the currently selected segment (0 for expense, 1 for income)
  int? _sliding = 1;

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: SizedBox(
        width: double.infinity, // Ensures the control spans the full width
        child: CupertinoSlidingSegmentedControl(
          children: {
            // Expense segment
            0: Container(
              // Sets the height of the segment relative to screen height
              height: 28,
              alignment: Alignment.center,
              child: Text(AppTexts.day,
                  // Applies different styles based on selection state
                  style: _sliding == 0 ? TextStyles.slidingTimeUnitStyleSelected : TextStyles.slidingTimeUnitStyleDefault),
            ),
            // Income segment
            1: Container(
              height: 28,
              alignment: Alignment.center,
              child: Text(AppTexts.week,
                  style: _sliding == 1 ? TextStyles.slidingTimeUnitStyleSelected : TextStyles.slidingTimeUnitStyleDefault),
            ),
            2: Container(
              height: 28,
              alignment: Alignment.center,
              child: Text(AppTexts.month,
                  style: _sliding == 2 ? TextStyles.slidingTimeUnitStyleSelected : TextStyles.slidingTimeUnitStyleDefault),
            ),
            3: Container(
              height: 28,
              alignment: Alignment.center,
              child: Text(AppTexts.year,
                  style: _sliding == 3 ? TextStyles.slidingTimeUnitStyleSelected : TextStyles.slidingTimeUnitStyleDefault),
            ),
          },
          groupValue: _sliding, // Current selection
          onValueChanged: (int? newValue) {
            setState(() {
              _sliding = newValue;
            });
            widget.onValueChanged(newValue); // Call the callback
          },
          backgroundColor: CustomColor.white, // Background color of the control
        ),
      ),
    );
  }
}
