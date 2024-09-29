import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/enum/debts_box.dart';

class BalanceState extends StatelessWidget {
  // Color scheme for the balance display, based on DebtsColorScheme
  final DebtsColorScheme colorScheme;

  // The amount to be displayed; can be null
  final String? amount;

  const BalanceState({
    super.key,
    required this.colorScheme, // Required parameter for color scheme
    this.amount, // Optional parameter for the amount
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Padding around the balance display
      padding: const EdgeInsets.symmetric(
        horizontal: CustomPadding.mediumSpace, // Horizontal padding
        vertical: CustomPadding.smallSpace, // Vertical padding
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5), // Rounded corners for the container
        color: colorScheme.getColor(context), // Background color based on the provided color scheme
      ),
      // Display the amount or a default text if amount is null
      child: Text(
        amount ?? 'quitt', // Default text if no amount is provided
        style: TextStyles.regularStyleMedium.copyWith(
          color: colorScheme.textColor, // Text color based on the provided color scheme
        ),
      ),
    );
  }
}
