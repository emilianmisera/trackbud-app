import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:track_bud/services/auth/auth_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';
import 'package:track_bud/views/at_signup/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmationPasswordController =
      TextEditingController();

  final AuthService _authService = AuthService();

  // Method to handle sign-up
  Future<void> _handleSignUp() async {
    // Retrieve user inputs
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmationPasswordController.text.trim();

    // Validate inputs
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppString.signupEmptyField),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppString.signupPasswordsDontMatch),
        ),
      );
      return;
    }

    try {
      // Attempt to create a new user using the AuthService
      UserCredential userCredential =
          await _authService.createUserWithEmailAndPassword(email, password);

      // Handle successful sign-up (navigate to home screen or show success message)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "${AppString.signupSucessful}: ${userCredential.user?.email}"),
        ),
      );

      // navigate to Login Screen
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginScreen()));
    } on FirebaseAuthException catch (e) {
      // Handle sign-up failure (show error message)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("${AppString.signupFailedSnackbar}: ${e.message ?? e.code}"),
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
                AppString.signUp,
                style: CustomTextStyle.headingStyle,
              ),
              SizedBox(
                height: CustomPadding.mediumSpace,
              ),
              Text(
                AppString.signUpDescription,
                style: CustomTextStyle.hintStyleDefault,
              ),
              SizedBox(
                height: CustomPadding.defaultSpace,
              ),
              Textfield(
                //first name
                controller: _nameController,
                name: AppString.firstName,
                hintText: AppString.hintFirstName, obscureText: false,
              ),
              SizedBox(
                height: CustomPadding.defaultSpace,
              ),
              Textfield(
                //email
                controller: _emailController,
                name: AppString.email,
                hintText: AppString.hintEmail, obscureText: false,
              ),
              SizedBox(
                height: CustomPadding.defaultSpace,
              ),
              Textfield(
                //password
                controller: _passwordController,
                name: AppString.password,
                hintText: AppString.hintPassword, obscureText: true,
              ),
              SizedBox(
                height: CustomPadding.defaultSpace,
              ),
              Textfield(
                //confirm Password
                controller: _confirmationPasswordController,
                name: AppString.confirmPassword,
                hintText: AppString.confirmPassword, obscureText: true,
              ), //password
              SizedBox(
                height: CustomPadding.bigSpace,
              ),
              ElevatedButton(
                //sign up button
                onPressed: _handleSignUp,
                child: Text(
                  AppString.signUp,
                ),
              ),
              SizedBox(
                height: CustomPadding.bigSpace,
              ),
              Row(
                // Redirection to sign in page if user does have an account
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppString.notNew,
                      style: CustomTextStyle.hintStyleMedium),
                  SizedBox(
                    width: CustomPadding.smallSpace,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    },
                    child: Text(
                      AppString.signIn,
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
