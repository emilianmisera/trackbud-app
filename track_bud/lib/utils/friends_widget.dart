import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';
import 'package:track_bud/views/subpages/friend_profile_screen.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
            color: CustomColor.white,
            borderRadius: BorderRadius.circular(Constants.buttonBorderRadius)),
        child: ListTile(
          // ProfilePicture
          leading: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Container(
                      width: 40,
                      height: 40,
                      color: Colors.red,
                    ),
                  ),
          // Name of Friend
          title: Text(
            'Name',
            style: CustomTextStyle.regularStyleMedium,
          ),
          // debts or credit
          subtitle: Text(
            'bekommt insgesamt ...',
            style: CustomTextStyle.hintStyleDefault
                .copyWith(fontSize: CustomTextStyle.fontSizeHint),
          ),
          // Amount
          trailing: Icon(Icons.arrow_forward_ios_rounded, color: CustomColor.black,),
          minVerticalPadding: CustomPadding.defaultSpace,
          // Navigate to FriendDetailScreen
          onTap: (){
            Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FriendProfileScreen(friendName: '**FreundName**',),
                      ),
                    );
          },
        ),
      ),
    );
  }
}

class FriendProfileDetails extends StatelessWidget {
  const FriendProfileDetails({super.key,});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
            color: CustomColor.white,
            borderRadius: BorderRadius.circular(Constants.buttonBorderRadius),
            ),
        padding: EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace, vertical: CustomPadding.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppString.debts, style: CustomTextStyle.regularStyleDefault,),
          SizedBox(height: CustomPadding.mediumSpace,),

          //TODO: add Amount Box

          SizedBox(height: CustomPadding.defaultSpace,),
          Text(AppString.sameGroups, style: CustomTextStyle.regularStyleDefault,),
          SizedBox(height: CustomPadding.mediumSpace,),

          //TODO: add same Groups


        ],
      ),
    );
  }
}