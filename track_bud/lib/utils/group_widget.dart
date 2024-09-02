import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/split_widget.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';
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
            SizedBox(
              height: CustomPadding.mediumSpace,
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
                DebtsInformation(
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

enum DebtsColorScheme {
  blue,
  green,
  red,
}

class DebtsInformation extends StatelessWidget {
  final DebtsColorScheme colorScheme;
  final String? amount;

  const DebtsInformation({
    super.key,
    required this.colorScheme,
    this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(colorScheme);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: CustomPadding.mediumSpace, vertical: CustomPadding.smallSpace),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: colors.backgroundColor),
      child: Text(
        amount ?? 'quitt',
        style: TextStyles.regularStyleMedium.copyWith(color: colors.textColor),
      ),
    );
  }

  _ColorPair _getColors(DebtsColorScheme scheme) {
    switch (scheme) {
      case DebtsColorScheme.blue:
        return _ColorPair(
          backgroundColor: CustomColor.pastelBlue,
          textColor: CustomColor.bluePrimary,
        );
      case DebtsColorScheme.green:
        return _ColorPair(
          backgroundColor: CustomColor.pastelGreen,
          textColor: CustomColor.green,
        );
      case DebtsColorScheme.red:
        return _ColorPair(
          backgroundColor: CustomColor.pastelRed,
          textColor: CustomColor.red,
        );
    }
  }
}

class _ColorPair {
  final Color backgroundColor;
  final Color textColor;

  _ColorPair({required this.backgroundColor, required this.textColor});
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
                SizedBox(height: CustomPadding.defaultSpace),
                Text(
                  AppTexts.payOffDebts,
                  style: TextStyles.hintStyleDefault,
                ),
                SizedBox(height: CustomPadding.defaultSpace),
                ByAmountTile(),
                SizedBox(height: CustomPadding.defaultSpace),
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
              trailing: DebtsInformation(
                colorScheme: DebtsColorScheme.red,
                amount: '-120€',
              ),
              minVerticalPadding: 0,
              contentPadding: EdgeInsets.zero,
            ),
            SizedBox(
              height: CustomPadding.smallSpace,
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

class ChooseGroup extends StatelessWidget {
  final void Function() onTap;
  const ChooseGroup({super.key, required this.onTap});

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
