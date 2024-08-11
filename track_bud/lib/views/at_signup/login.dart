import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        // spacing between content and screen
        padding: EdgeInsets.only(
            top: MediaQuery.sizeOf(context).height * CustomPadding.topSpaceAuth,
            left: CustomPadding.defaultSpace,
            right: CustomPadding.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, //alignment to left
          children: [
            Text(
              AppString.signIn,
              style: CustomTextStyle.headingStyle,
            ),
            SizedBox(
              height: CustomPadding.mediumSpace,
            ),
            Text(
              AppString.signInDescribtion,
              style: CustomTextStyle.hintStyleDefault,
            ),
            SizedBox(
              height: CustomPadding.defaultSpace,
            ),
            Textfield(
                name: AppString.email, hintText: AppString.hintEmail), //email
            SizedBox(
              height: CustomPadding.defaultSpace,
            ),
            Textfield(
                name: AppString.password,
                hintText: AppString.hintPassword), //password
            SizedBox(
              height: CustomPadding.bigSpace,
            ),
            ElevatedButton(
              //sign in button
              onPressed: () {},
              child: Text(
                AppString.signIn,
              ),
            ),
            SizedBox(
              height: CustomPadding.bigSpace,
            ),
            Row(
              // Divider
              children: [
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(
                          right: CustomPadding.mediumSpace),
                      child: Divider(
                        color: CustomColor.grey,
                      )),
                ),
                Text(
                  AppString.or,
                  style: CustomTextStyle.hintStyleMedium,
                ),
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(
                          left: CustomPadding.mediumSpace),
                      child: Divider(
                        color: CustomColor.grey,
                      )),
                ),
              ],
            ),
            SizedBox(
              height: CustomPadding.bigSpace,
            ),
            Shadow(
              // Google Sign In
              child: TextButton.icon(
                onPressed: () {},
                label: Text(AppString.signInWithGoogle),
                icon: SvgPicture.asset(AssetImport.googleLogo),
              ),
            ),
            SizedBox(
              height: CustomPadding.defaultSpace,
            ),
            Shadow(
              // Apple Sign In
              child: TextButton.icon(
                onPressed: () {},
                label: Text(AppString.signInWithApple),
                icon: SvgPicture.asset(AssetImport.appleLogo),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (states) => CustomColor.black,
                  ),
                  foregroundColor: WidgetStateProperty.resolveWith<Color>(
                    (states) => CustomColor.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: CustomPadding.bigSpace,
            ),
            Row( // Redirection to sign up page if user doesn't have an account
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppString.newHere, style: CustomTextStyle.hintStyleMedium),
                SizedBox(
                  width: CustomPadding.smallSpace,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    AppString.signUp,
                    style: TextStyle(
                      fontSize: CustomTextStyle.fontSizeDefault,
                      fontWeight: CustomTextStyle.fontWeightMedium,
                      color: CustomColor.bluePrimary,
                      decoration: TextDecoration.underline,
                      decorationColor: CustomColor.bluePrimary,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
