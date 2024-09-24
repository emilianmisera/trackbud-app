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
  final Uri _emailLaurenz = Uri.parse('mailto:laurenz.ueckert@stud.uni-regensburg.de?subject=TrackBud&body=');
  final Uri _emailEmilian = Uri.parse('mailto:emilian.misera@stud.uni-regensburg.de?subject=TrackBud&body=');

  // method that launches URL
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace),
        child: Column(
          children: [
            SvgPicture.asset(AssetImport.iconLogo),
            const Gap(CustomPadding.bigSpace),
            Text(AppTexts.aboutTrackBudText,
                style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary), textAlign: TextAlign.center),
            const Gap(CustomPadding.bigSpace),
            GestureDetector(
              onTap: () => _launchInBrowser(_emailLaurenz),
              child: Text(AppTexts.laurenzEmail, style: TextStyles.hintStyleDefault.copyWith(color: CustomColor.bluePrimary)),
            ),
            GestureDetector(
              onTap: () => _launchInBrowser(_emailEmilian),
              child: Text(AppTexts.emilianEmail, style: TextStyles.hintStyleDefault.copyWith(color: CustomColor.bluePrimary)),
            ),
            const Gap(CustomPadding.bigSpace),
            Text(AppTexts.madeWithLove, style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
            const Gap(CustomPadding.mediumSpace),
            GestureDetector(
              onTap: () => _launchInBrowser(_url),
              child: Text(AppTexts.supportUs, style: TextStyles.regularStyleDefault.copyWith(color: CustomColor.bluePrimary)),
            ),
          ],
        ),
      ),
    );
  }
}
