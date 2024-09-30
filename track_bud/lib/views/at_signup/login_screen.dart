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
    final defaultColorScheme = Theme.of(context).colorScheme; // Get the current theme's color scheme
    final FirebaseService authService = FirebaseService(); // Create instance of Firebase service
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
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const TrackBud()), // Navigate to the main app screen upon successful login
        );
      }
    } catch (e) {
      debugPrint('login_screen: _loginUser -> user login failed');

      // Show dialog with error message if login fails
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              _getErrorMessage(e), // Get the appropriate error message
              style: TextStyle(color: defaultColorScheme.primary),
            ),
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
          return 'Benutzer nicht gefunden.'; // User not found message
        case 'wrong-password':
          return 'Falsches Passwort.'; // Wrong password message
        case 'invalid-email':
          return 'Ungültige E-Mail Adresse.'; // Invalid email message
        default:
          return 'Fehlerhafte Anmeldung!'; // Generic login error message
      }
    }
    return 'Fehlerhafte Anmeldung!'; // Default error message
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme; // Get the current theme's color scheme
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.sizeOf(context).height * CustomPadding.topSpaceAuth, // Padding from the top
            left: CustomPadding.defaultSpace, // Left padding
            right: CustomPadding.defaultSpace, // Right padding
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
            children: [
              Text(AppTexts.signIn, style: TextStyles.headingStyle.copyWith(color: defaultColorScheme.primary)), // Main title
              const Gap(CustomPadding.mediumSpace), // Space between elements
              Text(AppTexts.signInDescription,
                  style: TextStyles.hintStyleDefault.copyWith(color: defaultColorScheme.secondary)), // Description
              const Gap(CustomPadding.defaultSpace), // Space between elements
              CustomTextfield(
                controller: _email,
                name: AppTexts.email,
                hintText: AppTexts.hintEmail,
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
              ), // Email input field
              const Gap(CustomPadding.defaultSpace), // Space between elements
              CustomTextfield(
                controller: _password,
                name: AppTexts.password,
                hintText: AppTexts.hintPassword,
                obscureText: true,
              ), // Password input field
              const Gap(CustomPadding.bigSpace), // Space between elements
              // password forgotton currently not working
              /* Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => const ForgotPasswordScreen())); // Navigate to forgot password screen
                  },
                  child: Text(AppTexts.forgotPassword,
                      style: TextStyles.hintStyleMedium.copyWith(color: defaultColorScheme.secondary)), // Forgot password text
                ),
              ),
              const Gap(CustomPadding.bigSpace), // Space between elements */
              ElevatedButton(
                onPressed: () => _loginUser(), // Trigger login process
                child: Text(AppTexts.signIn), // Sign in button text
              ),
              const Gap(CustomPadding.bigSpace), // Space between elements
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: CustomPadding.mediumSpace),
                      child: Divider(color: defaultColorScheme.outline), // Divider line
                    ),
                  ),
                  Text(AppTexts.or, style: TextStyles.hintStyleMedium.copyWith(color: defaultColorScheme.secondary)), // 'or' text
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: CustomPadding.mediumSpace),
                      child: Divider(color: defaultColorScheme.outline), // Divider line
                    ),
                  ),
                ],
              ),
              const Gap(CustomPadding.bigSpace), // Space between elements
              CustomShadow(
                child: TextButton.icon(
                  onPressed: () => _handleGoogleSignIn(), // Trigger Google sign-in process
                  label: Text(AppTexts.signInWithGoogle), // Google sign-in button text
                  icon: SvgPicture.asset(AssetImport.googleLogo), // Google logo
                ),
              ),
              const Gap(CustomPadding.defaultSpace), // Space between elements
              /*
              CustomShadow(
                // Apple Sign In (currently commented out)
                child: TextButton.icon(
                  onPressed: () {},
                  label: Text(AppTexts.signInWithApple),
                  icon: SvgPicture.asset(AssetImport.appleLogo),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (states) => CustomColor.black,
                    ),
                    foregroundColor: WidgetStateProperty.resolveWith<Color>(
                      (states) => CustomColor.white,
                    ),
                  ),
                ),
              ),
              */
              const Gap(CustomPadding.bigSpace), // Space between elements
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center alignment for the row
                children: [
                  Text(AppTexts.newHere, style: TextStyles.hintStyleMedium.copyWith(color: defaultColorScheme.secondary)), // New user text
                  const Gap(CustomPadding.smallSpace), // Space between elements
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(builder: (context) => const SignUpScreen())); // Navigate to sign-up screen
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
