import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widgets.dart';

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
                AppTexts.changeEmail,
                style: TextStyles.headingStyle,
              ),
              Gap(
              CustomPadding.mediumSpace,
              ),
              // The description text
              Text(
                AppTexts.changeEmailDesscribtion,
                style: TextStyles.hintStyleDefault,
              ),
              Gap(
                CustomPadding.bigSpace,
              ),
              // Current email text field
              CustomTextfield(
                  name: AppTexts.currentEmail,
                  hintText: AppTexts.currentEmailHint,
                  controller: _currentEmailController),
              Gap(CustomPadding.defaultSpace),
              // new email text field
              CustomTextfield(
                  name: AppTexts.newEmail,
                  hintText: AppTexts.newEmailHint,
                  controller: _newEmailController),
              Gap(CustomPadding.defaultSpace),
              // Confirm Password text field
              CustomTextfield(
                  name: AppTexts.password,
                  obscureText: true,
                  hintText: AppTexts.hintPassword,
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
          onPressed: () async {},
          child: Text(AppTexts.save),
        ),
      ),
    );
  }
}
