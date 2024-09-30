import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/services/auth/firebase_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield.dart';
import 'package:track_bud/views/at_signup/set_bank_account_screen.dart';
import 'package:track_bud/views/at_signup/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  // signup user
  Future<void> signUp() async {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final FirebaseService firebase = FirebaseService();
    // Retrieve user inputs
    String name = _name.text.trim();
    String email = _email.text.trim();
    String password = _password.text.trim();
    String confirmPassword = _confirmPassword.text.trim();

    // Validate inputs
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppTexts.signupEmptyField, style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
        ),
      );
      return;
    }

    // checking if both password is the same
    if (_password.text == _confirmPassword.text) {
      try {
        debugPrint('signup_screen: signUp -> try to create user');
        // Create user in Firebase Authentication
        UserCredential userCredential = await firebase.signUpWithEmailAndPassword(email, password, name);
        debugPrint('signup_screen: signUp -> try to create user -> sucess!');
        if (userCredential.user != null) {
          debugPrint('signup_screen: signUp -> adding user data');
          // Add user details to Firestore
          await addUserDetails(userCredential.user!.uid, _name.text.trim(), _email.text.trim());
          // Navigate to LandingScreen after successful registration
          debugPrint('signup_screen: signUp -> trying to move to BankAccountInfoScreen');
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const BankAccountInfoScreen()),
            );
            debugPrint('signup_screen: signUp -> trying to move to BankAccountInfoScreen -> moving succeed');
          }
          debugPrint('signup_screen: signUp -> trying to move to BankAccountInfoScreen -> moving failed');
        }
      } catch (e) {
        // Show error dialog if registration fails
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Regristration fehlgeschlagen: ${e.toString()}',
                  style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary))));
        }
      }
    } else {
      // Show error dialog if passwords don't match
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Passwörter stimmen nicht überein!',
                style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary))),
      );
    }
  }

  // Add user details to Firestore
  Future<void> addUserDetails(String uid, String name, String email) async {
    // Create a new document in the "users" collection with the user's UID as the document ID
    await FirebaseFirestore.instance.collection("users").doc(uid).set({
      'name': name,
      'email': email,
    });
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
              Text(AppTexts.signUp, style: TextStyles.headingStyle.copyWith(color: defaultColorScheme.primary)),
              const Gap(CustomPadding.mediumSpace),
              Text(AppTexts.signUpDescription, style: TextStyles.hintStyleDefault.copyWith(color: defaultColorScheme.secondary)),
              const Gap(CustomPadding.defaultSpace),
              //first name
              CustomTextfield(
                controller: _name,
                name: AppTexts.firstName,
                hintText: AppTexts.hintFirstName,
                obscureText: false,
              ),
              const Gap(CustomPadding.defaultSpace),
              //email
              CustomTextfield(
                controller: _email,
                name: AppTexts.email,
                hintText: AppTexts.hintEmail,
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
              ),
              const Gap(CustomPadding.defaultSpace),
              //password
              CustomTextfield(
                controller: _password,
                name: AppTexts.password,
                hintText: AppTexts.hintPassword,
                obscureText: true,
              ),
              const Gap(CustomPadding.defaultSpace),
              //confirm Password
              CustomTextfield(
                controller: _confirmPassword,
                name: AppTexts.confirmPassword,
                hintText: AppTexts.confirmPassword,
                obscureText: true,
              ), //password
              const Gap(CustomPadding.bigSpace),
              //sign up button
              ElevatedButton(
                onPressed: () => signUp(),
                child: Text(AppTexts.signUp),
              ),
              const Gap(CustomPadding.bigSpace),
              Row(
                // Redirection to sign in page if user does have an account
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppTexts.notNew, style: TextStyles.hintStyleMedium.copyWith(color: defaultColorScheme.secondary)),
                  const Gap(CustomPadding.smallSpace),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    child: Text(
                      AppTexts.signIn,
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
