import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/textfield_widget.dart';

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
          onTap: (){},
        ),
      ),
    );
  }
}