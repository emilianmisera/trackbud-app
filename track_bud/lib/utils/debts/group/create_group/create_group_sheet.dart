import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/group/create_group/grouptile.dart';
import 'package:track_bud/utils/strings.dart';

class CreateGroupSheet extends StatelessWidget {
  const CreateGroupSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _createGroupController = TextEditingController();
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
                    Gap(CustomPadding.mediumSpace),
                    Center(
                      child:
                          // grabber
                          Container(
                        width: 36,
                        height: 5,
                        decoration: BoxDecoration(color: CustomColor.grabberColor, borderRadius: BorderRadius.all(Radius.circular(100))),
                      ),
                    ),
                    Gap(CustomPadding.defaultSpace),
                    Center(
                      child: Text(AppTexts.addGroup, style: TextStyles.regularStyleMedium),
                    ),
                    Gap(CustomPadding.mediumSpace),
                    GroupTitle(createGroupController: _createGroupController),
                    Gap(CustomPadding.defaultSpace),
                    Text(AppTexts.addMembers, style: TextStyles.regularStyleMedium),
                    Gap(CustomPadding.mediumSpace),
                    //TODO: add ListView with Friends
                    Spacer(),
                    ElevatedButton(
                        onPressed: ()=> Navigator.pop(context) ,
                        child: Text(AppTexts.addGroup)),
                  ],
                ),
              ),
            );
  }
}