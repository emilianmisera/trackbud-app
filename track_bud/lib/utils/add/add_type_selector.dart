import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/add/add_split.dart';
import 'package:track_bud/utils/add/add_transaction.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/group/group_choice.dart';
import 'package:track_bud/utils/strings.dart';

class AddTypeSelector extends StatelessWidget {
  const AddTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * Constants.addBottomSheetHeight,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: CustomColor.backgroundPrimary,
        borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: CustomPadding.defaultSpace, right: CustomPadding.defaultSpace, bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(CustomPadding.mediumSpace),
            Center(
              child: Container(
                // grabber
                width: 36,
                height: 5,
                decoration: BoxDecoration(
                  color: CustomColor.grabberColor,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
              ),
            ),
            Gap(CustomPadding.defaultSpace),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the bottom sheet
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => AddTransaction(),
                  );
                },
                child: Text(AppTexts.addNewTransaction)),
            Gap(CustomPadding.mediumSpace),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the bottom sheet
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => AddSplit(
                      isGroup: false,
                    ),
                  );
                },
                child: Text(AppTexts.addNewFriendSplit)),
            Gap(CustomPadding.mediumSpace),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Gruppe auswählen',
                      style: TextStyles.titleStyleMedium,
                    ),
                    content: Container(
                      width: double.maxFinite,
                      height: 235,
                      child: Column(
                        children: [
                          GroupChoice(
                            onTap: () {
                              Navigator.pop(context); // Close the window
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => AddSplit(
                                  isGroup: true,
                                ),
                              );
                            },
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
                  ),
                );
              },
              child: Text(AppTexts.addNewGroupSplit),
            ),
          ],
        ),
      ),
    );
  }
}
