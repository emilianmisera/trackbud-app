import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/plus_button/split/split_button.dart';
import 'package:track_bud/utils/enum/split_methods.dart';
import 'package:track_bud/utils/strings.dart';

/// Widget for selecting the Split Method
class SplitMethodSelector extends StatefulWidget {
  // Callback function to be called when the split method changes
  final ValueChanged<SplitMethod> onSplitMethodChanged;
  // The currently selected split method
  final SplitMethod selectedMethod;

  const SplitMethodSelector({
    super.key,
    required this.onSplitMethodChanged,
    required this.selectedMethod,
  });

  @override
  State<SplitMethodSelector> createState() => _SplitMethodSelectorState();
}

class _SplitMethodSelectorState extends State<SplitMethodSelector> {
  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppTexts.distribution, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
        const Gap(CustomPadding.mediumSpace),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Equal split button
            SplitButton(
              icon: AssetImport.equal,
              text: AppTexts.equal,
              onPressed: () => widget.onSplitMethodChanged(SplitMethod.equal),
              isSelected: widget.selectedMethod == SplitMethod.equal,
            ),
            // Percent split button
            SplitButton(
              icon: AssetImport.percent,
              text: AppTexts.percent,
              onPressed: () => widget.onSplitMethodChanged(SplitMethod.percent),
              isSelected: widget.selectedMethod == SplitMethod.percent,
            ),
            // By amount split button
            SplitButton(
              icon: AssetImport.byAmount,
              text: AppTexts.byAmount,
              onPressed: () => widget.onSplitMethodChanged(SplitMethod.amount),
              isSelected: widget.selectedMethod == SplitMethod.amount,
            ),
          ],
        ),
      ],
    );
  }
}
