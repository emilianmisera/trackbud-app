// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:track_bud/utils/buttons_widget.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';

// Displaying Amount and Title
class InfoTile extends StatelessWidget {
  final String title; // setup title
  final String amount; // setup amount
  final Color color; // setup Color of amount
  final double? width; // setup width if needed
  const InfoTile({
    Key? key,
    required this.title,
    required this.amount,
    required this.color,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      //add Shadow
      child: Container(
        // add space between border and content
        padding: EdgeInsets.symmetric(
          vertical: CustomPadding.contentHeightSpace,
          horizontal: CustomPadding.defaultSpace,
        ),
        // deafult width is whole screen
        width: width ?? MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          color: CustomColor.white, // background color of Tile
          borderRadius: BorderRadius.circular(
              Constants.buttonBorderRadius), //border Radius
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // amount
            Text(
              '$amount€',
              style: CustomTextStyle.headingStyle.copyWith(color: color),
            ),
            SizedBox(
              height: CustomPadding.mediumSpace,
            ),
            // title
            Text(
              title,
              style: CustomTextStyle.regularStyleDefault,
            ),
          ],
        ),
      ),
    );
  }
}

// Widget that displays all single Transactions
class TransactionTile extends StatefulWidget {
  const TransactionTile({super.key});

  @override
  State<TransactionTile> createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile> {
  // method to open a PopUp Window for more Transaction Details
  Future _openTransaction() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: EditTransaction(),
          insetPadding:
              EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace),
          backgroundColor: CustomColor.backgroundPrimary,
          surfaceTintColor: CustomColor.backgroundPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(Constants.buttonBorderRadius),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
            color: CustomColor.white,
            borderRadius: BorderRadius.circular(Constants.buttonBorderRadius)),
        child: ListTile(
          // Icon
          leading: CategoryIcon(
              color: CustomColor.lebensmittel, icon: AssetImport.appleLogo),
          // Title of Transaction
          title: Text(
            'Kaufland',
            style: CustomTextStyle.regularStyleMedium,
          ),
          // Timestamp
          subtitle: Text(
            'heute, 11:32',
            style: CustomTextStyle.hintStyleDefault
                .copyWith(fontSize: CustomTextStyle.fontSizeHint),
          ),
          // Amount
          trailing: Text(
            '100€',
            style: CustomTextStyle.regularStyleMedium,
          ),
          minVerticalPadding: CustomPadding.defaultSpace,
          // open PopUp Window
          onTap: _openTransaction,
        ),
      ),
    );
  }
}

// show Transaction Details of TransactionTile
// option to delete or edit Transaction Tile
class EditTransaction extends StatefulWidget {
  const EditTransaction({super.key});

  @override
  State<EditTransaction> createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_horiz_rounded),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    AppString.expense,
                    style: CustomTextStyle.regularStyleMedium,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.close_rounded),
              ),
            ],
          ),
          SizedBox(
            height: CustomPadding.defaultSpace,
          ),
          Row(
            children: [
              CategoryIcon(
                color: CustomColor.lebensmittel,
                icon: AssetImport.appleLogo,
              ),
              SizedBox(
                width: CustomPadding.mediumSpace,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kaufland',
                    style: CustomTextStyle.titleStyleMedium,
                  ),
                  SizedBox(
                    height: CustomPadding.smallSpace,
                  ),
                  Text(
                    'heute, 11:32',
                    style: CustomTextStyle.hintStyleDefault,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: CustomPadding.defaultSpace,
          ),
          Text(
            AppString.amount,
            style: CustomTextStyle.regularStyleDefault,
          ),
          SizedBox(
            height: CustomPadding.mediumSpace,
          ),
          Row(
            children: [
              CustomShadow(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: CustomPadding.defaultSpace,
                      vertical: CustomPadding.contentHeightSpace),
                  decoration: BoxDecoration(
                    color: CustomColor.white,
                    borderRadius:
                        BorderRadius.circular(Constants.buttonBorderRadius),
                  ),
                  child: Text(
                    'data',
                    style: CustomTextStyle.regularStyleMedium,
                  ),
                ),
              ),
              SizedBox(
                width: CustomPadding.defaultSpace,
              ),
              CustomShadow(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: CustomPadding.defaultSpace,
                      vertical: CustomPadding.contentHeightSpace),
                  decoration: BoxDecoration(
                    color: CustomColor.white,
                    borderRadius:
                        BorderRadius.circular(Constants.buttonBorderRadius),
                  ),
                  child: Text(
                    'einmalige Transaktion',
                    style: CustomTextStyle.regularStyleDefault
                        .copyWith(color: CustomColor.bluePrimary),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: CustomPadding.defaultSpace,
          ),
          Text(
            AppString.note,
            style: CustomTextStyle.regularStyleDefault,
          ),
          SizedBox(
            height: CustomPadding.mediumSpace,
          ),
          CustomShadow(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: CustomPadding.defaultSpace,
                  vertical: CustomPadding.contentHeightSpace),
              decoration: BoxDecoration(
                color: CustomColor.white,
                borderRadius:
                    BorderRadius.circular(Constants.buttonBorderRadius),
              ),
              child: Text(
                'data',
                style: CustomTextStyle.regularStyleDefault,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
