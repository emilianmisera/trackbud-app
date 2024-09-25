import 'package:flutter/material.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';

class EqualGroupTile extends StatefulWidget {
  final UserModel user;
  final double splitAmount;
  final VoidCallback onToggle;
  final bool isSelected; // Add isSelected here

  const EqualGroupTile({
    super.key,
    required this.user,
    required this.splitAmount,
    required this.onToggle,
    required this.isSelected, // Add isSelected here
  });

  @override
  // ignore: library_private_types_in_public_api
  _EqualGroupTileState createState() => _EqualGroupTileState();
}

class _EqualGroupTileState extends State<EqualGroupTile> {
  late bool _isSelected; // Each tile now has its own independent state

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected; // Initialize with the passed state
  }

  void _toggleSelection() {
    setState(() {
      _isSelected = !_isSelected; // Toggle the local state
      debugPrint(
          'Toggled selection for user: ${widget.user.userId}, isSelected: $_isSelected'); // Debug print
    });
    widget.onToggle(); // Notify the parent (if necessary)
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;

    return CustomShadow(
      child: Container(
        decoration: BoxDecoration(
          color: _isSelected
              ? defaultColorScheme.outline
              : defaultColorScheme.surface,
          borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: CustomPadding.defaultSpace,
            vertical: CustomPadding.defaultSpace,
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: SizedBox(
              width: 40,
              height: 40,
              child: widget.user.profilePictureUrl.isNotEmpty
                  ? Image.network(widget.user.profilePictureUrl,
                      fit: BoxFit.cover)
                  : const Icon(Icons.person, size: 30),
            ),
          ),
          title: Text(
            widget.user.name,
            style: TextStyles.regularStyleDefault
                .copyWith(color: defaultColorScheme.primary),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: defaultColorScheme.surface,
                  borderRadius:
                      BorderRadius.circular(Constants.contentBorderRadius),
                  border: Border.all(color: defaultColorScheme.outline),
                ),
                child: Text(
                  '${widget.splitAmount.toStringAsFixed(2)}€',
                  style: TextStyles.hintStyleDefault
                      .copyWith(color: defaultColorScheme.secondary),
                ),
              ),
              const SizedBox(width: 10),
              Switch(
                value: _isSelected,
                onChanged: (value) {
                  _toggleSelection();
                },
                activeColor: defaultColorScheme.primary,
              ),
            ],
          ),
          onTap: _toggleSelection,
        ),
      ),
    );
  }
}