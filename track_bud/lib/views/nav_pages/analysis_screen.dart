import 'package:flutter/material.dart';
import 'package:track_bud/utils/buttons_widget.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/information_tiles.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            // spacing between content and screen
            padding: EdgeInsets.only(
                top: MediaQuery.sizeOf(context).height *
                    CustomPadding.topSpace,
                left: CustomPadding.defaultSpace,
                right: CustomPadding.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoTile(title: 'title', amount: 'amount', color: CustomColor.bluePrimary),
                SizedBox(height: CustomPadding.mediumSpace,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InfoTile(title: 'title', amount: 'amount', color: CustomColor.red, width: MediaQuery.sizeOf(context).width / 2 - Constants.infoTileSpace),
                    CustomDropDown(list: ['Ausgaben', 'Einkommen'], width: MediaQuery.sizeOf(context).width / 2 - Constants.infoTileSpace,height: 105,),
                  ],
                ),
              ],
            ),
        ),
      ),
    );
  }
}
