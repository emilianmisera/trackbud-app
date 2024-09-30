//currently not working

/* import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/services/auth/firebase_service.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield.dart';
import 'package:email_validator/email_validator.dart';

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
  bool _isLoading = false;

  final FirebaseService _authService = FirebaseService();
  final FirestoreService firestoreService = FirestoreService();

  void _changeEmail() async {
    final defaultColorScheme = Theme.of(context).colorScheme;
    // Validate new email format
    if (!EmailValidator.validate(_newEmailController.text)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bitte geben Sie eine gültige E-Mail-Adresse ein.',
                style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Check if new email is already in use
      final signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(_newEmailController.text);
      if (signInMethods.isNotEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Diese E-Mail-Adresse wird bereits verwendet.',
                  style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
            ),
          );
        }
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Re-authenticate the user
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _passwordController.text,
        );
        await user.reauthenticateWithCredential(credential);
      } else {
        // Handle case where user is not logged in
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Benutzer nicht angemeldet.', style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
            ),
          );
        }
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Send verification link
      await _authService.sendEmailUpdateVerificationLink(
        _newEmailController.text,
        _passwordController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Ein Verifizierungslink wurde an die neue E-Mail gesendet. Bitte überprüfen Sie Ihren Posteingang und klicken Sie auf den Link, um die Änderung Ihrer E-Mail-Adresse abzuschließen.',
                style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)), // Updated message
          ),
        );

        // Wait for the user to verify their email
        await _waitForEmailVerification();

        // After verification, update the email in Firebase Auth and Firestore
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await _authService.updateEmailAfterVerification(user.uid, _passwordController.text);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('E-Mail-Adresse erfolgreich aktualisiert!',
                    style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
              ),
            );
            Navigator.of(context).pop(); // Navigate back after successful update
          }
        }
      }
    } catch (e) {
      debugPrint('Fehler beim Ändern der E-Mail-Adresse: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _waitForEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      while (!(user.emailVerified)) {
        await Future.delayed(const Duration(seconds: 3));
        await user.reload();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
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
                style: TextStyles.headingStyle.copyWith(color: defaultColorScheme.primary),
              ),
              const Gap(
                CustomPadding.mediumSpace,
              ),
              // The description text
              Text(
                AppTexts.changeEmailDesscribtion,
                style: TextStyles.hintStyleDefault.copyWith(color: defaultColorScheme.secondary),
              ),
              const Gap(
                CustomPadding.bigSpace,
              ),
              // Current email text field
              CustomTextfield(
                name: AppTexts.currentEmail,
                hintText: AppTexts.currentEmailHint,
                controller: _currentEmailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const Gap(CustomPadding.defaultSpace),
              // new email text field
              CustomTextfield(
                name: AppTexts.newEmail,
                hintText: AppTexts.newEmailHint,
                controller: _newEmailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const Gap(CustomPadding.defaultSpace),
              // Confirm Password text field
              CustomTextfield(
                name: AppTexts.password,
                obscureText: true,
                hintText: AppTexts.hintPassword,
                controller: _passwordController,
              ),
            ],
          ),
        ),
      ),
      // Bottom sheet with Save button
      bottomSheet: Container(
        color: defaultColorScheme.onSurface,
        child: Container(
          margin: EdgeInsets.only(
            bottom: MediaQuery.sizeOf(context).height * CustomPadding.bottomSpace,
            left: CustomPadding.defaultSpace,
            right: CustomPadding.defaultSpace,
          ),
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _changeEmail, // Disable button while loading
            child: _isLoading
                ? const CircularProgressIndicator(color: CustomColor.bluePrimary) // Show loading indicator
                : Text(AppTexts.save),
          ),
        ),
      ),
    );
  }
}
 */