import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/strings.dart';

/// Widget for displaying a locked email field
class LockedEmailTextfield extends StatelessWidget {
  final String email;
  const LockedEmailTextfield({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email label
        Text(AppTexts.email, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
        const Gap(CustomPadding.mediumSpace),
        CustomShadow(
          child: Container(
            width: double.infinity,
            height: 65,
            padding: const EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(Constants.contentBorderRadius)), color: defaultColorScheme.surface),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Display the email
                Text(email, style: TextStyles.hintStyleDefault.copyWith(color: defaultColorScheme.secondary)),
                // Lock icon to indicate the field is not editable
                SvgPicture.asset(AssetImport.lock, colorFilter: ColorFilter.mode(defaultColorScheme.secondary, BlendMode.srcIn))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
