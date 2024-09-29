import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/plus_button/split/split_methods/friend_splits/by_amount/by_amount_tile.dart';
import 'package:track_bud/utils/constants.dart';

class ByAmountSplitWidget extends StatefulWidget {
  final List<UserModel> users;
  final ValueChanged<List<double>> onAmountsChanged;
  final bool isGroup;
  final List<FocusNode> focusNodes; // New parameter for focus nodes

  const ByAmountSplitWidget({
    super.key,
    required this.users,
    required this.onAmountsChanged,
    this.isGroup = false,
    required this.focusNodes, // Add this line
  });

  @override
  State<ByAmountSplitWidget> createState() => _ByAmountSplitWidgetState();
}

class _ByAmountSplitWidgetState extends State<ByAmountSplitWidget> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.users.length, (_) => TextEditingController());
    for (var controller in _controllers) {
      controller.addListener(_onAmountChanged);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.removeListener(_onAmountChanged);
      controller.dispose();
    }
    super.dispose();
  }

  List<double> getAmounts() {
    return _controllers.map((controller) => double.tryParse(controller.text.replaceAll(',', '.')) ?? 0.0).toList();
  }

  void _onAmountChanged() {
    widget.onAmountsChanged(getAmounts());
  }

  @override
  Widget build(BuildContext context) {
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
          focusNode: widget.focusNodes[index], // Pass the focus node
        );
      },
    );
  }
}
