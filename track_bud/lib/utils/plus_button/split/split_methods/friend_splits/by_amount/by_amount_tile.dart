import 'package:flutter/material.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/textfields/textfield_split_by_amount.dart';

/// Widget for displaying split by amount tile
class ByAmountTile extends StatelessWidget {
  final UserModel user;
  final TextEditingController controller;
  final ValueChanged<String> onAmountChanged;
  final FocusNode focusNode;

  const ByAmountTile({super.key, required this.user, required this.controller, required this.onAmountChanged, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return CustomShadow(
      child: Container(
        decoration: BoxDecoration(color: defaultColorScheme.surface, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace, vertical: CustomPadding.defaultSpace),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: SizedBox(
              width: Constants.addGroupPPSize,
              height: Constants.addGroupPPSize,
              child: user.profilePictureUrl.isNotEmpty
                  ? Image.network(user.profilePictureUrl, fit: BoxFit.cover)
                  : const Icon(Icons.person, color: Colors.grey),
            ),
          ),
          title: Text(user.name, style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
          trailing: Container(
            width: 80,
            decoration: BoxDecoration(
                border: Border.all(color: defaultColorScheme.outline), borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
            child: TextFieldByAmount(
              focusNode: focusNode, // Use the provided focus node
              controller: controller,
              inputStyle: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary),
              suffixStyle: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary),
              onChanged: onAmountChanged,
            ),
          ),
        ),
      ),
    );
  }
}
