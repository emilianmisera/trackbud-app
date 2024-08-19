import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';

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
            ],
          ),
        ),
      ),
    );
  }
}
