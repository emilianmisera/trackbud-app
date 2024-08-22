import 'dart:math';

import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/friends_widget.dart';
import 'package:track_bud/utils/strings.dart';

class FriendProfileScreen extends StatefulWidget {
  final String friendName;
  const FriendProfileScreen({super.key, required this.friendName});

  @override
  State<FriendProfileScreen> createState() => _FriendProfileScreenState();
}

class _FriendProfileScreenState extends State<FriendProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.friendName,
          style: CustomTextStyle.regularStyleMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          // spacing between content and screen
          padding: EdgeInsets.only(
              top: CustomPadding.defaultSpace,
              left: CustomPadding.defaultSpace,
              right: CustomPadding.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Container(
                    width: Constants.profilePictureAccountEdit,
                    height: Constants.profilePictureAccountEdit,
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(height: CustomPadding.bigSpace),
              FriendProfileDetails(),
              SizedBox(height: CustomPadding.defaultSpace),
              Text(AppString.history, style: CustomTextStyle.regularStyleMedium,),
              SizedBox(height: CustomPadding.mediumSpace,),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        // Margin is applied to the bottom of the button and the sides for proper spacing.
        margin: EdgeInsets.only(
          bottom: MediaQuery.sizeOf(context).height *
              CustomPadding.bottomSpace, // Bottom margin based on screen height
          left: CustomPadding.defaultSpace, // Left margin
          right: CustomPadding.defaultSpace, // Right margin
        ),
        child: ElevatedButton(
            // Enable button only if profile has changed
            onPressed: (){},
            style: ElevatedButton.styleFrom(
              // Set button color based on whether profile has changed
              disabledBackgroundColor: CustomColor.bluePrimary.withOpacity(0.5),
              backgroundColor: CustomColor.bluePrimary
            ),
            child: Text(AppString.payOffDebts),
          ),
      ),
    );
  }
}
