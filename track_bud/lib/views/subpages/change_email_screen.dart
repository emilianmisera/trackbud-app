import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final TextEditingController _currentEmailController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          // Padding adds spacing around the content inside the screen.
          padding: EdgeInsets.only(
            top: MediaQuery.sizeOf(context).height * CustomPadding.topSpace -
                Constants
                    .defaultAppBarHeight, // Top padding based on screen height
            left: CustomPadding.defaultSpace, // Left padding
            right: CustomPadding.defaultSpace, // Right padding
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppString.changeEmail, // The heading text
                style: CustomTextStyle
                    .headingStyle, // The text style for the heading.
              ),
              SizedBox(
                height: CustomPadding
                    .mediumSpace, // Adds vertical space between the heading and the next element.
              ),
              Text(
                AppString.changeEmailDesscribtion, // The description text
                style: CustomTextStyle
                    .hintStyleDefault, // The text style for the description.
              ),
              SizedBox(
                height: CustomPadding
                    .bigSpace, // Adds more vertical space before the next element.
              ),
              CustomTextfield(
                  name: AppString.currentEmail,
                  hintText: AppString.currentEmailHint,
                  controller: _currentEmailController),
              SizedBox(height: CustomPadding.defaultSpace),
              CustomTextfield(
                  name: AppString.newEmail,
                  hintText: AppString.newEmailHint,
                  controller: _emailController),
              SizedBox(height: CustomPadding.defaultSpace),
              // Confirm Password text field
              CustomTextfield(
                  name: AppString.password,
                  hintText: AppString.hintPassword,
                  controller: _passwordController),
            ],
          ),
        ),
      ),
      bottomSheet: 
        Container(
          margin: EdgeInsets.only(
            bottom: MediaQuery.sizeOf(context).height *
                CustomPadding
                    .bottomSpace, // Bottom margin based on screen height
            left: CustomPadding.defaultSpace, // Left margin
            right: CustomPadding.defaultSpace, // Right margin
          ),
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () async {},
            child: Text(AppString.save),
          ),
        ),
    );
  }
}
