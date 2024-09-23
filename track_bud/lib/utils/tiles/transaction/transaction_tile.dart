import 'package:flutter/material.dart';
import 'package:track_bud/utils/categories/category_icon.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/enum/categories.dart';
import 'package:intl/intl.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/tiles/transaction/transaction_detail.dart';

// Widget for displaying individual transactions
class TransactionTile extends StatefulWidget {
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final String transactionId;
  final String note;
  final String recurrence;
  final String type;
  final Function(String) onEdit;

  const TransactionTile(
      {super.key,
      required this.title,
      required this.amount,
      required this.date,
      required this.category,
      required this.transactionId,
      required this.note,
      required this.recurrence,
      required this.type,
      required this.onEdit});

  @override
  State<TransactionTile> createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile> {
  // Method to open a popup window with transaction details
  Future _openTransaction() => showDialog(
        context: context,
        builder: (context) => Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace),
          backgroundColor: CustomColor.backgroundPrimary,
          surfaceTintColor: CustomColor.backgroundPrimary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(Constants.contentBorderRadius),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(CustomPadding.defaultSpace),
            child: TransactionDetail(
              title: widget.title,
              amount: widget.amount,
              date: widget.date,
              category: widget.category,
              transactionId: widget.transactionId,
              note: widget.note,
              recurrence: widget.recurrence,
              type: widget.type,
              onEdit: widget.onEdit,
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
