// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:track_bud/utils/buttons_widget.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';

class InfoTile extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  final double? width;
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
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: CustomPadding.contentHeightSpace,
            horizontal: CustomPadding.defaultSpace),
        width: width ?? MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
            color: CustomColor.white,
            borderRadius: BorderRadius.circular(Constants.buttonBorderRadius)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$amount€',
              style: CustomTextStyle.headingStyle.copyWith(color: color),
            ),
            SizedBox(
              height: CustomPadding.mediumSpace,
            ),
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

class TransactionTile extends StatefulWidget {
  const TransactionTile({super.key});

  @override
  State<TransactionTile> createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile> {
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
            leading: CategoryIcon(
                color: CustomColor.lebensmittel, icon: AssetImport.appleLogo),
            title: Text(
              'Kaufland',
              style: CustomTextStyle.regularStyleMedium,
            ),
            subtitle: Text(
              'heute, 11:32',
              style: CustomTextStyle.hintStyleDefault
                  .copyWith(fontSize: CustomTextStyle.fontSizeHint),
            ),
            trailing: Text(
              '100€',
              style: CustomTextStyle.regularStyleMedium,
            ),
            minVerticalPadding: CustomPadding.defaultSpace,
            onTap: _openTransaction),
      ),
    );
  }
}

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
