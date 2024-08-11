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
        padding: EdgeInsets.only(bottom: CustomPadding.bottomSpace, left: CustomPadding.defaultSpace, right: CustomPadding.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(AssetImport.textLogo),
            SizedBox(
              height: CustomPadding.defaultSpace,
            ),
            Text(
              AppString.onboardingTitle,
              style: CustomTextStyle.introductionStyle,
            ),
            SizedBox(
              height: CustomPadding.mediumSpace,
            ),
            Text(
              AppString.onboardingDescribtion,
              style: CustomTextStyle.regularStyleDefault,
            ),
            SizedBox(
              height: CustomPadding.defaultSpace,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                AppString.signIn,
              ),
            ),
            SizedBox(
              height: CustomPadding.mediumSpace,
            ),
            OutlinedButton(
              onPressed: () {},
              child: Text(
                AppString.signUp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
