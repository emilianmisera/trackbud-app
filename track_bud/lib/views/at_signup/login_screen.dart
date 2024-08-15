import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:track_bud/services/auth/auth_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';
import 'package:track_bud/views/at_signup/forgot_password_screen.dart';
import 'package:track_bud/views/at_signup/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  Future<void> _handleSignIn() async {
  String email = _emailController.text.trim();
  String password = _passwordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${AppString.emptyLoginInput}"),
      ),
    );
    return;
  }

  try {
    // Versuche, den Benutzer mit E-Mail und Passwort anzumelden
    await _authService.signInWithEmailAndPassword(context, email, password);

    // Zeige eine Erfolgsmeldung an
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppString.successfulLogin),
      ),
    );

  } on FirebaseAuthException catch (e) {
    // Zeige eine Fehlermeldung an, falls die Anmeldung fehlgeschlagen ist
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${AppString.loginFailedSnackbar}: ${e.message ?? e.code}"),
      ),
    );
  }
}

  Future<void> _handleGoogleSignIn() async {
  try {
    // Versuche, den Benutzer mit Google anzumelden
    await _authService.signInWithGoogle(context);

    // Zeige eine Erfolgsmeldung an
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppString.successfulLogin),
      ),
    );

  } catch (error) {
    // Zeige eine Fehlermeldung an, falls die Google-Anmeldung fehlgeschlagen ist
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Google-Anmeldung fehlgeschlagen: $error"),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          // spacing between content and screen
          padding: EdgeInsets.only(
              top: MediaQuery.sizeOf(context).height *
                  CustomPadding.topSpaceAuth,
              left: CustomPadding.defaultSpace,
              right: CustomPadding.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, //alignment to left
            children: [
              Text(
                AppString.signIn,
                style: CustomTextStyle.headingStyle,
              ),
              SizedBox(
                height: CustomPadding.mediumSpace,
              ),
              Text(
                AppString.signInDescription,
                style: CustomTextStyle.hintStyleDefault,
              ),
              SizedBox(
                height: CustomPadding.defaultSpace,
              ),
              CustomTextfield(
                controller: _emailController,
                name: AppString.email,
                hintText: AppString.hintEmail,
                obscureText: false,
              ), //email
              SizedBox(
                height: CustomPadding.defaultSpace,
              ),
              CustomTextfield(
                controller: _passwordController,
                name: AppString.password,
                hintText: AppString.hintPassword,
                obscureText: true,
              ),
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
              SizedBox(
                height: CustomPadding.bigSpace,
              ),
              ElevatedButton(
                //sign in button
                onPressed: _handleSignIn,
                child: Text(
                  AppString.signIn,
                ),
              ),
              SizedBox(
                height: CustomPadding.bigSpace,
              ),
              Row(
                // Divider
                children: [
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(
                            right: CustomPadding.mediumSpace),
                        child: Divider(
                          color: CustomColor.grey,
                        )),
                  ),
                  Text(
                    AppString.or,
                    style: CustomTextStyle.hintStyleMedium,
                  ),
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(
                            left: CustomPadding.mediumSpace),
                        child: Divider(
                          color: CustomColor.grey,
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: CustomPadding.bigSpace,
              ),
              CustomShadow(
                // Google Sign In
                child: TextButton.icon(
                  onPressed: () async {
                    try {
                      _handleGoogleSignIn();
                    } on FirebaseAuthException {
                      //error handling
                    } catch (e) {}
                  },
                  label: Text(AppString.signInWithGoogle),
                  icon: SvgPicture.asset(AssetImport.googleLogo),
                ),
              ),
              SizedBox(
                height: CustomPadding.defaultSpace,
              ),
              CustomShadow(
                // Apple Sign In
                child: TextButton.icon(
                  onPressed: () {},
                  label: Text(AppString.signInWithApple),
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
              SizedBox(
                height: CustomPadding.bigSpace,
              ),
              Row(
                // Redirection to sign up page if user doesn't have an account
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppString.newHere,
                      style: CustomTextStyle.hintStyleMedium),
                  SizedBox(
                    width: CustomPadding.smallSpace,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => SignUpScreen()));
                    },
                    child: Text(
                      AppString.signUp,
                      style: TextStyle(
                        fontSize: CustomTextStyle.fontSizeDefault,
                        fontWeight: CustomTextStyle.fontWeightMedium,
                        color: CustomColor.bluePrimary,
                        decoration: TextDecoration.underline,
                        decorationColor: CustomColor.bluePrimary,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: CustomPadding.smallSpace),
            ],
          ),
        ),
      ),
    );
  }
}
