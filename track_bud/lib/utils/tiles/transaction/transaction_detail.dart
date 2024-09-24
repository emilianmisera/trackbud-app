import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/main.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/provider/transaction_provider.dart';
import 'package:track_bud/utils/categories/category_icon.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/enum/categories.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:intl/intl.dart';

// Widget for displaying detailed transaction information
class TransactionDetail extends StatefulWidget {
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final String transactionId;
  final String note;
  final String recurrence;
  final String type;
  final Function(String) onEdit;

  const TransactionDetail({
    super.key,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.transactionId,
    required this.note,
    required this.recurrence,
    required this.type,
    required this.onEdit,
  });

  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  final List<String> options = ['Bearbeiten', 'Löschen'];

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Dropdown menu for edit and delete options
              DropdownButtonHideUnderline(
                child: DropdownButton2(
                  customButton: Icon(
                    Icons.more_vert_rounded,
                    size: 25,
                    color: defaultColorScheme.primary,
                  ),
                  items: options.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            option == 'Bearbeiten'
                                ? AssetImport.edit
                                : AssetImport.trash,
                            colorFilter: ColorFilter.mode(
                                option == 'Bearbeiten'
                                    ? defaultColorScheme.primary
                                    : CustomColor.red,
                                BlendMode.srcIn),
                          ),
                          const Gap(CustomPadding.mediumSpace),
                          Text(
                            option,
                            style: TextStyles.regularStyleDefault.copyWith(
                              color: option == 'Bearbeiten'
                                  ? defaultColorScheme.primary
                                  : CustomColor.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == 'Bearbeiten') {
                      Navigator.of(context).pop();
                      widget.onEdit(widget.transactionId);
                    } else if (value == 'Löschen') {
                      transactionProvider
                          .deleteTransaction(widget.transactionId);
                      Navigator.of(context).pop();
                    }
                  },
                  dropdownStyleData: DropdownStyleData(
                    width: 160,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Constants.contentBorderRadius),
                      color: defaultColorScheme.surface,
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 48,
                    padding: EdgeInsets.symmetric(
                        horizontal: CustomPadding.defaultSpace),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    AppTexts.expense,
                    style: TextStyles.regularStyleMedium
                        .copyWith(color: defaultColorScheme.primary),
                  ),
                ),
              ),
              // Close button
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.close_rounded,
                    color: defaultColorScheme.primary),
              ),
            ],
          ),
          const Gap(CustomPadding.defaultSpace),
          // Transaction details
          Row(
            children: [
              CategoryIcon(
                color: Categories.values
                    .firstWhere(
                      (c) =>
                          c.categoryName.toLowerCase() ==
                          widget.category.toLowerCase(),
                      orElse: () => Categories.sonstiges,
                    )
                    .color,
                iconWidget: Categories.values
                    .firstWhere(
                      (c) =>
                          c.categoryName.toLowerCase() ==
                          widget.category.toLowerCase(),
                      orElse: () => Categories.sonstiges,
                    )
                    .icon,
              ),
              const Gap(CustomPadding.mediumSpace),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: TextStyles.titleStyleMedium
                          .copyWith(color: defaultColorScheme.primary)),
                  const Gap(CustomPadding.smallSpace),
                  Text(DateFormat('dd.MM.yyyy, HH:mm').format(widget.date),
                      style: TextStyles.hintStyleDefault
                          .copyWith(color: defaultColorScheme.secondary)),
                ],
              ),
            ],
          ),
          const Gap(CustomPadding.defaultSpace),
          // Amount section
          Text(AppTexts.amount,
              style: TextStyles.regularStyleDefault
                  .copyWith(color: defaultColorScheme.primary)),
          const Gap(CustomPadding.mediumSpace),
          Row(
            children: [
              // Amount display
              CustomShadow(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: CustomPadding.defaultSpace,
                      vertical: CustomPadding.contentHeightSpace),
                  decoration: BoxDecoration(
                    color: defaultColorScheme.surface,
                    borderRadius:
                        BorderRadius.circular(Constants.contentBorderRadius),
                  ),
                  child: Text('${widget.amount.toStringAsFixed(2)}€',
                      style: TextStyles.regularStyleMedium
                          .copyWith(color: defaultColorScheme.primary)),
                ),
              ),
              const Gap(CustomPadding.defaultSpace),
              // Transaction type
              CustomShadow(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: CustomPadding.defaultSpace,
                      vertical: CustomPadding.contentHeightSpace),
                  decoration: BoxDecoration(
                    color: defaultColorScheme.surface,
                    borderRadius:
                        BorderRadius.circular(Constants.contentBorderRadius),
                  ),
                  child: Text(widget.recurrence,
                      style: TextStyles.regularStyleDefault
                          .copyWith(color: CustomColor.bluePrimary)),
                ),
              ),
            ],
          ),
          const Gap(CustomPadding.defaultSpace),
          // Note section
          Text(AppTexts.note,
              style: TextStyles.regularStyleDefault
                  .copyWith(color: defaultColorScheme.primary)),
          const Gap(CustomPadding.mediumSpace),
          CustomShadow(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: CustomPadding.defaultSpace,
                  vertical: CustomPadding.contentHeightSpace),
              decoration: BoxDecoration(
                color: defaultColorScheme.surface,
                borderRadius:
                    BorderRadius.circular(Constants.contentBorderRadius),
              ),
              child: Text(widget.note,
                  style: TextStyles.regularStyleDefault
                      .copyWith(color: defaultColorScheme.primary)),
            ),
          ),
        ],
      ),
    );
  }
}
