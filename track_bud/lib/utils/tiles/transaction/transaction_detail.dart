import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/categories/category_icon.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/enum/categories.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widgets.dart';
import 'package:intl/intl.dart';

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
                  Text(widget.title, style: TextStyles.titleStyleMedium),
                  Gap(CustomPadding.smallSpace),
                  Text(DateFormat('dd.MM.yyyy, HH:mm').format(widget.date), style: TextStyles.hintStyleDefault),
                ],
              ),
            ],
          ),
          Gap(CustomPadding.defaultSpace),
          // Amount section
          Text(AppTexts.amount, style: TextStyles.regularStyleDefault),
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
                  child: Text('${widget.amount.toStringAsFixed(2)}€', style: TextStyles.regularStyleMedium),
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
                  child: Text(widget.recurrenceType, style: TextStyles.regularStyleDefault.copyWith(color: CustomColor.bluePrimary)),
                ),
              ),
            ],
          ),
          Gap(CustomPadding.defaultSpace),
          // Note section
          Text(AppTexts.note, style: TextStyles.regularStyleDefault),
          Gap(CustomPadding.mediumSpace),
          CustomShadow(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace, vertical: CustomPadding.contentHeightSpace),
              decoration: BoxDecoration(
                color: CustomColor.white,
                borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
              ),
              child: Text(widget.notes, style: TextStyles.regularStyleDefault),
            ),
          ),
        ],
      ),
    );
  }
}
