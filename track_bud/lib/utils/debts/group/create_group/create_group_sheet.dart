import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/group/create_group/grouptile.dart';
import 'package:track_bud/utils/strings.dart';

class CreateGroupSheet extends StatelessWidget {
  const CreateGroupSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController createGroupController = TextEditingController();
    return Container(
              height: MediaQuery.sizeOf(context).height * Constants.modalBottomSheetHeight,
              width: MediaQuery.sizeOf(context).width,
              decoration:
                  BoxDecoration(color: CustomColor.backgroundPrimary, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
              child: Padding(
                padding: const EdgeInsets.only(left: CustomPadding.defaultSpace, right: CustomPadding.defaultSpace, bottom: 50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(CustomPadding.mediumSpace),
                    Center(
                      child:
                          // grabber
                          Container(
                        width: 36,
                        height: 5,
                        decoration: const BoxDecoration(color: CustomColor.grabberColor, borderRadius: BorderRadius.all(Radius.circular(100))),
                      ),
                    ),
                    const Gap(CustomPadding.defaultSpace),
                    Center(
                      child: Text(AppTexts.addGroup, style: TextStyles.regularStyleMedium),
                    ),
                    const Gap(CustomPadding.mediumSpace),
                    GroupTitle(createGroupController: createGroupController),
                    const Gap(CustomPadding.defaultSpace),
                    Text(AppTexts.addMembers, style: TextStyles.regularStyleMedium),
                    const Gap(CustomPadding.mediumSpace),
                    //TODO: add ListView with Friends
                    const Spacer(),
                    ElevatedButton(
                        onPressed: ()=> Navigator.pop(context) ,
                        child: Text(AppTexts.addGroup)),
                  ],
                ),
              ),
            );
  }
}