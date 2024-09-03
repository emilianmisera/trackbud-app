
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/strings.dart';


// Widget for displaying a locked email field
class LockedEmailTextfield extends StatelessWidget {
  final String email;
  const LockedEmailTextfield({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email label
        Text(
          AppTexts.email,
          style: TextStyles.regularStyleMedium,
        ),
        Gap(
          CustomPadding.mediumSpace,
        ),
        // Custom shadow container for email display
        CustomShadow(
          child: Container(
            width: double.infinity,
            height: 65,
            padding: EdgeInsets.only(
              left: CustomPadding.defaultSpace,
              right: CustomPadding.defaultSpace,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: CustomColor.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Display the email
                Text(
                  email,
                  style: TextStyles.hintStyleDefault,
                ),
                // Lock icon to indicate the field is not editable
                SvgPicture.asset(AssetImport.lock)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
