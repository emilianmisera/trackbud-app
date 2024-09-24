import 'package:flutter/material.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';

class PercentTile extends StatefulWidget {
  // Make it stateful
  final double amount;
  final UserModel user;
  final double sliderValue;
  final Function(double) onChanged;
  final bool isGroup;

  const PercentTile({
    super.key,
    required this.amount,
    required this.user,
    required this.sliderValue,
    required this.onChanged,
    required this.isGroup,
  });

  @override
  State<PercentTile> createState() => _PercentTileState();
}

class _PercentTileState extends State<PercentTile> {
  bool _checkBox = false; // State for the checkbox

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return CustomShadow(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
          color: defaultColorScheme.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.only(left: CustomPadding.defaultSpace),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: widget.user.profilePictureUrl.isNotEmpty
                      ? Image.network(widget.user.profilePictureUrl, fit: BoxFit.cover)
                      : const Icon(Icons.person, color: Colors.grey),
                ),
              ),
              title: Text(widget.user.name, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
              subtitle: Text('${widget.sliderValue.round()}% = ${(widget.amount * (widget.sliderValue / 100)).toStringAsFixed(2)}€',
                  style: TextStyles.regularStyleDefault.copyWith(fontSize: TextStyles.fontSizeHint, color: defaultColorScheme.primary)),
              // Conditionally add the checkbox for group splits
              trailing: widget.isGroup
                  ? Checkbox(
                      hoverColor: CustomColor.bluePrimary,
                      checkColor: defaultColorScheme.surface,
                      fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                        return states.contains(WidgetState.selected) ? CustomColor.bluePrimary : defaultColorScheme.surface;
                      }),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      value: _checkBox,
                      onChanged: (value) => setState(() => _checkBox = value!),
                      activeColor: Colors.blueAccent,
                    )
                  : null, // No trailing widget for friend splits
            ),
            Slider(
              onChanged: widget.onChanged,
              max: 100.00,
              divisions: 20,
              value: widget.sliderValue,
              activeColor: CustomColor.bluePrimary,
              inactiveColor: defaultColorScheme.outline,
            )
          ],
        ),
      ),
    );
  }
}
