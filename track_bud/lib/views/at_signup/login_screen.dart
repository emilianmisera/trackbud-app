import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/services/auth/firebase_service.dart';
import 'package:track_bud/trackbud.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield.dart';
import 'package:track_bud/views/at_signup/forgot_password_screen.dart';
import 'package:track_bud/views/at_signup/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final FirebaseService _firebaseService = FirebaseService();

  Future<void> _handleGoogleSignIn() async {
    final defaultColorScheme = Theme.of(context).colorScheme;
    try {
      // Versuche, den Benutzer mit Google anzumelden
      await _firebaseService.signInWithGoogle(context);

      // Zeige eine Erfolgsmeldung an
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppTexts.successfulLogin, style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary))));
      }
    } catch (error) {
      // Zeige eine Fehlermeldung an, falls die Google-Anmeldung fehlgeschlagen ist
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Google-Anmeldung fehlgeschlagen: $error",
                style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary))));
      }
    }
  }

  void _loginUser() async {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final FirebaseService authService = FirebaseService();
    String email = _email.text.trim();
    String password = _password.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppTexts.emptyLoginInput, style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
        ),
      );
      return;
    }

    // try login
    try {
      debugPrint('login_screen: _loginUser -> trying to login...');
      await authService.signInWithEmailAndPassword(_email.text, _password.text);

      debugPrint('login_screen: _loginUser -> sucess! -> redirecting to Overview');
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => TrackBud()),
        );
      }
    } catch (e) {
      debugPrint('login_screen: _loginUser -> user login failed');
      if (mounted) showDialog(context: context, builder: (context) => AlertDialog(title: Text('Fehler: ${e.toString()}')));
    }

    // catch any errors
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          // spacing between content and screen
          padding: EdgeInsets.only(
              top: MediaQuery.sizeOf(context).height * CustomPadding.topSpaceAuth,
              left: CustomPadding.defaultSpace,
              right: CustomPadding.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, //alignment to left
            children: [
              Text(AppTexts.signIn, style: TextStyles.headingStyle.copyWith(color: defaultColorScheme.primary)),
              const Gap(CustomPadding.mediumSpace),
              Text(AppTexts.signInDescription, style: TextStyles.hintStyleDefault.copyWith(color: defaultColorScheme.secondary)),
              const Gap(CustomPadding.defaultSpace),
              CustomTextfield(
                controller: _email,
                name: AppTexts.email,
                hintText: AppTexts.hintEmail,
                obscureText: false,
              ), //email
              const Gap(CustomPadding.defaultSpace),
              CustomTextfield(
                controller: _password,
                name: AppTexts.password,
                hintText: AppTexts.hintPassword,
                obscureText: true,
              ),
              const Gap(CustomPadding.mediumSpace),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  // forgot Password
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
                  },
                  child: Text(AppTexts.forgotPassword, style: TextStyles.hintStyleMedium.copyWith(color: defaultColorScheme.secondary)),
                ),
              ),
              const Gap(CustomPadding.bigSpace),
              ElevatedButton(
                //sign in button
                onPressed: () => _loginUser(),
                child: Text(AppTexts.signIn),
              ),
              const Gap(CustomPadding.bigSpace),
              Row(
                // Divider
                children: [
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(right: CustomPadding.mediumSpace),
                        child: Divider(
                          color: defaultColorScheme.outline,
                        )),
                  ),
                  Text(AppTexts.or, style: TextStyles.hintStyleMedium.copyWith(color: defaultColorScheme.secondary)),
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(left: CustomPadding.mediumSpace),
                        child: Divider(
                          color: defaultColorScheme.outline,
                        )),
                  ),
                ],
              ),
              const Gap(CustomPadding.bigSpace),
              CustomShadow(
                // Google Sign In
                child: TextButton.icon(
                  onPressed: () => _handleGoogleSignIn(),
                  label: Text(AppTexts.signInWithGoogle),
                  icon: SvgPicture.asset(AssetImport.googleLogo),
                ),
              ),
              const Gap(CustomPadding.defaultSpace),
              /*
              CustomShadow(
                // Apple Sign In
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
              const Gap(CustomPadding.bigSpace),
              Row(
                // Redirection to sign up page if user doesn't have an account
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
                        color: CustomColor.bluePrimary,
                        decoration: TextDecoration.underline,
                        decorationColor: CustomColor.bluePrimary,
                      ),
                    ),
                  )
                ],
              ),
              const Gap(CustomPadding.smallSpace),
            ],
          ),
        ),
      ),
    );
  }
}
