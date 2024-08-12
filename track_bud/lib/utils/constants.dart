import 'package:flutter/material.dart';

class CustomTextStyle {
  static const String fontFamily = "Outfit";

  static const double fontSizeSegmentControl = 13;
  static const double fontSizeHint = 14;
  static const double fontSizeDefault = 16;
  static const double fontSizeTitle = 18;
  static const double fontSizeHeading = 24;

  static const FontWeight fontWeightDefault = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;

  static TextStyle headingStyle = const TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSizeHeading,
      fontWeight: fontWeightSemiBold,
      color: CustomColor.black);

  static TextStyle introductionStyle = const TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSizeHeading,
      fontWeight: fontWeightMedium,
      color: CustomColor.black);

  static TextStyle regularStyleDefault = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeDefault,
    fontWeight: fontWeightDefault,
    color: CustomColor.black,
  );

  static TextStyle regularStyleMedium = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeDefault,
    fontWeight: fontWeightMedium,
    color: CustomColor.black,
  );

  static TextStyle buttonTextStyle = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeDefault,
    fontWeight: fontWeightMedium,
    color: CustomColor.white,
  );

  static TextStyle hintStyleDefault = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeDefault,
    fontWeight: fontWeightDefault,
    color: CustomColor.hintColor,
  );

  static TextStyle hintStyleMedium = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeDefault,
    fontWeight: fontWeightMedium,
    color: CustomColor.hintColor,
  );
}

class CustomColor {
  //main colors
  static const Color bluePrimary = Color.fromRGBO(59, 66, 232, 1);
  static const Color black = Color.fromRGBO(8, 7, 8, 1);
  static const Color backgroundPrimary = Color.fromRGBO(250, 250, 255, 1);

  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color grey = Color.fromRGBO(230, 232, 230, 1);
  static const Color hintColor = Color.fromRGBO(114, 114, 114, 1);
  static const Color hintColorNavBar = Color.fromRGBO(103, 104, 118, 1);
  static const Color red = Color.fromRGBO(223, 41, 53, 1);
  static const Color green = Color.fromRGBO(6, 186, 99, 1);
  static const Color overlayColor =
      Color.fromRGBO(150, 150, 150, 0.5); //used for button animation

  //categorie colors
  //expenses
  static const Color unterkunft = Color.fromRGBO(242, 201, 76, 1);
  static const Color drogerie = Color.fromRGBO(127, 179, 213, 1);
  static const Color restaurant = Color.fromRGBO(229, 89, 52, 1);
  static const Color lebensmittel = Color.fromRGBO(85, 197, 122, 1);
  static const Color shopping = Color.fromRGBO(155, 89, 182, 1);
  static const Color entertainment = Color.fromRGBO(242, 82, 121, 1);
  static const Color mobility = Color.fromRGBO(100, 149, 237, 1);
  static const Color geschenk = Color.fromRGBO(34, 139, 34, 1);
  static const Color sonstiges = Color.fromRGBO(211, 211, 211, 1);

  //income
  static const Color gehalt = Color.fromRGBO(242, 201, 76, 1);
}

class CustomPadding {
  static const EdgeInsets screenWidth = EdgeInsets.only(left: 16, right: 16);
  static const EdgeInsets defaultHeightSpace =
      EdgeInsets.only(top: 8, bottom: 8);
  static const double bottomSpace = 0.05;
  static const double topSpace = 70;
  static const double topSpaceAuth = 0.10;
  static const double contentHeightSpace = 20;
  static const double smallSpace = 4;
  static const double defaultSpace = 16;
  static const double mediumSpace = 8;
  static const double bigSpace = 24;
}

class AssetImport {
  static const String textLogo = "assets/icons/Logo_Text.svg";
  static const String googleLogo = 'assets/icons/Google_Logo.svg';
  static const String appleLogo = 'assets/icons/Apple_Logo.svg';
  static const String returnIcon = 'assets/icons/return_icon.svg';
}

class Constants {
  //Button
  static const double buttonBorderRadius = 10;
  static const Padding screenWidth =
      Padding(padding: EdgeInsets.only(left: 16, right: 16));
  static const double defaultAppBarHeight = 56;
  static const Duration buttonAnimationDuration = Duration(milliseconds: 200);
}
