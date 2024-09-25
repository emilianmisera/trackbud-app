import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/plus_button/split/split_methods/group_splits/equal_group_tile.dart';

class EqualGroupSplitWidget extends StatefulWidget {
  final double amount;
  final List<UserModel> users;
  final List<String> selectedMemberIds;
  final ValueChanged<List<String>> onMemberSelectionChanged;

  const EqualGroupSplitWidget({
    super.key,
    required this.amount,
    required this.users,
    required this.selectedMemberIds,
    required this.onMemberSelectionChanged,
  });

  @override
  State<EqualGroupSplitWidget> createState() => _EqualGroupSplitWidgetState();
}

class _EqualGroupSplitWidgetState extends State<EqualGroupSplitWidget> {
  late List<String> _selectedMemberIds; // Keep track of selected members only

  @override
  void initState() {
    super.initState();
    _selectedMemberIds = List.from(widget.users.map((user) => user.userId));
    debugPrint('Initial selected member IDs: $_selectedMemberIds');
  }

  void _onMemberSelectionChanged(String userId) {
    setState(() {
      if (_selectedMemberIds.contains(userId)) {
        _selectedMemberIds.remove(userId); // Unselect the user
        debugPrint('Unselected user ID: $userId');
      } else {
        _selectedMemberIds.add(userId); // Select the user
        debugPrint('Selected user ID: $userId');
      }
      debugPrint(
          'Current selected member IDs: $_selectedMemberIds'); // Debug print
      widget.onMemberSelectionChanged(_selectedMemberIds); // Notify the parent
    });
  }

  double _calculateSplitAmount() {
    int selectedCount = _selectedMemberIds.length;
    double splitAmount =
        selectedCount > 0 ? widget.amount / selectedCount : 0.0;
    debugPrint(
        'Calculated split amount: $splitAmount for selected count: $selectedCount'); // Debug print
    return splitAmount;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Building EqualGroupSplitWidget");
    final splitAmount = _calculateSplitAmount();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.users.length,
      separatorBuilder: (context, index) =>
          const Gap(CustomPadding.mediumSpace),
      itemBuilder: (context, index) {
        final user = widget.users[index];
        final isSelected = _selectedMemberIds.contains(user.userId);

        return EqualGroupTile(
          key: ValueKey(user.userId),
          user: user,
          // Pass the calculated splitAmount only if the user is selected
          splitAmount: isSelected ? splitAmount : 0.0,
          isSelected: isSelected,
          onToggle: () => _onMemberSelectionChanged(user.userId),
        );
      },
    );
  }
}