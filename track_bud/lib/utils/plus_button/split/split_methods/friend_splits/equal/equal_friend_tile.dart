import 'package:flutter/material.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';

class EqualFriendTile extends StatelessWidget {
  final UserModel user;
  final double splitAmount;

  const EqualFriendTile({
    super.key,
    required this.user,
    required this.splitAmount,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return CustomShadow(
      child: Container(
        decoration: BoxDecoration(
          color: defaultColorScheme.surface,
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
          title: Text(user.name, style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: defaultColorScheme.surface,
                  borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
                  border: Border.all(color: defaultColorScheme.outline),
                ),
                child: Text('${splitAmount.toStringAsFixed(2)}€',
                    style: TextStyles.hintStyleDefault.copyWith(color: defaultColorScheme.secondary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
