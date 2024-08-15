import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:track_bud/utils/buttons_widget.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';
import 'package:track_bud/views/subpages/change_email_screen.dart';
import 'package:track_bud/views/subpages/change_password_screen.dart';
import 'dart:math' show min;

// Profile Settings Screen
class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});
  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  // Controller for the name text field
  final TextEditingController _nameController =
      TextEditingController(text: 'PlaceholderName');
  
  // State variables to track changes
  bool _isProfileChanged = false;
  String _initialName = 'PlaceholderName';
  bool _isProfilePictureChanged = false;

  @override
  void initState() {
    super.initState();
    // Add listener to name controller to detect changes
    _nameController.addListener(_checkIfProfileChanged);
  }

  // Function to check if profile has been modified
  void _checkIfProfileChanged() {
    setState(() {
      _isProfileChanged =
          _nameController.text != _initialName || _isProfilePictureChanged;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with title
      appBar: AppBar(
        title: Text(AppString.accAdjustments,
            style: CustomTextStyle.regularStyleMedium),
      ),
      body: SingleChildScrollView(
        child: Padding(
          // add Space
          padding: EdgeInsets.only(
              top: MediaQuery.sizeOf(context).height *
                      CustomPadding.topSpaceAuth -
                  Constants.defaultAppBarHeight,
              left: CustomPadding.defaultSpace,
              right: CustomPadding.defaultSpace,
              bottom: MediaQuery.sizeOf(context).height * CustomPadding.bottomSpace
              ),
              
          child: Column(
            children: [
              // Profile picture widget
              Center(
                child: GestureDetector(
                  onTap: () {
                    // TODO: Implement profile picture change functionality
                    setState(() {
                      _isProfilePictureChanged = true;
                      _checkIfProfileChanged();
                    });
                  },
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      // Main profile picture
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Container(
                          width: Constants.profilePictureAccountEdit,
                          height: Constants.profilePictureAccountEdit,
                          color: Colors.red,
                        ),
                      ),
                      // Camera icon overlay
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Container(
                          width: 30,
                          height: 30,
                          color: CustomColor.grey,
                          child: SvgPicture.asset(
                            AssetImport.camera,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: CustomPadding.bigSpace),
              // First Name text field
              CustomTextfield(
                  name: AppString.firstName,
                  hintText: AppString.hintFirstName,
                  controller: _nameController),
              SizedBox(height: CustomPadding.defaultSpace),
              // Email text field (locked)
              LockedEmailTextfield(
                  email: 'placeholder@gmail.com'), //TODO: Place User Email here
              SizedBox(height: CustomPadding.defaultSpace),
              // Change Email button
              AccAdjustmentButton(
                icon: AssetImport.email,
                name: AppString.changeEmail,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeEmailScreen(),
                    ),
                  );
                },
                padding:
                    EdgeInsets.symmetric(horizontal: CustomPadding.mediumSpace),
              ),
              // Change Password button
              AccAdjustmentButton(
                icon: AssetImport.userEdit,
                name: AppString.changePassword,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePasswordScreen(),
                    ),
                  );
                },
                padding:
                    EdgeInsets.symmetric(horizontal: CustomPadding.mediumSpace),
              ),
            ],
          ),
        ),
      ),
      // Bottom sheet with Save button
      bottomSheet: AnimatedContainer(
  duration: Duration(milliseconds: 100),
  curve: Curves.easeInOut,
  margin: EdgeInsets.only(
    bottom: min(
      MediaQuery.of(context).viewInsets.bottom > 0
    ? 0
    : MediaQuery.of(context).size.height * CustomPadding.bottomSpace,
    MediaQuery.of(context).size.height * CustomPadding.bottomSpace
    ),
    left: CustomPadding.defaultSpace,
    right: CustomPadding.defaultSpace,
  ),
  width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          // Enable button only if profile has changed
          onPressed: _isProfileChanged
              ? () {
                  // TODO: Implement save functionality
                }
              : null,
          style: ElevatedButton.styleFrom(
            // Set button color based on whether profile has changed
            disabledBackgroundColor: CustomColor.bluePrimary.withOpacity(0.5),
            backgroundColor: CustomColor.bluePrimary
          ),
          child: Text(AppString.save),
        ),
      ),
    );
  }
}

// Widget for displaying a locked email field
class LockedEmailTextfield extends StatelessWidget {
  final String email;
  const LockedEmailTextfield({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email label
        Text(
          AppString.email,
          style: CustomTextStyle.regularStyleMedium,
        ),
        SizedBox(
          height: CustomPadding.mediumSpace,
        ),
        // Custom shadow container for email display
        CustomShadow(
          child: Container(
            width: double.infinity,
            height: 65,
            padding: EdgeInsets.only(
              left: CustomPadding.defaultSpace,
              right: CustomPadding.defaultSpace,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: CustomColor.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Display the email
                Text(
                  email,
                  style: CustomTextStyle.hintStyleDefault,
                ),
                // Lock icon to indicate the field is not editable
                SvgPicture.asset(AssetImport.lock)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
