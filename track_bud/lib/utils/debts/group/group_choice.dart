import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/textfield_widgets.dart';

/// This Widget dispalys a Group that must be selected before adding a new GroupSplit
class GroupChoice extends StatelessWidget {
  final void Function() onTap;
  const GroupChoice({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace, vertical: CustomPadding.mediumSpace),
        decoration: BoxDecoration(
          color: CustomColor.white,
          borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Container(
              width: 40,
              height: 40,
              color: Colors.red,
            ),
          ),
          title: Text('Gruppenname', style: TextStyles.regularStyleMedium),
          trailing: Container(
            width: 65,
            height: 30,
            child: Stack(
              children: List.generate(3, (index) {
                return Positioned(
                  left: index * 18,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: CustomColor.white, width: 2),
                    ),
                  ),
                );
              }),
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
