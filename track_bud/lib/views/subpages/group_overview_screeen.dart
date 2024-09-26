import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/enum/categories.dart';
import 'package:track_bud/utils/debts/group/chart/group_debts_chart.dart';
import 'package:track_bud/utils/debts/group/group_widget.dart';
import 'package:track_bud/utils/tiles/information_tiles.dart';
import 'package:track_bud/utils/strings.dart';

class GroupOverviewScreen extends StatefulWidget {
  final String groupName;
  const GroupOverviewScreen({super.key, required this.groupName});

  @override
  State<GroupOverviewScreen> createState() => _GroupOverviewScreenState();
}

class _GroupOverviewScreenState extends State<GroupOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          // spacing between content and screen
          padding:
              const EdgeInsets.only(top: CustomPadding.defaultSpace, left: CustomPadding.defaultSpace, right: CustomPadding.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoTile(title: AppTexts.overall, amount: 'amount', color: defaultColorScheme.primary),
              const Gap(
                CustomPadding.mediumSpace,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InfoTile(
                      title: AppTexts.perPerson,
                      amount: 'amount',
                      color: CustomColor.bluePrimary,
                      width: MediaQuery.sizeOf(context).width / 2 - Constants.infoTileSpace),
                  InfoTile(
                      title: AppTexts.debts,
                      amount: 'amount',
                      color: CustomColor.red,
                      width: MediaQuery.sizeOf(context).width / 2 - Constants.infoTileSpace),
                ],
              ),
              const Gap(CustomPadding.defaultSpace),
              Text(
                AppTexts.debtsOverview,
                style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary),
              ),
              const Gap(
                CustomPadding.mediumSpace,
              ),
              const DebtsOverview(),
              const Gap(CustomPadding.defaultSpace),
              Text(AppTexts.transactionOverview, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
              const Gap(CustomPadding.mediumSpace),
              const TransactionOverview(
                categoryAmounts: {
                  Categories.lebensmittel: 3.0,
                  Categories.drogerie: 2.0,
                  Categories.restaurant: 1.00,
                  Categories.mobility: 0.0,
                  Categories.shopping: 0.0,
                  Categories.unterkunft: 0.0,
                  Categories.entertainment: 0.0,
                  Categories.geschenk: 0.0,
                  Categories.sonstiges: 0.0,
                },
              ),
              const Gap(CustomPadding.defaultSpace),
              Text(AppTexts.history, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
              const Gap(
                CustomPadding.mediumSpace,
              ),
              //TODO: Add Listview with all Transactions
              Gap(MediaQuery.sizeOf(context).height * CustomPadding.bottomSpace + CustomPadding.bigbigSpace)
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: defaultColorScheme.onSurface,
        child: Container(
          // Margin is applied to the bottom of the button and the sides for proper spacing.
          margin: EdgeInsets.only(
            bottom: MediaQuery.sizeOf(context).height * CustomPadding.bottomSpace, // Bottom margin based on screen height
            left: CustomPadding.defaultSpace, // Left margin
            right: CustomPadding.defaultSpace, // Right margin
          ),
          child: ElevatedButton(
            // Enable button only if profile has changed
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                // Set button color based on whether profile has changed
                disabledBackgroundColor: CustomColor.bluePrimary.withOpacity(0.5),
                backgroundColor: CustomColor.bluePrimary),
            child: Text(AppTexts.addDebt),
          ),
        ),
      ),
    );
  }
}
