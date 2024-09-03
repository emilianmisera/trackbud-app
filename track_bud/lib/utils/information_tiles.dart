// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/button_widgets/buttons_widget.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/enum/categories.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widgets.dart';
import 'package:intl/intl.dart';

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
          vertical: CustomPadding.defaultSpace,
          horizontal: CustomPadding.defaultSpace,
        ),
        width: width ?? MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          color: CustomColor.white,
          borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the amount
            Text(
              '$amount€',
              style: TextStyles.headingStyle.copyWith(color: color),
            ),
            Gap(CustomPadding.mediumSpace),
            // Display the title
            Text(
              title,
              style: TextStyles.regularStyleDefault,
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
  final String transactionId;
  final String notes;
  final String recurrenceType;
  final String type;
  final Function(String) onDelete;
  final Function(String) onEdit;

  const TransactionTile(
      {Key? key,
      required this.title,
      required this.amount,
      required this.date,
      required this.category,
      required this.transactionId,
      required this.notes,
      required this.recurrenceType,
      required this.type,
      required this.onDelete,
      required this.onEdit})
      : super(key: key);

  @override
  State<TransactionTile> createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile> {
  // Method to open a popup window with transaction details
  Future _openTransaction() => showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(CustomPadding.defaultSpace),
            child: TransactionDetail(
              title: widget.title,
              amount: widget.amount,
              date: widget.date,
              category: widget.category,
              transactionId: widget.transactionId,
              notes: widget.notes,
              recurrenceType: widget.recurrenceType,
              type: widget.type,
              onDelete: widget.onDelete,
              onEdit: widget.onEdit,
            ),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace),
          backgroundColor: CustomColor.backgroundPrimary,
          surfaceTintColor: CustomColor.backgroundPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(Constants.contentBorderRadius),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(color: CustomColor.white, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
        child: ListTile(
          // Transaction category icon
          leading: CategoryIcon(
            color: Categories.values
                .firstWhere(
                  (c) => c.categoryName.toLowerCase() == widget.category.toLowerCase(),
                  orElse: () => Categories.sonstiges,
                )
                .color,
            iconWidget: Categories.values
                .firstWhere(
                  (c) => c.categoryName.toLowerCase() == widget.category.toLowerCase(),
                  orElse: () => Categories.sonstiges,
                )
                .icon,
          ),
          // Transaction title
          title: Text(
            widget.title,
            style: TextStyles.regularStyleMedium,
          ),
          // Transaction timestamp
          subtitle: Text(
            DateFormat('dd.MM.yyyy, HH:mm').format(widget.date),
            style: TextStyles.hintStyleDefault.copyWith(fontSize: TextStyles.fontSizeHint),
          ),
          // Transaction amount
          trailing: Text(
            '${widget.amount.toStringAsFixed(2)}€',
            style: TextStyles.regularStyleMedium,
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
  final String transactionId;
  final String notes;
  final String recurrenceType;
  final String type;
  final Function(String) onDelete;
  final Function(String) onEdit;

  const TransactionDetail({
    Key? key,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.transactionId,
    required this.notes,
    required this.recurrenceType,
    required this.type,
    required this.onDelete,
    required this.onEdit,
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
                          Gap(CustomPadding.mediumSpace),
                          Text('Bearbeiten', style: TextStyles.regularStyleDefault),
                        ],
                      ),
                    ),
                    // Delete option
                    DropdownMenuItem<String>(
                      value: 'Löschen',
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AssetImport.trash,
                            colorFilter: ColorFilter.mode(CustomColor.red, BlendMode.srcIn),
                          ),
                          Gap(CustomPadding.mediumSpace),
                          Text('Löschen', style: TextStyles.regularStyleDefault.copyWith(color: CustomColor.red)),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == 'Bearbeiten') {
                      Navigator.of(context).pop();
                      widget.onEdit(widget.transactionId);
                    } else if (value == 'Löschen') {
                      widget.onDelete(widget.transactionId);
                      Navigator.of(context).pop();
                    }
                  },
                  dropdownStyleData: DropdownStyleData(
                    width: 160,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
                      color: Colors.white,
                    ),
                  ),
                  menuItemStyleData: MenuItemStyleData(
                    customHeights: [48, 48],
                    padding: const EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    AppTexts.expense,
                    style: TextStyles.regularStyleMedium,
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
          Gap(CustomPadding.defaultSpace),
          // Transaction details
          Row(
            children: [
              CategoryIcon(
                color: Categories.values
                    .firstWhere(
                      (c) => c.categoryName.toLowerCase() == widget.category.toLowerCase(),
                      orElse: () => Categories.sonstiges,
                    )
                    .color,
                iconWidget: Categories.values
                    .firstWhere(
                      (c) => c.categoryName.toLowerCase() == widget.category.toLowerCase(),
                      orElse: () => Categories.sonstiges,
                    )
                    .icon,
              ),
              Gap(CustomPadding.mediumSpace),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyles.titleStyleMedium,
                  ),
                  Gap(CustomPadding.smallSpace),
                  Text(
                    DateFormat('dd.MM.yyyy, HH:mm').format(widget.date),
                    style: TextStyles.hintStyleDefault,
                  ),
                ],
              ),
            ],
          ),
          Gap(CustomPadding.defaultSpace),
          // Amount section
          Text(
            AppTexts.amount,
            style: TextStyles.regularStyleDefault,
          ),
          Gap(CustomPadding.mediumSpace),
          Row(
            children: [
              // Amount display
              CustomShadow(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace, vertical: CustomPadding.contentHeightSpace),
                  decoration: BoxDecoration(
                    color: CustomColor.white,
                    borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
                  ),
                  child: Text(
                    '${widget.amount.toStringAsFixed(2)}€',
                    style: TextStyles.regularStyleMedium,
                  ),
                ),
              ),
              Gap(CustomPadding.defaultSpace),
              // Transaction type
              CustomShadow(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace, vertical: CustomPadding.contentHeightSpace),
                  decoration: BoxDecoration(
                    color: CustomColor.white,
                    borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
                  ),
                  child: Text(
                    widget.recurrenceType,
                    style: TextStyles.regularStyleDefault.copyWith(color: CustomColor.bluePrimary),
                  ),
                ),
              ),
            ],
          ),
          Gap(CustomPadding.defaultSpace),
          // Note section
          Text(
            AppTexts.note,
            style: TextStyles.regularStyleDefault,
          ),
          Gap(CustomPadding.mediumSpace),
          CustomShadow(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace, vertical: CustomPadding.contentHeightSpace),
              decoration: BoxDecoration(
                color: CustomColor.white,
                borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
              ),
              child: Text(
                widget.notes,
                style: TextStyles.regularStyleDefault,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
