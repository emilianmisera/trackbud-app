import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/views/at_signup/login_screen.dart';
import 'package:track_bud/views/at_signup/signup_screen.dart';

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
              AppString.onboardingDescription,
              style: CustomTextStyle.regularStyleDefault,
            ),
            SizedBox(
              height: CustomPadding.defaultSpace,
            ),
            ElevatedButton(
              //sign in button
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text(
                AppString.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
