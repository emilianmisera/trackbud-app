import 'package:flutter/material.dart';

class CustomTextStyle{

  static const String _fontFamily = "Outfit";

  static const double fontSizeSegmentControl = 13;
  static const double fontSizeHint = 14;
  static const double fontSizeDefault = 16;
  static const double fontSizeTitle = 18;
  static const double fontSizeHeading = 24;

  static const FontWeight _fontWeightDefault = FontWeight.w400;
  static const FontWeight _fontWeightMedium = FontWeight.w500;
  static const FontWeight _fontWeightSemiBold = FontWeight.w600;
  


  TextStyle headingStyle = const TextStyle(
    fontFamily: _fontFamily,
    fontSize: fontSizeHeading,
    fontWeight: _fontWeightSemiBold,
    color: CustomColor.black
  );

  TextStyle regularStyleDefault = const TextStyle(
    fontFamily: _fontFamily,
    fontSize: fontSizeDefault,
    fontWeight: _fontWeightDefault,
    color: CustomColor.black,
  );

  TextStyle regularStyleMedium = const TextStyle(
    fontFamily: _fontFamily,
    fontSize: fontSizeDefault,
    fontWeight: _fontWeightMedium,
    color: CustomColor.black,
  );


}

class CustomColor{
  //main colors
  static const Color bluePrimary = Color.fromRGBO(59,66,232,1);
  static const Color black = Color.fromRGBO(8,7,8,1);
  static const Color backgroundPrimary = Color.fromRGBO(250,250,255,1);
  static const Color backgroundTile = Color.fromRGBO(255,255,255,1);
  static const Color hintColor = Color.fromRGBO(114,114,114,1);
  static const Color hintColorNavBar = Color.fromRGBO(103,104,118,1);
  static const Color red = Color.fromRGBO(223,41,53,1);
  static const Color green = Color.fromRGBO(6,186,99,1);
  
  //categorie colors
  //expenses
  static const Color unterkunft = Color.fromRGBO(242,201,76,1);
  static const Color drogerie = Color.fromRGBO(127,179,213,1);
  static const Color restaurant = Color.fromRGBO(229,89,52,1);
  static const Color lebensmittel = Color.fromRGBO(85,197,122,1);
  static const Color shopping = Color.fromRGBO(155,89,182,1);
  static const Color entertainment = Color.fromRGBO(242,82,121,1);
  static const Color mobility = Color.fromRGBO(100,149,237,1);
  static const Color geschenk = Color.fromRGBO(34,139,34,1);
  static const Color sonstiges = Color.fromRGBO(211,211,211,1);

  //income
  static const Color gehalt = Color.fromRGBO(242,201,76,1);
}

class CustomPadding {
static const Padding screenWidth = Padding(padding: EdgeInsets.only(left:16, right: 16));
static const double betweenMainTiles = 16;
static const double betweenListTiles = 8;

}