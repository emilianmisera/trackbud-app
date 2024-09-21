import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';

/// This Widget shows an added Split.
/// It will be displayed in Group Overview Screen and in Friend Profile Screen.
class SplitTile extends StatelessWidget {
  final Widget widget;
  final String member;
  final String? imageURL;
  final String categoryName;
  final Image categoryIcon;
  final Color backgroundColor;
  const SplitTile(
      {super.key,
      required this.widget,
      required this.member,
      this.imageURL,
      required this.categoryName,
      required this.categoryIcon,
      required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.all(CustomPadding.defaultSpace),
        decoration: BoxDecoration(color: CustomColor.white, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 // information which user payed and in which category it has been assigned
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: backgroundColor),
                  padding: const EdgeInsets.only(right: CustomPadding.defaultSpace),
                  child: Row(
                    children: [
                      // Profile Picture
                      const SizedBox(
                        width: 25,
                        height: 25,
                        child: /* Image.network(imageURL, fit: BoxFit.cover) */ Icon(Icons.person, size: 25, color: Colors.grey),
                      ),
                      const Gap(CustomPadding.mediumSpace),
                      // Category
                      categoryIcon,
                      const Gap(CustomPadding.smallSpace),
                      Text(member, style: TextStyles.regularStyleDefault.copyWith(fontSize: TextStyles.fontSizeHint)),
                    ],
                  ),
                ),
                Text('125€', style: TextStyles.regularStyleMedium)
              ],
            ),
            const Gap(CustomPadding.defaultSpace),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Einkauf', style: TextStyles.regularStyleMedium),
                Text('-45€', style: TextStyles.regularStyleDefault.copyWith(color: CustomColor.red))
              ],
            ),
            const Divider(color: CustomColor.grey),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Datum', style: TextStyles.hintStyleDefault.copyWith(fontSize: TextStyles.fontSizeHint)), widget])
          ],
        ),
      ),
    );
  }
}
