import 'package:flutter/material.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';

// Widget for displaying percentage split tile
class PercentTile extends StatelessWidget {
  // Total amount to be split
  final double amount;
  // Name of the person (null for 'Du')
  final UserModel user; // Add this  // Current value of the slider (percentage)
  final double sliderValue;
  // Callback function when slider value changes
  final Function(double) onChanged;

  const PercentTile({
    super.key,
    required this.amount,
    required this.user,
    required this.sliderValue,
    required this.onChanged,
  });

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
            contentPadding:
                const EdgeInsets.only(left: CustomPadding.defaultSpace),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: SizedBox(
                width: 40,
                height: 40,
                // Use profilePictureUrl from UserModel
                child: user.profilePictureUrl.isNotEmpty
                    ? Image.network(user.profilePictureUrl, fit: BoxFit.cover)
                    : const Icon(Icons.person, color: Colors.grey),
              ),
            ),
            title: Text(user.name, style: TextStyles.regularStyleMedium),
            subtitle: Text(
                '${sliderValue.round()}% = ${(amount * (sliderValue / 100)).toStringAsFixed(2)}€',
                style: TextStyles.regularStyleDefault
                    .copyWith(fontSize: TextStyles.fontSizeHint)),
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
