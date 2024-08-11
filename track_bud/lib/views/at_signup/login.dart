import 'package:flutter/material.dart';
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
        padding: EdgeInsets.only(
            bottom: CustomPadding.bottomSpace,
            left: CustomPadding.defaultSpace,
            right: CustomPadding.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end, //alignment to bottom
          crossAxisAlignment: CrossAxisAlignment.start, //alignment to left
          children: [
            Text(AppString.signIn, style: CustomTextStyle.headingStyle,),
            SizedBox(height: CustomPadding.mediumSpace,),
            Text(AppString.signInDescribtion, style: CustomTextStyle.hintStyleDefault,),
            SizedBox(height: CustomPadding.defaultSpace,),
            Textfield(name: AppString.email, hintText: AppString.hintEmail),
            SizedBox(height: CustomPadding.defaultSpace,),
            Textfield(name: AppString.password, hintText: AppString.hintPassword),
            
          ],
        ),
      ),
    );
  }
}
