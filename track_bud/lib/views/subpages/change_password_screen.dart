import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield.dart';
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
              Text(AppTexts.changePassword, style: TextStyles.headingStyle),
              const Gap(CustomPadding.mediumSpace),

              // Description text
              Text(AppTexts.changePasswordDesscribtion, style: TextStyles.hintStyleDefault),
              const Gap(CustomPadding.bigSpace),

              // Current password text field
              CustomTextfield(
                name: AppTexts.currentPassword,
                hintText: AppTexts.currentPasswordHint,
                controller: _currentPasswordController,
              ),
              const Gap(CustomPadding.mediumSpace),

              // Forgot password link
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen(),
                    ));
                  },
                  child: Text(AppTexts.forgotPassword, style: TextStyles.hintStyleMedium),
                ),
              ),
              const Gap(CustomPadding.defaultSpace),

              // New password text field
              CustomTextfield(
                name: AppTexts.newPassword,
                hintText: AppTexts.hintPassword,
                controller: _passwordController,
              ),
              const Gap(CustomPadding.defaultSpace),

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
