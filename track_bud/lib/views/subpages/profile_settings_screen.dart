import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:track_bud/utils/buttons_widget.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';
import 'package:track_bud/views/subpages/change_password_screen.dart';

// Widget for the Profile Settings Screen
class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});
  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  // Controllers for text fields
  final TextEditingController _nameController =
      TextEditingController(text: 'PlaceholderName');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with title
      appBar: AppBar(
        title: Text(AppString.accAdjustments,
            style: CustomTextStyle.regularStyleMedium),
      ),
      // Main body of the screen
      body: SingleChildScrollView(
        child: Padding(
          // Custom padding calculation
          padding: EdgeInsets.only(
              top: MediaQuery.sizeOf(context).height *
                      CustomPadding.topSpaceAuth -
                  Constants.defaultAppBarHeight,
              left: CustomPadding.defaultSpace,
              right: CustomPadding.defaultSpace),
          child: Column(
            children: [
              // Profile picture
              Center(
                child: GestureDetector(
                  onTap: () {
                    // TODO: Implement profile picture change functionality
                  },
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children:[ 
                      ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        width: Constants.profilePictureAccountEdit,
                        height: Constants.profilePictureAccountEdit,
                        color: Colors.red,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        width: 30,
                        height: 30,
                        color: CustomColor.grey,
                        child: SvgPicture.asset(AssetImport.camera, fit: BoxFit.scaleDown,),
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
              LockedEmailTextfield(email: 'placeholder@gmail.com'), //TODO: Place User Email here
              SizedBox(height: CustomPadding.defaultSpace),
              AccAdjustmentButton(icon: AssetImport.userEdit, name: AppString.changeEmail, onPressed: (){}, padding: EdgeInsets.symmetric(horizontal: CustomPadding.mediumSpace),),
              AccAdjustmentButton(icon: AssetImport.userEdit, name: AppString.changePassword, onPressed: (){Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePasswordScreen(),
                      ),
                    );}, padding: EdgeInsets.symmetric(horizontal: CustomPadding.mediumSpace),),

            ],
          ),
        ),
      ),
      // Bottom sheet with Save button
      bottomSheet: Container(
        // Margin calculations for proper spacing
        margin: EdgeInsets.only(
          bottom: MediaQuery.sizeOf(context).height * CustomPadding.bottomSpace,
          left: CustomPadding.defaultSpace,
          right: CustomPadding.defaultSpace,
        ),
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () {
            // TODO: Implement save functionality
          },
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
