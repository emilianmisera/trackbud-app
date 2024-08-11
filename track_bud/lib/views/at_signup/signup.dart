import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
              AppString.signUp,
              style: CustomTextStyle.headingStyle,
            ),
            SizedBox(
              height: CustomPadding.mediumSpace,
            ),
            Text(
              AppString.signUpDescribtion,
              style: CustomTextStyle.hintStyleDefault,
            ),
            SizedBox(
              height: CustomPadding.defaultSpace,
            ),
            Textfield(
                name: AppString.firstName, hintText: AppString.hintFirstName), //email
            SizedBox(
              height: CustomPadding.defaultSpace,
            ),
            Textfield(
                name: AppString.email,
                hintText: AppString.hintEmail),
            SizedBox(
              height: CustomPadding.defaultSpace,
            ),
            Textfield(
                name: AppString.password,
                hintText: AppString.hintPassword),
            SizedBox(
              height: CustomPadding.defaultSpace,
            ),
            Textfield(
                name: AppString.confirmPassword,
                hintText: AppString.confirmPassword), //password
            SizedBox(
              height: CustomPadding.bigSpace,
            ),
            ElevatedButton(
              //sign in button
              onPressed: () {},
              child: Text(
                AppString.signUp,
              ),
            ),
            SizedBox(
              height: CustomPadding.bigSpace,
            ),
            Row( // Redirection to sign up page if user doesn't have an account
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppString.notNew, style: CustomTextStyle.hintStyleMedium),
                SizedBox(
                  width: CustomPadding.smallSpace,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    AppString.signIn,
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
