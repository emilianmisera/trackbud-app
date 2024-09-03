import 'package:cloud_firestore/cloud_firestore.dart';
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

  void _loginUser() async {
    final AuthService authService = AuthService();

    // try login
    try {
      debugPrint('login_screen: _loginUser -> trying to login...');
      await authService.signInWithEmailAndPassword(_email.text, _password.text);

      debugPrint(
          'login_screen: _loginUser -> sucess! -> redirecting to Overview');
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => TrackBud()),
        );
      }
    } catch (e) {
      debugPrint('login_screen: _loginUser -> user login failed');
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Fehler: ${e.toString()}'),
              ));
    }

    // catch any errors
  }

  Future<Map<String, dynamic>> getCurrentUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is null');
      return {};
    }

    try {
      print('Attempting to fetch data for user ID: ${user.uid}');
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!snapshot.exists) {
        print('User document does not exist');
        return {};
      }

      Map<String, dynamic> data = snapshot.data() ?? {};
      print('Document data: $data');
      return data;
    } catch (e) {
      print('Error fetching user data: $e');
      return {};
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
                AppTexts.signIn,
                style: TextStyles.headingStyle,
              ),
              Gap(
                CustomPadding.mediumSpace,
              ),
              Text(
                AppTexts.signInDescription,
                style: TextStyles.hintStyleDefault,
              ),
              Gap(
                CustomPadding.defaultSpace,
              ),
              CustomTextfield(
                controller: _email,
                name: AppTexts.email,
                hintText: AppTexts.hintEmail,
                obscureText: false,
              ), //email
              Gap(
                CustomPadding.defaultSpace,
              ),
              CustomTextfield(
                controller: _password,
                name: AppTexts.password,
                hintText: AppTexts.hintPassword,
                obscureText: true,
              ),
              Gap(
                CustomPadding.mediumSpace,
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
                    AppTexts.forgotPassword,
                    style: TextStyles.hintStyleMedium,
                  ),
                ),
              ),
              Gap(
                CustomPadding.bigSpace,
              ),
              ElevatedButton(
                //sign in button
                onPressed: () {
                  _loginUser();
                },
                child: Text(
                  AppTexts.signIn,
                ),
              ),
              Gap(
                CustomPadding.bigSpace,
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
                    AppTexts.or,
                    style: TextStyles.hintStyleMedium,
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
              Gap(
                CustomPadding.bigSpace,
              ),
              CustomShadow(
                // Google Sign In
                child: TextButton.icon(
                  onPressed: () async {},
                  label: Text(AppTexts.signInWithGoogle),
                  icon: SvgPicture.asset(AssetImport.googleLogo),
                ),
              ),
              Gap(
                CustomPadding.defaultSpace,
              ),
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
              Gap(
                CustomPadding.bigSpace,
              ),
              Row(
                // Redirection to sign up page if user doesn't have an account
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppTexts.newHere, style: TextStyles.hintStyleMedium),
                  Gap(
                    CustomPadding.smallSpace,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => SignUpScreen()));
                    },
                    child: Text(
                      AppTexts.signUp,
                      style: TextStyle(
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
              Gap(CustomPadding.smallSpace),
            ],
          ),
        ),
      ),
    );
  }
}
