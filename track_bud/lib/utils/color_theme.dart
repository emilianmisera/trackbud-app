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
    appBarTheme: const AppBarTheme(
        backgroundColor: CustomColor.backgroundPrimary,
        surfaceTintColor: CustomColor.backgroundPrimary,
        iconTheme: IconThemeData(color: CustomColor.black)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      //style for elevated button
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(
            const Size(double.infinity, Constants.height)),
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) =>
            states.contains(WidgetState.disabled)
                ? CustomColor.bluePrimary.withOpacity(0.5)
                : CustomColor.bluePrimary),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
        )),
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) =>
            states.contains(WidgetState.pressed)
                ? CustomColor.overlayColor
                : null),
        animationDuration: Constants.buttonAnimationDuration,
        textStyle: WidgetStateProperty.all(TextStyles.buttonTextStyle),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) => states.contains(WidgetState.disabled)
              ? CustomColor.white.withOpacity(0.5)
              : CustomColor.white, // Default text color
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      //style for outlinedButton
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(
            const Size(double.infinity, Constants.height)),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
        )),
        foregroundColor: WidgetStateProperty.all(CustomColor.black),
        side: WidgetStateProperty.all(const BorderSide(
            color: CustomColor.hintColor,
            width: 2.0,
            style: BorderStyle.solid)),
        backgroundColor: WidgetStateProperty.all(
            CustomColor.backgroundPrimary), // when not pressing
        textStyle: WidgetStateProperty.all(TextStyles.regularStyleMedium),
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) =>
            states.contains(WidgetState.pressed)
                ? CustomColor.overlayColor
                : null),
        animationDuration: Constants.buttonAnimationDuration,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(CustomColor.white),
        foregroundColor: WidgetStateProperty.all(CustomColor.black),
        textStyle: WidgetStateProperty.all(TextStyles.regularStyleMedium),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
        )),
        minimumSize: WidgetStateProperty.all(
            const Size(double.infinity, Constants.height)),
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) =>
            states.contains(WidgetState.pressed)
                ? CustomColor.overlayColor
                : null),
        animationDuration: Constants.buttonAnimationDuration,
      ),
    ),
    colorScheme: const ColorScheme.light(
      tertiary: CustomColor.pastelBlue,
      onTertiary: CustomColor.pastelGreen,
      tertiaryContainer: CustomColor.pastelRed,
      // Text
      primary: CustomColor.black,
      //Hint Text
      secondary: CustomColor.hintColor,
      //background tiles
      surface: CustomColor.white,
      // background Color
      onSurface: CustomColor.backgroundPrimary,
      // grey Color
      outline: CustomColor.grey,
      // for small elements where primary blue is to dark in darkmode
      surfaceTint: CustomColor.bluePrimary,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      tertiary: CustomColor.darkModePastelBlue,
      onTertiary: CustomColor.darkModePastelGreen,
      tertiaryContainer: CustomColor.darkModePastelRed,
      // Text
      primary: CustomColor.darkModeWhite,
      //Hint Text
      secondary: CustomColor.darkModeHint,
      //background tiles
      surface: CustomColor.darkModeBlack,
      // background Color
      onSurface: CustomColor.darkModebackgroundPrimary,
      // grey Color
      outline: CustomColor.darkModeGrey,
      // for small elements where primary blue is to dark in darkmode
      surfaceTint: CustomColor.darkModeWhite,
    ),
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: CustomColor.darkModebackgroundPrimary,
    fontFamily: TextStyles.fontFamily,
    hintColor: CustomColor.darkModeHint,
    appBarTheme: const AppBarTheme(
        backgroundColor: CustomColor.darkModebackgroundPrimary,
        surfaceTintColor: CustomColor.darkModebackgroundPrimary,
        iconTheme: IconThemeData(color: CustomColor.darkModeWhite)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      //style for elevated button
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(
            const Size(double.infinity, Constants.height)),
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) =>
            states.contains(WidgetState.disabled)
                ? CustomColor.bluePrimary.withOpacity(0.5)
                : CustomColor.bluePrimary),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
        )),
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) =>
            states.contains(WidgetState.pressed)
                ? CustomColor.overlayColor
                : null),
        animationDuration: Constants.buttonAnimationDuration,
        textStyle: WidgetStateProperty.all(TextStyles.buttonTextStyle),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) => states.contains(WidgetState.disabled)
              ? CustomColor.white.withOpacity(0.5)
              : CustomColor.white, // Default text color
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      //style for outlinedButton
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(
            const Size(double.infinity, Constants.height)),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
        )),
        foregroundColor: WidgetStateProperty.all(CustomColor.black),
        side: WidgetStateProperty.all(const BorderSide(
            color: CustomColor.darkModeHint,
            width: 2.0,
            style: BorderStyle.solid)),
        backgroundColor: WidgetStateProperty.all(
            CustomColor.darkModebackgroundPrimary), // when not pressing
        textStyle: WidgetStateProperty.all(TextStyles.regularStyleMedium
            .copyWith(color: CustomColor.darkModeWhite)),
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) =>
            states.contains(WidgetState.pressed)
                ? CustomColor.overlayColor
                : null),
        animationDuration: Constants.buttonAnimationDuration,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(CustomColor.darkModeBlack),
        foregroundColor: WidgetStateProperty.all(CustomColor.darkModeWhite),
        textStyle: WidgetStateProperty.all(TextStyles.regularStyleMedium
            .copyWith(color: CustomColor.darkModeWhite)),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
        )),
        minimumSize: WidgetStateProperty.all(
            const Size(double.infinity, Constants.height)),
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) =>
            states.contains(WidgetState.pressed)
                ? CustomColor.overlayColor
                : null),
        animationDuration: Constants.buttonAnimationDuration,
      ),
    ),
  );
}
