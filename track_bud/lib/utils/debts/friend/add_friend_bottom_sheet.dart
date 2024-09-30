import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield.dart';

//TODO: Delete file because unused
/// This Widget shows a bottom Sheet for adding new Friends
class AddFriendBottomSheet extends StatelessWidget {
  final void Function() onPressed;
  const AddFriendBottomSheet({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailFriendController = TextEditingController();
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Container(
      height: MediaQuery.sizeOf(context).height * Constants.modalBottomSheetHeight,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: defaultColorScheme.surface,
        borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: CustomPadding.defaultSpace, right: CustomPadding.defaultSpace, bottom: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(CustomPadding.mediumSpace),
            Center(
                // grabber
                child: Container(
                    width: 36,
                    height: 5,
                    decoration:
                        const BoxDecoration(color: CustomColor.grabberColor, borderRadius: BorderRadius.all(Radius.circular(100))))),
            const Gap(CustomPadding.defaultSpace),
            Text(AppTexts.addFriend, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
            const Gap(CustomPadding.mediumSpace),
            CustomTextfield(name: AppTexts.email, hintText: AppTexts.hintEmail, controller: emailFriendController),
            const Gap(CustomPadding.bigSpace),
            ElevatedButton(onPressed: onPressed, child: Text(AppTexts.shareFriendLink)),
          ],
        ),
      ),
    );
  }
}
