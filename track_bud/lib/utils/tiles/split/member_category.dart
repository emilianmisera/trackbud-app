import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';

/// This Widget shows the information which user payed and in which category it has been assigned
class MemberCategory extends StatelessWidget {
  final String member;
  final String? imageURL;
  final String categoryName;
  final Image categoryIcon;
  final Color backgroundColor;
  const MemberCategory(
      {super.key,
      required this.member,
      this.imageURL,
      required this.categoryName,
      required this.categoryIcon,
      required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
