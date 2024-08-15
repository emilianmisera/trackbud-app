import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';
import 'package:track_bud/views/at_signup/forgot_password_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          // Padding adds spacing around the content inside the screen.
          padding: EdgeInsets.only(
            top: MediaQuery.sizeOf(context).height * CustomPadding.topSpace -
                Constants
                    .defaultAppBarHeight, // Top padding based on screen height
            left: CustomPadding.defaultSpace, // Left padding
            right: CustomPadding.defaultSpace, // Right padding
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppString.changePassword, // The heading text
                style: CustomTextStyle
                    .headingStyle, // The text style for the heading.
              ),
              SizedBox(
                height: CustomPadding
                    .mediumSpace, // Adds vertical space between the heading and the next element.
              ),
              Text(
                AppString.changePasswordDesscribtion, // The description text
                style: CustomTextStyle
                    .hintStyleDefault, // The text style for the description.
              ),
              SizedBox(
                height: CustomPadding
                    .bigSpace, // Adds more vertical space before the next element.
              ),
              CustomTextfield(
                  name: AppString.currentPassword,
                  hintText: AppString.currentPasswordHint,
                  controller: _currentPasswordController),
              SizedBox(
                height: CustomPadding.mediumSpace,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  // forgot Password
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen()));
                  },
                  child: Text(
                    AppString.forgotPassword,
                    style: CustomTextStyle.hintStyleMedium,
                  ),
                ),
              ),
              SizedBox(height: CustomPadding.defaultSpace),
              CustomTextfield(
                  name: AppString.newPassword,
                  hintText: AppString.hintPassword,
                  controller: _passwordController),
              SizedBox(height: CustomPadding.defaultSpace),
              // Confirm Password text field
              CustomTextfield(
                  name: AppString.confirmPassword,
                  hintText: AppString.confirmNewPasswort,
                  controller: _confirmPasswordController),
            ],
          ),
        ),
      ),
      bottomSheet: 
        Container(
          margin: EdgeInsets.only(
            bottom: MediaQuery.sizeOf(context).height *
                CustomPadding
                    .bottomSpace, // Bottom margin based on screen height
            left: CustomPadding.defaultSpace, // Left margin
            right: CustomPadding.defaultSpace, // Right margin
          ),
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () async {},
            child: Text(AppString.save),
          ),
        ),
    );
  }
}
