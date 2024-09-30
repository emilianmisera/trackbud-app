import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/services/auth/firebase_service.dart';
import 'package:track_bud/trackbud.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield.dart';
import 'package:track_bud/views/at_signup/signup_screen.dart';

/// Screen for User Login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController(); // Controller for email input
  final TextEditingController _password = TextEditingController(); // Controller for password input
  final FirebaseService _firebaseService = FirebaseService(); // Instance of Firebase service for authentication

  // Handles Google sign-in process
  Future<void> _handleGoogleSignIn() async {
    final defaultColorScheme = Theme.of(context).colorScheme; // Get the current theme's color scheme
    try {
      await _firebaseService.signInWithGoogle(context); // Attempt Google sign-in

      // Show success message if sign-in is successful
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppTexts.successfulLogin, style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
        ));
      }
    } catch (error) {
      // Show error message if sign-in fails
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Google-Anmeldung fehlgeschlagen: $error",
              style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
        ));
      }
    }
  }

  // Handles user login with email and password
  void _loginUser() async {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final FirebaseService authService = FirebaseService();
    String email = _email.text.trim(); // Trimmed email input
    String password = _password.text.trim(); // Trimmed password input

    if (email.isEmpty || password.isEmpty) {
      // Show error message if input fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppTexts.emptyLoginInput, style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
        ),
      );
      return;
    }

    try {
      debugPrint('login_screen: _loginUser -> trying to login...');
      await authService.signInWithEmailAndPassword(_email.text, _password.text); // Attempt login

      debugPrint('login_screen: _loginUser -> success! -> redirecting to Overview');
      if (mounted) {
        // Navigate to the main app screen upon successful login
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const TrackBud()));
      }
    } catch (e) {
      debugPrint('login_screen: _loginUser -> user login failed');

      // Show dialog with error message if login fails
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            // Get the appropriate error message
            title: Text(_getErrorMessage(e), style: TextStyle(color: defaultColorScheme.primary)),
          ),
        );
      }
    }
  }

  // Helper function to determine the error message based on FirebaseAuthException
  String _getErrorMessage(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'Benutzer nicht gefunden.';
        case 'wrong-password':
          return 'Falsches Passwort.';
        case 'invalid-email':
          return 'Ungültige E-Mail Adresse.';
        default:
          return 'Fehlerhafte Anmeldung!';
      }
    }
    return 'Fehlerhafte Anmeldung!'; // Default error message
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.sizeOf(context).height * CustomPadding.topSpaceAuth,
              left: CustomPadding.defaultSpace,
              right: CustomPadding.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main title
              Text(AppTexts.signIn, style: TextStyles.headingStyle.copyWith(color: defaultColorScheme.primary)),
              const Gap(CustomPadding.mediumSpace),
              // Description
              Text(AppTexts.signInDescription, style: TextStyles.hintStyleDefault.copyWith(color: defaultColorScheme.secondary)),
              const Gap(CustomPadding.defaultSpace),
              // Email input field
              CustomTextfield(
                  controller: _email,
                  name: AppTexts.email,
                  hintText: AppTexts.hintEmail,
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress),
              const Gap(CustomPadding.defaultSpace),
              // Password input field
              CustomTextfield(controller: _password, name: AppTexts.password, hintText: AppTexts.hintPassword, obscureText: true),
              const Gap(CustomPadding.bigSpace),
              // Sign in button
              ElevatedButton(onPressed: () => _loginUser(), child: Text(AppTexts.signIn)),
              const Gap(CustomPadding.bigSpace), // Space between elements
              Row(
                children: [
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(right: CustomPadding.mediumSpace), child: Divider(color: defaultColorScheme.outline)),
                  ),
                  Text(AppTexts.or, style: TextStyles.hintStyleMedium.copyWith(color: defaultColorScheme.secondary)),
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(left: CustomPadding.mediumSpace), child: Divider(color: defaultColorScheme.outline)),
                  ),
                ],
              ),
              const Gap(CustomPadding.bigSpace),
              // Google Login
              CustomShadow(
                child: TextButton.icon(
                    onPressed: () => _handleGoogleSignIn(),
                    label: Text(AppTexts.signInWithGoogle),
                    icon: SvgPicture.asset(AssetImport.googleLogo)),
              ),
              const Gap(CustomPadding.defaultSpace),
              const Gap(CustomPadding.bigSpace),
              // New User Sign Up Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppTexts.newHere, style: TextStyles.hintStyleMedium.copyWith(color: defaultColorScheme.secondary)),
                  const Gap(CustomPadding.smallSpace),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignUpScreen()));
                    },
                    child: Text(
                      AppTexts.signUp,
                      style: const TextStyle(
                        fontSize: TextStyles.fontSizeDefault,
                        fontWeight: TextStyles.fontWeightMedium,
                        color: CustomColor.bluePrimary, // Sign up link color
                        decoration: TextDecoration.underline, // Underline style
                        decorationColor: CustomColor.bluePrimary, // Decoration color
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(CustomPadding.smallSpace), // Space between elements
            ],
          ),
        ),
      ),
    );
  }
}
