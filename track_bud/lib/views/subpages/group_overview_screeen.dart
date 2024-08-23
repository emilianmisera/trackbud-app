import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/group_widget.dart';
import 'package:track_bud/utils/information_tiles.dart';
import 'package:track_bud/utils/strings.dart';

class GroupOverviewScreeen extends StatefulWidget {
  final String groupName;
  const GroupOverviewScreeen({super.key, required this.groupName});

  @override
  State<GroupOverviewScreeen> createState() => _GroupOverviewScreeenState();
}

class _GroupOverviewScreeenState extends State<GroupOverviewScreeen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.groupName,
          style: CustomTextStyle.regularStyleMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          // spacing between content and screen
          padding: EdgeInsets.only(
              top: CustomPadding.defaultSpace,
              left: CustomPadding.defaultSpace,
              right: CustomPadding.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoTile(
                  title: AppString.overall,
                  amount: '10000,50',
                  color: CustomColor.black),
              SizedBox(
                height: CustomPadding.mediumSpace,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  InfoTile(
                      title: AppString.perPerson,
                      amount: 'amount',
                      color: CustomColor.bluePrimary,
                      width: MediaQuery.sizeOf(context).width / 2 -
                          Constants.infoTileSpace),
                  InfoTile(
                      title: 'Schulden',
                      amount: 'amount',
                      color: CustomColor.red,
                      width: MediaQuery.sizeOf(context).width / 2 -
                          Constants.infoTileSpace),
                ],
              ),
              
              SizedBox(height: CustomPadding.defaultSpace),
              Text(AppString.debtsOverview, style: CustomTextStyle.regularStyleMedium,),
              SizedBox(height: CustomPadding.mediumSpace,),
              DebtsOverview(),
              SizedBox(height: CustomPadding.defaultSpace),
              Text(AppString.transactionOverview, style: CustomTextStyle.regularStyleMedium,),
              SizedBox(height: CustomPadding.mediumSpace,),

            ],
          ),
        ),
      ),
      bottomSheet: Container(
        // Margin is applied to the bottom of the button and the sides for proper spacing.
        margin: EdgeInsets.only(
          bottom: MediaQuery.sizeOf(context).height *
              CustomPadding.bottomSpace, // Bottom margin based on screen height
          left: CustomPadding.defaultSpace, // Left margin
          right: CustomPadding.defaultSpace, // Right margin
        ),
        child: ElevatedButton(
            // Enable button only if profile has changed
            onPressed: (){},
            style: ElevatedButton.styleFrom(
              // Set button color based on whether profile has changed
              disabledBackgroundColor: CustomColor.bluePrimary.withOpacity(0.5),
              backgroundColor: CustomColor.bluePrimary
            ),
            child: Text(AppString.payOffDebts),
          ),
      ),
    );
  }
}
