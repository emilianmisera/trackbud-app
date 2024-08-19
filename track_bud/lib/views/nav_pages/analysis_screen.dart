import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:track_bud/controller/user_controller.dart';
import 'package:track_bud/utils/buttons_widget.dart';
import 'package:track_bud/utils/charts.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/information_tiles.dart';
import 'package:track_bud/utils/strings.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final UserController _userController = UserController();
  double _currentBalance = 0.00;

 @override
  void initState() {
    super.initState();
    _loadCurrentBankAccountInfo(); // Load bank account info when screen is initialized
  }


  Future<void> _loadCurrentBankAccountInfo() async {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Benutzer nicht angemeldet."),
        ),
      );
      return;
    }

    try {
      double currentBalance =
          await _userController.getBankAccountBalance(userId);
          setState(() {
            _currentBalance = currentBalance;
          });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Fehler beim Laden des Bankkontostands: $e"),
        ),
      );
    }
  }



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
                InfoTile(title: AppString.balance, amount: '${_currentBalance
          .toStringAsFixed(2)}', color: CustomColor.bluePrimary),
                SizedBox(height: CustomPadding.mediumSpace,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InfoTile(title: 'title', amount: 'amount', color: CustomColor.red, width: MediaQuery.sizeOf(context).width / 2 - Constants.infoTileSpace),
                    CustomDropDown(list: ['Ausgaben', 'Einkommen'], width: MediaQuery.sizeOf(context).width / 2 - Constants.infoTileSpace,height: 105,),
                  ],
                ),
                SizedBox(height: CustomPadding.defaultSpace,),
                Text('Verlauf', style: CustomTextStyle.regularStyleMedium,),
                SizedBox(height: CustomPadding.mediumSpace,),
                TransactionTile(),
                SizedBox(height: CustomPadding.defaultSpace,),
                
              ],
            ),
        ),
      ),
    );
  }
}
