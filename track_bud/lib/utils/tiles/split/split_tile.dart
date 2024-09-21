import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/enum/categories.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/tiles/split/member_category.dart';

class SplitTile extends StatelessWidget {
  final Widget widget;
  const SplitTile({super.key, required this.widget});

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
                  MemberCategory(
                    backgroundColor: Categories.lebensmittel.color,
                    categoryIcon: Categories.lebensmittel.icon,
                    categoryName: Categories.lebensmittel.name,
                    member: 'Test',
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
          )),
    );
  }
}
