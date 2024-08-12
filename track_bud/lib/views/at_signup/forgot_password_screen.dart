import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        // spacing between content and screen
        padding: EdgeInsets.only(
            top: MediaQuery.sizeOf(context).height * CustomPadding.topSpaceAuth - Constants.defaultAppBarHeight,
            left: CustomPadding.defaultSpace,
            right: CustomPadding.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, //alignment to left
          children: [
            Text(
              AppString.resetPassword,
              style: CustomTextStyle.headingStyle,
            ),
            SizedBox(
              height: CustomPadding.mediumSpace,
            ),
            Text(
              AppString.resetPasswordDescribtion,
              style: CustomTextStyle.hintStyleDefault,
            ),
            SizedBox(
              height: CustomPadding.defaultSpace,
            ),
            Textfield(
                name: AppString.email, hintText: AppString.hintEmail), //email
            SizedBox(
              height: CustomPadding.bigSpace,
            ),
            ElevatedButton(
              //sign in button
              onPressed: () {},
              child: Text(
                AppString.continueText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
