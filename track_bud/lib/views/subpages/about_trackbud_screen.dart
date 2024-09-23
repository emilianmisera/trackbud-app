import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutTrackbudScreen extends StatefulWidget {
  const AboutTrackbudScreen({super.key});

  @override
  State<AboutTrackbudScreen> createState() => _AboutTrackbudScreenState();
}

class _AboutTrackbudScreenState extends State<AboutTrackbudScreen> {
  // URL
  final Uri _url = Uri.parse('https://www.paypal.me/emilianmi');

  // method that launches URL
  Future<void> _launchInBrowser() async {
    if (!await launchUrl(
      _url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $_url');
    }
  }

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
            Text(AppTexts.aboutTrackBudText, style: TextStyles.regularStyleDefault, textAlign: TextAlign.center),
            const Gap(CustomPadding.bigSpace),
            Text(AppTexts.laurenzEmail, style: TextStyles.hintStyleDefault.copyWith(color: CustomColor.bluePrimary)),
            Text(AppTexts.emilianEmail, style: TextStyles.hintStyleDefault.copyWith(color: CustomColor.bluePrimary)),
            const Gap(CustomPadding.bigSpace),
            Text(AppTexts.madeWithLove, style: TextStyles.regularStyleDefault),
            const Gap(CustomPadding.mediumSpace),
            GestureDetector(
                onTap: () => _launchInBrowser(),
                child: Text(AppTexts.supportUs, style: TextStyles.regularStyleDefault.copyWith(color: CustomColor.bluePrimary))),
          ],
        ),
      ),
    );
  }
}
