import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/plus_button/split/split_methods/percent/percent_tile.dart';
import 'package:track_bud/utils/constants.dart';

/// Widget for displaying percentage split for multiple people
class PercentalSplitWidget extends StatefulWidget {
  // Total amount to be split
  final double amount;
  // List of names of people involved in the split
final List<UserModel> users; // Change to List<UserModel>

  const PercentalSplitWidget({
    super.key,
    required this.amount,
    required this.users,
  });

  @override
  State<PercentalSplitWidget> createState() => _PercentalSplitWidgetState();
}

class _PercentalSplitWidgetState extends State<PercentalSplitWidget> {
  // List to store slider values for each person
  late List<double> _sliderValues;

  @override
  void initState() {
    super.initState();
    // Initialize slider values equally among all people
    _sliderValues = List.filled(widget.users.length, 100 / widget.users.length);
  }

  // Method to update slider values
  void updateSlider(int index, double value) {
    setState(() {
      if (widget.users.length == 2) {
        // For two people: automatic adjustment
        _sliderValues[index] = value;
        _sliderValues[1 - index] = 100 - value;
      } else {
        // For three or more people: independent sliders
        _sliderValues[index] = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.users.length,
      separatorBuilder: (context, index) => const Gap(CustomPadding.mediumSpace),
      itemBuilder: (context, index) {
        return PercentTile(
          amount: widget.amount,
          user: widget.users[index], // Pass the UserModel
          sliderValue: _sliderValues[index],
          onChanged: (value) => updateSlider(index, value),
        );
      },
    );
  }
}