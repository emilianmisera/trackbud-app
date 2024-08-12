//Source: https://www.youtube.com/watch?v=pdEs7BFl49E

import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';

class ColorTheme {
  //light theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: CustomColor.backgroundPrimary,
    fontFamily: CustomTextStyle.fontFamily,
    hintColor: CustomColor.hintColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      //style for elevated button
      style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(
            const Size(double.infinity, 60),
          ),
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) => CustomColor.bluePrimary,
          ),
          shape: WidgetStateProperty.resolveWith<OutlinedBorder>((_) {
            return const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(Constants.buttonBorderRadius)));
          }),
          textStyle: WidgetStateProperty.resolveWith(
            (states) => (CustomTextStyle.buttonTextStyle),
          ),
          foregroundColor:
              WidgetStateProperty.all<Color>(CustomColor.white) // Text Color
          ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      //style for outlinedButton
      style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(
            const Size(double.infinity, 60),
          ),
          shape: WidgetStateProperty.resolveWith<OutlinedBorder>((_) {
            return const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(Constants.buttonBorderRadius)));
          }),
          foregroundColor: WidgetStateProperty.all<Color>(CustomColor.black),
          side: WidgetStateProperty.all(BorderSide(
              color: CustomColor.hintColor,
              width: 2.0,
              style: BorderStyle.solid)),
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) => CustomColor.backgroundPrimary,
          ),
          textStyle: WidgetStateProperty.resolveWith(
            (states) => (CustomTextStyle.regularStyleMedium),
          )),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) => CustomColor.white,
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) => CustomColor.black,
        ),
        textStyle: WidgetStateProperty.resolveWith(
          (states) => (CustomTextStyle.regularStyleMedium),
        ),
        shape: WidgetStateProperty.resolveWith<OutlinedBorder>((_) {
          return const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(Constants.buttonBorderRadius)));
        }),
        minimumSize: WidgetStateProperty.all(
          const Size(double.infinity, 60),
        ),
      ),
    ),
  );
}
