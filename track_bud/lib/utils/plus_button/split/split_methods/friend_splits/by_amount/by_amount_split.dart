import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/plus_button/split/split_methods/friend_splits/by_amount/by_amount_tile.dart';
import 'package:track_bud/utils/constants.dart';

/// This widget is part of the "Split" feature, which allows the user to manually
/// enter the exact amount of a split for each friend.
/// It's especially useful when dividing costs in a group, where each person
/// might pay a different amount.
class ByAmountSplitWidget extends StatefulWidget {
  // List of users that will be part of the split.
  final List<UserModel> users;
  // Callback to inform the parent widget when the entered amounts are updated.
  final ValueChanged<List<double>> onAmountsChanged;
  // Boolean flag to determine whether this is a group split or not
  final bool isGroup;
  final List<FocusNode> focusNodes;

  const ByAmountSplitWidget(
      {super.key, required this.users, required this.onAmountsChanged, this.isGroup = false, required this.focusNodes});

  @override
  State<ByAmountSplitWidget> createState() => _ByAmountSplitWidgetState();
}

class _ByAmountSplitWidgetState extends State<ByAmountSplitWidget> {
  // List of TextEditingControllers to manage the input for each user's amount.
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    // Generate a TextEditingController for each user to manage the input amounts.
    _controllers = List.generate(widget.users.length, (_) => TextEditingController());
    // Add a listener to each controller to handle changes in input and update the state.
    for (var controller in _controllers) {
      controller.addListener(_onAmountChanged);
    }
  }

  @override
  void dispose() {
    // Clean up: Remove listeners and dispose of the controllers to prevent memory leaks.
    for (var controller in _controllers) {
      controller.removeListener(_onAmountChanged);
      controller.dispose();
    }
    super.dispose();
  }

  /// Retrieves the current amounts entered for each user.
  /// If the input is not a valid number, it defaults to 0.0.
  /// This method also handles the case where users may input numbers with commas instead of dots.
  List<double> getAmounts() {
    return _controllers.map((controller) => double.tryParse(controller.text.replaceAll(',', '.')) ?? 0.0).toList();
  }

  /// Listener method that is called whenever any amount input is changed.
  /// It triggers the onAmountsChanged callback with the updated list of amounts.
  void _onAmountChanged() {
    widget.onAmountsChanged(getAmounts());
  }

  @override
  Widget build(BuildContext context) {
    // Build a list of ByAmountTile widgets for each user.
    // Each tile allows entering a specific amount for the corresponding user.
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.users.length,
      separatorBuilder: (context, index) => const Gap(CustomPadding.mediumSpace),
      itemBuilder: (context, index) {
        return ByAmountTile(
          user: widget.users[index],
          controller: _controllers[index],
          onAmountChanged: (value) {
            _onAmountChanged();
          },
          focusNode: widget.focusNodes[index],
        );
      },
    );
  }
}
