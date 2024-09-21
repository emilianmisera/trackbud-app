import 'package:flutter/material.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';

class EqualTile extends StatelessWidget {
  final UserModel user;
  final double splitAmount;
  final bool isGroup;
  final bool isIncluded;
  final VoidCallback? onToggleInclusion;

  const EqualTile({
    Key? key,
    required this.user,
    required this.splitAmount,
    required this.isGroup,
    this.isIncluded = true,
    this.onToggleInclusion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        decoration: BoxDecoration(
          color: CustomColor.white,
          borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: CustomPadding.defaultSpace,
            vertical: CustomPadding.defaultSpace,
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: SizedBox(
              width: 40,
              height: 40,
              child: user.profilePictureUrl.isNotEmpty
                  ? Image.network(user.profilePictureUrl, fit: BoxFit.cover)
                  : const Icon(Icons.person, size: 30),
            ),
          ),
          title: Text(user.name, style: TextStyles.regularStyleDefault),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: CustomColor.white,
                  borderRadius:
                      BorderRadius.circular(Constants.contentBorderRadius),
                  border: Border.all(color: CustomColor.grey),
                ),
                child: Text('${splitAmount.toStringAsFixed(2)}€',
                    style: TextStyles.hintStyleDefault),
              ),
              if (isGroup)
                Checkbox(
                  value: isIncluded,
                  onChanged: (_) => onToggleInclusion?.call(),
                  activeColor: CustomColor.bluePrimary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
