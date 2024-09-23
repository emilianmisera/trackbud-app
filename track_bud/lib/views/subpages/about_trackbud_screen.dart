import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';

class AboutTrackbudScreen extends StatefulWidget {
  const AboutTrackbudScreen({super.key});

  @override
  State<AboutTrackbudScreen> createState() => _AboutTrackbudScreenState();
}

class _AboutTrackbudScreenState extends State<AboutTrackbudScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace),
        child: Column(
          children: [
            SvgPicture.asset(AssetImport.textLogo),
            const Gap(CustomPadding.bigSpace),
            Text(
              AppTexts.aboutTrackBudText,
              style: TextStyles.regularStyleDefault,
              textAlign: TextAlign.center,
            ),
            const Gap(CustomPadding.bigSpace),
            Text(AppTexts.laurenzEmail, style: TextStyles.hintStyleDefault.copyWith(color: CustomColor.bluePrimary)),
            Text(AppTexts.emilianEmail, style: TextStyles.hintStyleDefault.copyWith(color: CustomColor.bluePrimary)),
            const Gap(CustomPadding.bigSpace),
            Text(AppTexts.madeWithLove, style: TextStyles.regularStyleDefault),
            const Gap(CustomPadding.mediumSpace),
            Text(AppTexts.supportUs, style: TextStyles.regularStyleDefault),
          ],
        ),
      ),
    );
  }
}
