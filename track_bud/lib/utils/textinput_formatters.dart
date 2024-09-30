// Source: ChatGPT

import 'package:flutter/services.dart';

class MaxValueInputFormatter extends TextInputFormatter {
  final double maxValue;

  MaxValueInputFormatter({required this.maxValue});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // If the new value is empty, return it (allows for deletion)
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Convert new value to a double
    double? newValueDouble = double.tryParse(newValue.text.replaceAll(',', '.'));

    // Check if the new value exceeds the maximum allowed value
    if (newValueDouble != null && newValueDouble > maxValue) {
      // Return the old value if the new value is greater than maxValue
      return oldValue;
    }

    // If valid, return the new value
    return newValue;
  }
}
