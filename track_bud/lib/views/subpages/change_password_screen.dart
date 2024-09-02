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
  // Controllers for the text fields
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          // Padding adds spacing around the content inside the screen
          padding: EdgeInsets.only(
            top: MediaQuery.sizeOf(context).height * CustomPadding.topSpace -
                Constants.defaultAppBarHeight, // Top padding based on screen height
            left: CustomPadding.defaultSpace, // Left padding
            right: CustomPadding.defaultSpace, // Right padding
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading text
              Text(
                AppTexts.changePassword,
                style: TextStyles.headingStyle,
              ),
              SizedBox(height: CustomPadding.mediumSpace),

              // Description text
              Text(
                AppTexts.changePasswordDesscribtion,
                style: TextStyles.hintStyleDefault,
              ),
              SizedBox(height: CustomPadding.bigSpace),

              // Current password text field
              CustomTextfield(
                name: AppTexts.currentPassword,
                hintText: AppTexts.currentPasswordHint,
                controller: _currentPasswordController,
              ),
              SizedBox(height: CustomPadding.mediumSpace),

              // Forgot password link
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ForgotPasswordScreen(),
                    ));
                  },
                  child: Text(
                    AppTexts.forgotPassword,
                    style: TextStyles.hintStyleMedium,
                  ),
                ),
              ),
              SizedBox(height: CustomPadding.defaultSpace),

              // New password text field
              CustomTextfield(
                name: AppTexts.newPassword,
                hintText: AppTexts.hintPassword,
                controller: _passwordController,
              ),
              SizedBox(height: CustomPadding.defaultSpace),

              // Confirm new password text field
              CustomTextfield(
                name: AppTexts.confirmPassword,
                hintText: AppTexts.confirmNewPasswort,
                controller: _confirmPasswordController,
              ),
            ],
          ),
        ),
      ),
      // Bottom sheet with Save button
      bottomSheet: Container(
        margin: EdgeInsets.only(
          bottom: MediaQuery.sizeOf(context).height * CustomPadding.bottomSpace,
          left: CustomPadding.defaultSpace,
          right: CustomPadding.defaultSpace,
        ),
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () async {
            // TODO: Implement save functionality
          },
          child: Text(AppTexts.save),
        ),
      ),
    );
  }
}
