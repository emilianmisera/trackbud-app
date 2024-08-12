import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            // spacing between content and screen
            padding: EdgeInsets.only(
                top: MediaQuery.sizeOf(context).height *
                    CustomPadding.topSpaceSettingsScreen,
                left: CustomPadding.defaultSpace,
                right: CustomPadding.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect( // ProfilePicture
                    borderRadius: BorderRadius.circular(100.0),
                    child: Container(
                      width: Constants.profilePictureSettingPage,
                      height: Constants.profilePictureSettingPage,
                      color: Colors.red,
                    ),
                  ),
                ),
                SizedBox(
                  height: CustomPadding.mediumSpace,
                ),
                Center(
                    child: Text( // FirstName
                  'Placeholder Name',
                  style: CustomTextStyle.titleStyleMedium,
                )),
                SizedBox(
                  height: CustomPadding.smallSpace,
                ),
                Center(
                    child: Text( //email
                  'PlaceholderMail@gmail.com',
                  style: CustomTextStyle.hintStyleDefault,
                )),
                SizedBox(
                  height: CustomPadding.bigbigSpace,
                ),
                Text(
                  AppString.preferences,
                  style: CustomTextStyle.regularStyleMedium,
                ),
                SizedBox(
                  height: CustomPadding.defaultSpace,
                ),
                CustomShadow( // edit Profile Button
                  child: TextButton.icon(
                    onPressed: () {},
                    label: Text(
                      AppString.editProfile,
                      style: CustomTextStyle.regularStyleDefault,
                    ),
                    icon: SvgPicture.asset(AssetImport.userEdit),
                    style: ButtonStyle(
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                SizedBox(
                  height: CustomPadding.mediumSpace,
                ),
                CustomShadow( // accAdjustment button
                  child: TextButton.icon(
                    onPressed: () {},
                    label: Text(
                      AppString.accAdjustments,
                      style: CustomTextStyle.regularStyleDefault,
                    ),
                    icon: SvgPicture.asset(AssetImport.settings),
                    style: ButtonStyle(
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                SizedBox(
                  height: CustomPadding.mediumSpace,
                ),
                CustomShadow( // notification button
                  child: TextButton.icon(
                    onPressed: () {},
                    label: Text(
                      AppString.notifications,
                      style: CustomTextStyle.regularStyleDefault,
                    ),
                    icon: SvgPicture.asset(AssetImport.bell),
                    style: ButtonStyle(
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                SizedBox(
                  height: CustomPadding.mediumSpace,
                ),
                CustomShadow( // aboutTrackbut button
                  child: TextButton.icon(
                    onPressed: () {},
                    label: Text(
                      AppString.abouTrackBud,
                      style: CustomTextStyle.regularStyleDefault,
                    ),
                    icon: SvgPicture.asset(AssetImport.info),
                    style: ButtonStyle(
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                SizedBox(
                  height: CustomPadding.mediumSpace,
                ),
                CustomShadow( // Logout Button
                  child: TextButton.icon(
                    onPressed: () {},
                    label: Text(
                      AppString.logout,
                      style: CustomTextStyle.regularStyleDefault,
                    ),
                    icon: SvgPicture.asset(AssetImport.logout),
                    style: ButtonStyle(
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                SizedBox(
                  height: CustomPadding.mediumSpace,
                ),
                CustomShadow( // delete Account Button
                  child: TextButton.icon(
                    onPressed: () {},
                    label: Text(
                      AppString.editProfile,
                      style: TextStyle(
                        fontFamily: CustomTextStyle.fontFamily,
                        fontSize: CustomTextStyle.fontSizeDefault,
                        fontWeight: CustomTextStyle.fontWeightDefault,
                        color: CustomColor.red,
                      ),
                    ),
                    icon: SvgPicture.asset(
                      AssetImport.trash,
                      color: CustomColor.red,
                      
                    ),
                    style: ButtonStyle(
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
