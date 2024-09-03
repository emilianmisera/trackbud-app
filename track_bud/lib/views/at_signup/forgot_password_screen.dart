import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/services/auth/firebase_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService(); // Create an instance of AuthService

  void _handleSubmission() async {
    // Retrieve email input from the text controller
    String email = _emailController.text.trim();

    // Validate email input
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your email."),
        ),
      );
      return;
    }
    try {
      // Attempt to send a password reset email
      debugPrint('Attempt to send a password reset email');
      await _authService.sendPasswordResetEmail(email);
      debugPrint('email successfull sent!');
      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password reset email sent.")));
        // Optionally navigate back to login screen
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      // Handle error and show error message
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomSheet: Container(
        // Margin is applied to the bottom of the button and the sides for proper spacing.
        margin: EdgeInsets.only(
          bottom: MediaQuery.sizeOf(context).height * CustomPadding.bottomSpace, // Bottom margin based on screen height
          left: CustomPadding.defaultSpace, // Left margin
          right: CustomPadding.defaultSpace, // Right margin
        ),
        width: MediaQuery.of(context).size.width, // Set the button width to match the screen width
        child: ElevatedButton(
          onPressed: () => _handleSubmission(),
          child: Text(AppTexts.continueText),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          // spacing between content and screen
          padding: EdgeInsets.only(
              top: MediaQuery.sizeOf(context).height * CustomPadding.topSpaceAuth - Constants.defaultAppBarHeight,
              left: CustomPadding.defaultSpace,
              right: CustomPadding.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, //alignment to left
            children: [
              Text(AppTexts.resetPassword, style: TextStyles.headingStyle),
              const Gap(CustomPadding.mediumSpace),
              Text(AppTexts.resetPasswordDescription, style: TextStyles.hintStyleDefault),
              const Gap(CustomPadding.defaultSpace),
              CustomTextfield(
                controller: _emailController,
                name: AppTexts.email,
                hintText: AppTexts.hintEmail,
                obscureText: false,
              ), //email
            ],
          ),
        ),
      ),
    );
  }
}
