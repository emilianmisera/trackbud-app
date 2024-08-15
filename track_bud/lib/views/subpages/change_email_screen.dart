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
  // Controllers for the text fields
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
              // The heading text
              Text(
                AppString.changeEmail,
                style: CustomTextStyle.headingStyle,
              ),
              SizedBox(
                height: CustomPadding.mediumSpace,
              ),
              // The description text
              Text(
                AppString.changeEmailDesscribtion,
                style: CustomTextStyle.hintStyleDefault,
              ),
              SizedBox(
                height: CustomPadding.bigSpace,
              ),
              // Current email text field
              CustomTextfield(
                  name: AppString.currentEmail,
                  hintText: AppString.currentEmailHint,
                  controller: _currentEmailController),
              SizedBox(height: CustomPadding.defaultSpace),
              // new email text field
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
            // TODO: Implement save functionality
          },
          child: Text(AppString.save),
        ),
      ),
    );
  }
}
