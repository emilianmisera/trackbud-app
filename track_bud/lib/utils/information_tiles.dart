// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:track_bud/utils/buttons_widget.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';
import 'package:intl/intl.dart';
import 'package:track_bud/views/subpages/edit_transaction_screen.dart';

// Widget for displaying amount and title information
class InfoTile extends StatelessWidget {
  final String title; // The title of the info tile
  final String amount; // The amount to be displayed
  final Color color; // The color of the amount text
  final double? width; // Optional width of the tile

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
          horizontal: CustomPadding.defaultSpace,
        ),
        width: width ?? MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          color: CustomColor.white,
          borderRadius: BorderRadius.circular(Constants.buttonBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the amount
            Text(
              '$amount€',
              style: CustomTextStyle.headingStyle.copyWith(color: color),
            ),
            SizedBox(height: CustomPadding.mediumSpace),
            // Display the title
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

// Widget for displaying individual transactions
class TransactionTile extends StatefulWidget {
  final String title;
  final double amount;
  final DateTime date;
  final String category;

  const TransactionTile(
      {Key? key,
      required this.title,
      required this.amount,
      required this.date,
      required this.category})
      : super(key: key);

  @override
  State<TransactionTile> createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile> {
  // Method to open a popup window with transaction details
  Future _openTransaction() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: TransactionDetail(
            title: widget.title,
            amount: widget.amount,
            date: widget.date,
            category: widget.category,
          ),
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

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Lebensmittel':
        return CustomColor.lebensmittel;
      case 'Transport':
        return CustomColor.mobility;
      case 'Unterkunft':
        return CustomColor.unterkunft;
      case 'Drogerie':
        return CustomColor.drogerie;
      case 'Restaurant':
        return CustomColor.restaurant;
      case 'Shopping':
        return CustomColor.shopping;
      case 'Unterhaltung':
        return CustomColor.entertainment;
      case 'Geschenk':
        return CustomColor.geschenk;
      case 'Sonstiges':
        return CustomColor.sonstiges;
      default:
        return CustomColor.sonstiges;
    }
  }

  Widget getCategoryIcon(String category) {
    switch (category) {
      case 'Lebensmittel':
        return Image.asset(
          AssetImport.shoppingCart,
          width: 25,
          height: 25,
          fit: BoxFit.scaleDown,
        );
      case 'Transport':
        return Image.asset(
          AssetImport.mobility,
          width: 25,
          height: 25,
          fit: BoxFit.scaleDown,
        );
      case 'Unterkunft':
        return Image.asset(
          AssetImport.home,
          width: 25,
          height: 25,
          fit: BoxFit.scaleDown,
        );
      case 'Drogerie':
        return Image.asset(
          AssetImport.drogerie,
          width: 25,
          height: 25,
          fit: BoxFit.scaleDown,
        );
      case 'Restaurant':
        return Image.asset(
          AssetImport.restaurant,
          width: 25,
          height: 25,
          fit: BoxFit.scaleDown,
        );
      case 'Shopping':
        return Image.asset(
          AssetImport.shopping,
          width: 25,
          height: 25,
          fit: BoxFit.scaleDown,
        );
      case 'Unterhaltung':
        return Image.asset(
          AssetImport.entertainment,
          width: 25,
          height: 25,
          fit: BoxFit.scaleDown,
        );
      case 'Geschenk':
        return Image.asset(
          AssetImport.gift,
          width: 25,
          height: 25,
          fit: BoxFit.scaleDown,
        );
      default:
        return Icon(
          Icons.category,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
            color: CustomColor.white,
            borderRadius: BorderRadius.circular(Constants.buttonBorderRadius)),
        child: ListTile(
          // Transaction category icon
          leading: CategoryIcon(
              color: getCategoryColor(widget.category),
              iconWidget: getCategoryIcon(widget.category)),
          // Transaction title
          title: Text(
            widget.title,
            style: CustomTextStyle.regularStyleMedium,
          ),
          // Transaction timestamp
          subtitle: Text(
            DateFormat('dd.MM.yyyy, HH:mm').format(widget.date),
            style: CustomTextStyle.hintStyleDefault
                .copyWith(fontSize: CustomTextStyle.fontSizeHint),
          ),
          // Transaction amount
          trailing: Text(
            '${widget.amount.toStringAsFixed(2)}€',
            style: CustomTextStyle.regularStyleMedium,
          ),
          minVerticalPadding: CustomPadding.defaultSpace,
          onTap: _openTransaction,
        ),
      ),
    );
  }
}

// Widget for displaying detailed transaction information
class TransactionDetail extends StatefulWidget {
  final String title;
  final double amount;
  final DateTime date;
  final String category;

  const TransactionDetail({
    Key? key,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : super(key: key);

  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

List options = ['bearbeiten, löschen'];

class _TransactionDetailState extends State<TransactionDetail> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Dropdown menu for edit and delete options
              DropdownButtonHideUnderline(
                child: DropdownButton2(
                  customButton: const Icon(
                    Icons.more_vert_rounded,
                    size: 25,
                    color: CustomColor.black,
                  ),
                  items: [
                    // Edit option
                    DropdownMenuItem<String>(
                      value: 'Bearbeiten',
                      child: Row(
                        children: [
                          SvgPicture.asset(AssetImport.edit),
                          SizedBox(width: CustomPadding.mediumSpace),
                          Text('Bearbeiten',
                              style: CustomTextStyle.regularStyleDefault),
                        ],
                      ),
                    ),
                    // Delete option
                    DropdownMenuItem<String>(
                      value: 'Löschen',
                      child: Row(
                        children: [
                          SvgPicture.asset(AssetImport.trash,
                              color: CustomColor.red),
                          SizedBox(width: CustomPadding.mediumSpace),
                          Text('Löschen',
                              style: CustomTextStyle.regularStyleDefault
                                  .copyWith(color: CustomColor.red)),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == 'Bearbeiten') {
                      Navigator.of(context).pop();
                      // Navigate to EditScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTransactionScreen(),
                        ),
                      );
                    } else if (value == 'Löschen') {
                      //TODO: implement Transaction Deletion
                    }
                  },
                  dropdownStyleData: DropdownStyleData(
                    width: 160,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Constants.buttonBorderRadius),
                      color: Colors.white,
                    ),
                  ),
                  menuItemStyleData: MenuItemStyleData(
                    customHeights: [48, 48],
                    padding: const EdgeInsets.symmetric(
                        horizontal: CustomPadding.defaultSpace),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    AppString.expense,
                    style: CustomTextStyle.regularStyleMedium,
                  ),
                ),
              ),
              // Close button
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.close_rounded),
              ),
            ],
          ),
          SizedBox(height: CustomPadding.defaultSpace),
          // Transaction details
          Row(
            children: [
              CategoryIcon(
                color: CustomColor.lebensmittel,
                iconWidget: Image.asset(AssetImport.shoppingCart,
                    width: 25, height: 25, fit: BoxFit.scaleDown),
              ),
              SizedBox(width: CustomPadding.mediumSpace),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kaufland',
                    style: CustomTextStyle.titleStyleMedium,
                  ),
                  SizedBox(height: CustomPadding.smallSpace),
                  Text(
                    'heute, 11:32',
                    style: CustomTextStyle.hintStyleDefault,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: CustomPadding.defaultSpace),
          // Amount section
          Text(
            AppString.amount,
            style: CustomTextStyle.regularStyleDefault,
          ),
          SizedBox(height: CustomPadding.mediumSpace),
          Row(
            children: [
              // Amount display
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
              SizedBox(width: CustomPadding.defaultSpace),
              // Transaction type
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
          SizedBox(height: CustomPadding.defaultSpace),
          // Note section
          Text(
            AppString.note,
            style: CustomTextStyle.regularStyleDefault,
          ),
          SizedBox(height: CustomPadding.mediumSpace),
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
