//currently unused

/* import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield.dart';

class DeleteAccountPopUp extends StatelessWidget {
  final void Function(String) onPressed;
  const DeleteAccountPopUp({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final defaultColorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(
        AppTexts.deleteAcc,
        style: TextStyles.titleStyleMedium.copyWith(color: defaultColorScheme.primary),
      ),
      content: SizedBox(
        width: double.infinity,
        height: 235,
        child: Column(
          children: [
            Text(AppTexts.deleteAccDescribtion, style: TextStyles.hintStyleDefault.copyWith(color: defaultColorScheme.secondary)),
            const Gap(CustomPadding.defaultSpace),
            CustomTextfield(
              name: AppTexts.password,
              obscureText: true,
              hintText: AppTexts.hintPassword,
              controller: passwordController,
              autofocus: true,
            ),
            const Gap(CustomPadding.defaultSpace),
            ElevatedButton(
              onPressed: () => onPressed(passwordController.text),
              style: ElevatedButton.styleFrom(backgroundColor: CustomColor.red),
              child: Text(AppTexts.deleteAcc),
            )
          ],
        ),
      ),
      insetPadding: const EdgeInsets.all(CustomPadding.defaultSpace),
      backgroundColor: defaultColorScheme.surface,
      surfaceTintColor: defaultColorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Constants.contentBorderRadius),
        ),
      ),
    );
  }
}
 */