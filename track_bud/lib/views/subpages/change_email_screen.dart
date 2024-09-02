import 'package:flutter/material.dart';
import 'package:track_bud/services/auth/auth_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  // Controllers for the text fields
  final TextEditingController _currentEmailController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService(); // Add this line

  void _changeEmail() async {
    try {
      await _authService.sendEmailUpdateVerificationLink(
        _newEmailController.text,
        _passwordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Ein Verifizierungslink wurde an die neue E-Mail gesendet.'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Fehler beim Senden des Verifizierungslinks: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          // Padding adds spacing around the content inside the screen.
          padding: EdgeInsets.only(
            top: MediaQuery.sizeOf(context).height * CustomPadding.topSpace -
                Constants.defaultAppBarHeight, // Top padding based on screen height
            left: CustomPadding.defaultSpace, // Left padding
            right: CustomPadding.defaultSpace, // Right padding
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // The heading text
              Text(
                AppTexts.changeEmail,
                style: CustomTextStyle.headingStyle,
              ),
              SizedBox(
                height: CustomPadding.mediumSpace,
              ),
              // The description text
              Text(
                AppTexts.changeEmailDesscribtion,
                style: CustomTextStyle.hintStyleDefault,
              ),
              SizedBox(
                height: CustomPadding.bigSpace,
              ),
              // Current email text field
              CustomTextfield(name: AppTexts.currentEmail, hintText: AppTexts.currentEmailHint, controller: _currentEmailController),
              SizedBox(height: CustomPadding.defaultSpace),
              // new email text field
              CustomTextfield(name: AppTexts.newEmail, hintText: AppTexts.newEmailHint, controller: _newEmailController),
              SizedBox(height: CustomPadding.defaultSpace),
              // Confirm Password text field
              CustomTextfield(name: AppTexts.password, obscureText: true, hintText: AppTexts.hintPassword, controller: _passwordController),
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
            _changeEmail();
          },
          child: Text(AppTexts.save),
        ),
      ),
    );
  }
}
