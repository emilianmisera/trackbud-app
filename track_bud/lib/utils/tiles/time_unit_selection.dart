import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/strings.dart';

/// Widget for selecting a time unit
/// day, week, month or year
class SelectTimeUnit extends StatefulWidget {
  final Function(int?) onValueChanged;
  const SelectTimeUnit({super.key, required this.onValueChanged});

  @override
  State<SelectTimeUnit> createState() => _SelectTimeUnitState();
}

class _SelectTimeUnitState extends State<SelectTimeUnit> {
  // default is set to month
  int? _sliding = 1;

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return CustomShadow(
      child: SizedBox(
        width: double.infinity,
        child: CupertinoSlidingSegmentedControl(
          children: {
            // Expense segment
            0: Container(
              height: 28,
              alignment: Alignment.center,
              child: Text(AppTexts.day,
                  // Applies different styles based on selection state
                  style: _sliding == 0
                      ? TextStyles.slidingTimeUnitStyleSelected.copyWith(color: defaultColorScheme.primary)
                      : TextStyles.slidingTimeUnitStyleDefault.copyWith(color: defaultColorScheme.secondary)),
            ),
            //TODO: Remove
            /*
            1: Container(
              height: 28,
              alignment: Alignment.center,
              child: Text(AppTexts.week,
                  style: _sliding == 1
                      ? TextStyles.slidingTimeUnitStyleSelected
                          .copyWith(color: defaultColorScheme.primary)
                      : TextStyles.slidingTimeUnitStyleDefault
                          .copyWith(color: defaultColorScheme.secondary)),
            ),
            */
            1: Container(
              height: 28,
              alignment: Alignment.center,
              child: Text(AppTexts.month,
                  style: _sliding == 1
                      ? TextStyles.slidingTimeUnitStyleSelected.copyWith(color: defaultColorScheme.primary)
                      : TextStyles.slidingTimeUnitStyleDefault.copyWith(color: defaultColorScheme.secondary)),
            ),
            2: Container(
              height: 28,
              alignment: Alignment.center,
              child: Text(AppTexts.year,
                  style: _sliding == 2
                      ? TextStyles.slidingTimeUnitStyleSelected.copyWith(color: defaultColorScheme.primary)
                      : TextStyles.slidingTimeUnitStyleDefault),
            ),
          },
          groupValue: _sliding, // Current selection
          onValueChanged: (int? newValue) {
            setState(() {
              _sliding = newValue;
            });
            widget.onValueChanged(newValue);
          },
          backgroundColor: defaultColorScheme.onSurface,
        ),
      ),
    );
  }
}
