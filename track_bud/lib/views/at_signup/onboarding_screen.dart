import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/views/at_signup/login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        //Padding for space between Screen
        padding: EdgeInsets.only(
            bottom:
                MediaQuery.sizeOf(context).height * CustomPadding.bottomSpace,
            left: CustomPadding.defaultSpace,
            right: CustomPadding.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end, //alignment to bottom
          crossAxisAlignment: CrossAxisAlignment.start, //alignment to left
          children: [
            SvgPicture.asset(AssetImport.textLogo),
            const Gap(
              CustomPadding.defaultSpace,
            ),
            Text(
              AppTexts.onboardingTitle,
              style: TextStyles.introductionStyle,
            ),
            const Gap(
              CustomPadding.mediumSpace,
            ),
            Text(
              AppTexts.onboardingDescription,
              style: TextStyles.regularStyleDefault,
            ),
            const Gap(
              CustomPadding.defaultSpace,
            ),
            ElevatedButton(
              //sign in button
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
              child: Text(
                AppTexts.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
