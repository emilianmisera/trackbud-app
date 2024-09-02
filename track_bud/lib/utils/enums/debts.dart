import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';

enum DebtsColorScheme {
  blue,
  green,
  red,
}

extension BoxColor on DebtsColorScheme {
  Color get color {
    switch (this) {
      case DebtsColorScheme.blue:
        return CustomColor.pastelBlue;
      case DebtsColorScheme.red:
        return CustomColor.pastelRed;
      case DebtsColorScheme.green:
        return CustomColor.pastelGreen;
    }
  }
}

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
