import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield.dart';

class DeleteAccountPopUp extends StatelessWidget {
  final void Function() onPressed;
  const DeleteAccountPopUp({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _passwordController = TextEditingController();

    return AlertDialog(
      title: Text(
        AppTexts.deleteAcc,
        style: TextStyles.titleStyleMedium,
      ),
      content: Container(
        width: double.infinity,
        height: 235,
        child: Column(
          children: [
            Text(AppTexts.deleteAccDescribtion, style: TextStyles.hintStyleDefault),
            Gap(CustomPadding.defaultSpace),
            CustomTextfield(
              name: AppTexts.password,
              obscureText: true,
              hintText: AppTexts.hintPassword,
              controller: _passwordController,
              autofocus: true,
            ),
            Gap(CustomPadding.defaultSpace),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(backgroundColor: CustomColor.red),
              child: Text(AppTexts.deleteAcc),
            )
          ],
        ),
      ),
      insetPadding: EdgeInsets.all(CustomPadding.defaultSpace),
      backgroundColor: CustomColor.backgroundPrimary,
      surfaceTintColor: CustomColor.backgroundPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Constants.contentBorderRadius),
        ),
      ),
    );
  }
}
