//Source: https://www.youtube.com/watch?v=pdEs7BFl49E

import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';

class ColorTheme {
  //light theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: CustomColor.backgroundPrimary,
    fontFamily: TextStyles.fontFamily,
    hintColor: CustomColor.hintColor,
    appBarTheme: AppBarTheme(backgroundColor: CustomColor.backgroundPrimary, surfaceTintColor: CustomColor.backgroundPrimary),
    elevatedButtonTheme: ElevatedButtonThemeData(
      //style for elevated button
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(
          const Size(double.infinity, Constants.height),
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              // Return the color with 50% opacity when the button is disabled
              return CustomColor.bluePrimary.withOpacity(0.5);
            }
            return CustomColor.bluePrimary; // Default color when not disabled
          },
        ),
        shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
          (_) {
            return const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Constants.buttonBorderRadius)));
          },
        ),
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.pressed)) {
              return CustomColor.overlayColor;
            }
            return null;
          },
        ),
        animationDuration: Constants.buttonAnimationDuration,
        textStyle: WidgetStateProperty.resolveWith(
          (states) => (TextStyles.buttonTextStyle),
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              // Return the text color with 50% opacity when the button is disabled
              return CustomColor.white.withOpacity(0.5);
            }
            return CustomColor.white; // Default text color
          },
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      //style for outlinedButton
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(
          const Size(double.infinity, Constants.height),
        ),
        shape: WidgetStateProperty.resolveWith<OutlinedBorder>((_) {
          return const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Constants.buttonBorderRadius)));
        }),
        foregroundColor: WidgetStateProperty.all<Color>(CustomColor.black),
        side: WidgetStateProperty.all(BorderSide(color: CustomColor.hintColor, width: 2.0, style: BorderStyle.solid)),
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            return CustomColor.backgroundPrimary; // when not pressing
          },
        ),
        textStyle: WidgetStateProperty.resolveWith(
          (states) => (TextStyles.regularStyleMedium),
        ),
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.pressed)) {
              return CustomColor.overlayColor;
            }
            return null;
          },
        ),
        animationDuration: Constants.buttonAnimationDuration,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) => CustomColor.white,
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            return CustomColor.black;
          },
        ),
        textStyle: WidgetStateProperty.resolveWith(
          (states) => (TextStyles.regularStyleMedium),
        ),
        shape: WidgetStateProperty.resolveWith<OutlinedBorder>((_) {
          return const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Constants.buttonBorderRadius)));
        }),
        minimumSize: WidgetStateProperty.all(
          const Size(double.infinity, Constants.height),
        ),
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.pressed)) {
              return CustomColor.overlayColor;
            }
            return null;
          },
        ),
        animationDuration: Constants.buttonAnimationDuration,
      ),
    ),
  );
}
