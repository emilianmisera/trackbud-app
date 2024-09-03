import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/textfield_widgets.dart';

// Widget for displaying percentage split tile
class PercentTile extends StatelessWidget {
  // Total amount to be split
  final double amount;
  // Name of the person (null for 'Du')
  final String? name;
  // Current value of the slider (percentage)
  final double sliderValue;
  // Callback function when slider value changes
  final Function(double) onChanged;

  const PercentTile({
    Key? key,
    required this.amount,
    this.name,
    required this.sliderValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
        child: Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
        color: CustomColor.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(left: CustomPadding.defaultSpace),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Container(
                width: 40,
                height: 40,
                color: Colors.red, // TODO: Replace with profile picture
              ),
            ),
            title: Text(name ?? 'Du', style: TextStyles.regularStyleMedium),
            subtitle: Text('${sliderValue.round()}% = ${(amount * (sliderValue / 100)).toStringAsFixed(2)}€',
                style: TextStyles.regularStyleDefault.copyWith(fontSize: TextStyles.fontSizeHint)),
          ),
          Slider(
            onChanged: onChanged,
            max: 100.00,
            divisions: 20,
            value: sliderValue,
            activeColor: CustomColor.bluePrimary,
            inactiveColor: CustomColor.grey,
          )
        ],
      ),
    ));
  }
}
