// Source: ChatGPT

import 'package:flutter/services.dart';

class GermanNumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // only numbers and comma
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9,]'), '');

    // only one comma
    if (newText.split(',').length > 2) {
      return oldValue;
    }

    // only two decimal places
    var parts = newText.split(',');
    if (parts.length > 1 && parts[1].length > 2) {
      parts[1] = parts[1].substring(0, 2);
      newText = parts.join(',');
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}