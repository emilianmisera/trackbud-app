import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/plus_button/split/split_methods/by_amount/by_amount_tile.dart';
import 'package:track_bud/utils/constants.dart';

class ByAmountSplitWidget extends StatefulWidget {
  final List<UserModel> users;
  final ValueChanged<List<double>> onAmountsChanged;

  const ByAmountSplitWidget(
      {super.key, required this.users, required this.onAmountsChanged});

  @override
  State<ByAmountSplitWidget> createState() => _ByAmountSplitWidgetState();
}

class _ByAmountSplitWidgetState extends State<ByAmountSplitWidget> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(widget.users.length, (_) => TextEditingController());
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
    return _controllers
        .map((controller) => double.tryParse(controller.text) ?? 0.0)
        .toList();
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
      separatorBuilder: (context, index) =>
          const Gap(CustomPadding.mediumSpace),
      itemBuilder: (context, index) {
        return ByAmountTile(
          user: widget.users[index],
          controller: _controllers[index],
          onAmountChanged: (value) {
            // No need to call setState here as the controller listener will handle it
            _onAmountChanged();
          },
        );
      },
    );
  }
}
