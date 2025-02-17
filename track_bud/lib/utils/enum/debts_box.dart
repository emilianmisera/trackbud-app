import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';

/// Enum to represent all possible Balance States
enum DebtsColorScheme { blue, green, red }

// Box Color
extension BoxColor on DebtsColorScheme {
  Color getColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    switch (this) {
      case DebtsColorScheme.blue:
        return isDarkMode ? CustomColor.darkModePastelBlue : CustomColor.pastelBlue;
      case DebtsColorScheme.red:
        return isDarkMode ? CustomColor.darkModePastelRed : CustomColor.pastelRed;
      case DebtsColorScheme.green:
        return isDarkMode ? CustomColor.darkModePastelGreen : CustomColor.pastelGreen;
    }
  }
}

// Text Color
extension TextColor on DebtsColorScheme {
  Color get textColor {
    switch (this) {
      case DebtsColorScheme.blue:
        return CustomColor.bluePrimary;
      case DebtsColorScheme.red:
        return CustomColor.red;
      case DebtsColorScheme.green:
        return CustomColor.green;
    }
  }
}
