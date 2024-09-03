// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/enum/debts_box.dart';
import 'package:track_bud/utils/debts/split_widget.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widgets.dart';
import 'package:track_bud/views/subpages/group_overview_screeen.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupOverviewScreen(
              groupName: '**group**',
            ), // '**FriendName**'
          ),
        );
      },
      child: CustomShadow(
          child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: EdgeInsets.all(CustomPadding.defaultSpace),
        decoration: BoxDecoration(color: CustomColor.white, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              // Friend's profile picture
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Container(
                  width: 40,
                  height: 40,
                  color: Colors.red, // Placeholder color, replace with actual profile picture
                ),
              ),
              // Friend's name
              title: Text(
                'Name',
                style: TextStyles.regularStyleMedium,
              ),
              // Debt or credit information
              subtitle: Text(
                '**Date**',
                style: TextStyles.hintStyleDefault.copyWith(fontSize: TextStyles.fontSizeHint),
              ),
              // Navigation arrow
              trailing: Text(
                '10000,00€',
                style: TextStyles.regularStyleMedium,
              ),
              minVerticalPadding: 0,
              contentPadding: EdgeInsets.zero,
            ),
            Container(
              child: Divider(
                color: CustomColor.grey,
              ),
            ),
            Gap(
              CustomPadding.mediumSpace,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    child: Stack(
                      children: List.generate(4, (index) {
                        return Positioned(
                          left: index * 25,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: CustomColor.white),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                BalanceState(
                  colorScheme: DebtsColorScheme.blue,
                )
              ],
            ),
          ],
        ),
      )),
    );
  }
}

class BalanceState extends StatelessWidget {
  final DebtsColorScheme colorScheme;
  final String? amount;

  const BalanceState({
    Key? key,
    required this.colorScheme,
    this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: CustomPadding.mediumSpace, vertical: CustomPadding.smallSpace),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: colorScheme.color,
      ),
      child: Text(
        amount ?? 'quitt',
        style: TextStyles.regularStyleMedium.copyWith(color: colorScheme.textColor),
      ),
    );
  }
}

class DebtsOverview extends StatefulWidget {
  const DebtsOverview({super.key});

  @override
  State<DebtsOverview> createState() => _DebtsOverviewState();
}

class _DebtsOverviewState extends State<DebtsOverview> {
  // Method to open a popup window to pay off debts
  Future _payOffDebts() => showDialog(
        context: context,
        builder: (context) => Dialog(
          insetPadding: EdgeInsets.all(16),
          child: Container(
            width: MediaQuery.of(context).size.width - 32,
            padding: EdgeInsets.all(CustomPadding.defaultSpace),
            decoration: BoxDecoration(
              color: CustomColor.backgroundPrimary,
              borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppTexts.payOffDebts,
                  style: TextStyles.titleStyleMedium,
                ),
                Gap(CustomPadding.defaultSpace),
                Text(
                  AppTexts.payOffDebts,
                  style: TextStyles.hintStyleDefault,
                ),
                Gap(CustomPadding.defaultSpace),
                ByAmountTile(),
                Gap(CustomPadding.defaultSpace),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    //TODO: update debts in db
                  },
                  child: Text(AppTexts.payOff),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: EdgeInsets.all(CustomPadding.defaultSpace),
        decoration: BoxDecoration(color: CustomColor.white, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
        child: Column(
          children: [
            ListTile(
              // Friend's profile picture
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Container(
                  width: 40,
                  height: 40,
                  color: Colors.red, // Placeholder color, replace with actual profile picture
                ),
              ),
              // Friend's name
              title: Text(
                'Name',
                style: TextStyles.regularStyleMedium,
              ),
              // Debt or credit information

              // Navigation arrow
              trailing: BalanceState(
                //TODO: Change ColorScheme based on amount
                colorScheme: DebtsColorScheme.red,
                amount: '-120€',
              ),
              minVerticalPadding: 0,
              contentPadding: EdgeInsets.zero,
            ),
            Gap(
              CustomPadding.smallSpace,
            ),
            GestureDetector(
              onTap: () {
                _payOffDebts();
              },
              child: Text(
                AppTexts.payOff,
                style: TextStyles.regularStyleDefault.copyWith(
                  color: CustomColor.bluePrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Displays on the 
class GroupChoice extends StatelessWidget {
  final void Function() onTap;
  const GroupChoice({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace, vertical: CustomPadding.mediumSpace),
        decoration: BoxDecoration(
          color: CustomColor.white,
          borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Container(
              width: 40,
              height: 40,
              color: Colors.red,
            ),
          ),
          title: Text(
            'Gruppenname',
            style: TextStyles.regularStyleMedium,
          ),
          trailing: Container(
            width: 65,
            height: 30,
            child: Stack(
              children: List.generate(3, (index) {
                return Positioned(
                  left: index * 18,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: CustomColor.white, width: 2),
                    ),
                  ),
                );
              }),
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
