import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/plus_button/split/split_methods/percent/percent_tile.dart';
import 'package:track_bud/utils/constants.dart';

class PercentalSplitWidget extends StatefulWidget {
  final double amount;
  final List<UserModel> users;
  final ValueChanged<List<double>> onAmountsChanged;

  const PercentalSplitWidget({
    super.key,
    required this.amount,
    required this.users,
    required this.onAmountsChanged,
  });

  @override
  State<PercentalSplitWidget> createState() => _PercentalSplitWidgetState();
}

class _PercentalSplitWidgetState extends State<PercentalSplitWidget> {
  late List<double> _sliderValues;

  @override
  void initState() {
    super.initState();
    _sliderValues = List.filled(widget.users.length, 100 / widget.users.length);
    _updateAmounts();
  }

  void updateSlider(int index, double value) {
    setState(() {
      if (widget.users.length == 2) {
        _sliderValues[index] = value;
        _sliderValues[1 - index] = 100 - value;
      } else {
        // For more than 2 users, adjust all sliders proportionally
        double totalOthers =
            _sliderValues.reduce((a, b) => a + b) - _sliderValues[index];
        double newTotal = totalOthers + value;
        double factor = 100 / newTotal;

        for (int i = 0; i < _sliderValues.length; i++) {
          if (i == index) {
            _sliderValues[i] = value * factor;
          } else {
            _sliderValues[i] = _sliderValues[i] * factor;
          }
        }
      }
      _updateAmounts();
    });
  }

  void _updateAmounts() {
    // Defer the state update to the next frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final amounts = calculateAmounts(widget.amount);
      widget.onAmountsChanged(amounts);
    });
  }

  List<double> calculateAmounts(double totalAmount) {
    return _sliderValues
        .map((percentage) => (totalAmount * (percentage / 100)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.users.length,
      separatorBuilder: (context, index) =>
          const Gap(CustomPadding.mediumSpace),
      itemBuilder: (context, index) {
        return PercentTile(
          amount: widget.amount,
          user: widget.users[index],
          sliderValue: _sliderValues[index],
          onChanged: (value) => updateSlider(index, value),
        );
      },
    );
  }
}
