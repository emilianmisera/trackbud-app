import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/views/at_signup/login_screen.dart';

/// This Screen will be the first when you open the app for the first time
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.sizeOf(context).height * CustomPadding.bottomSpace,
            left: CustomPadding.defaultSpace,
            right: CustomPadding.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(isDarkMode ? AssetImport.textLogoDarkMode : AssetImport.textLogoLightMode),
            const Gap(CustomPadding.defaultSpace),
            Text(AppTexts.onboardingTitle, style: TextStyles.introductionStyle.copyWith(color: defaultColorScheme.primary)),
            const Gap(CustomPadding.mediumSpace),
            Text(AppTexts.onboardingDescription, style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
            const Gap(CustomPadding.defaultSpace),
            //sign in button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
              child: Text(AppTexts.start),
            ),
          ],
        ),
      ),
    );
  }
}
