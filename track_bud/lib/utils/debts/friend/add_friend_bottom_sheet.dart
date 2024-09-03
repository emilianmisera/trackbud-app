import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield.dart';

class AddFriendBottomSheet extends StatelessWidget {
  final void Function() onPressed;
  const AddFriendBottomSheet({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailFriendController = TextEditingController();
    return Container(
              height: MediaQuery.sizeOf(context).height * Constants.modalBottomSheetHeight,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: CustomColor.backgroundPrimary,
                borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: CustomPadding.defaultSpace, right: CustomPadding.defaultSpace, bottom: 50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Gap(CustomPadding.mediumSpace),
                    Center(
                      child: Container(
                        // grabber
                        width: 36,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: CustomColor.grabberColor,
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                      ),
                    ),
                    const Gap(CustomPadding.defaultSpace),
                    Text(
                      AppTexts.addFriend,
                      style: TextStyles.regularStyleMedium,
                    ),
                    const Gap(CustomPadding.mediumSpace),
                    CustomTextfield(name: AppTexts.email, hintText: AppTexts.hintEmail, controller: emailFriendController),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: onPressed,
                        child: Text(AppTexts.addFriend)),
                  ],
                ),
              ),
            );
  }
}