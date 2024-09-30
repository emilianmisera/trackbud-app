import 'package:flutter/material.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';

/// This Widget displays a single Percent Tile for the PercentalSplitWidget
class PercentTile extends StatefulWidget {
  final double amount;
  final UserModel user;
  final double sliderValue;
  final Function(double) onChanged;
  final bool isGroup;

  const PercentTile(
      {super.key, required this.amount, required this.user, required this.sliderValue, required this.onChanged, required this.isGroup});

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
                borderRadius: BorderRadius.circular(Constants.roundedCorners),
                child: SizedBox(
                  width: Constants.addGroupPPSize,
                  height: Constants.addGroupPPSize,
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
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: CustomColor.bluePrimary,
                inactiveTrackColor: defaultColorScheme.outline,
                thumbColor: CustomColor.bluePrimary,
                overlayColor: CustomColor.bluePrimary.withOpacity(0.3),
                valueIndicatorColor: CustomColor.bluePrimary,
                activeTickMarkColor: CustomColor.bluePrimary,
                inactiveTickMarkColor: defaultColorScheme.secondary.withOpacity(0.5),
              ),
              child: Slider(onChanged: widget.onChanged, max: 100.00, divisions: 20, value: widget.sliderValue),
            )
          ],
        ),
      ),
    );
  }
}
