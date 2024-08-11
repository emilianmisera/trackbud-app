import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: CustomPadding.screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: CustomPadding.defaultHeightSpace,
              child: SvgPicture.asset(AssetImport.textLogo),
            ),
            Padding(
              padding: CustomPadding.defaultHeightSpace,
              child: Text(
                AppString.onboardingTitle,
                style: CustomTextStyle.introductionStyle,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: CustomPadding.mediumSpace),
              child: Text(
                AppString.onboardingDescribtion,
                style: CustomTextStyle.regularStyleDefault,
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
