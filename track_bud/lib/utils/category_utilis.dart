import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';

// get color based on category
Color getCategoryColor(String category) {
  switch (category) {
    case 'Lebensmittel':
      return CustomColor.lebensmittel;
    case 'Mobilität':
      return CustomColor.mobility;
    case 'Unterkunft':
      return CustomColor.unterkunft;
    case 'Drogerie':
      return CustomColor.drogerie;
    case 'Restaurant':
      return CustomColor.restaurant;
    case 'Shopping':
      return CustomColor.shopping;
    case 'Entertainment':
      return CustomColor.entertainment;
    case 'Geschenk':
      return CustomColor.geschenk;
    case 'Sonstiges':
      return CustomColor.sonstiges;
    default:
      return CustomColor.sonstiges;
  }
}

// get icon based on category
Widget getCategoryIcon(String category) {
  switch (category) {
    case 'Lebensmittel':
      return Image.asset(
        AssetImport.shoppingCart,
        width: 25,
        height: 25,
        fit: BoxFit.scaleDown,
      );
    case 'Mobilität':
      return Image.asset(
        AssetImport.mobility,
        width: 25,
        height: 25,
        fit: BoxFit.scaleDown,
      );
    case 'Unterkunft':
      return Image.asset(
        AssetImport.home,
        width: 25,
        height: 25,
        fit: BoxFit.scaleDown,
      );
    case 'Drogerie':
      return Image.asset(
        AssetImport.drogerie,
        width: 25,
        height: 25,
        fit: BoxFit.scaleDown,
      );
    case 'Restaurant':
      return Image.asset(
        AssetImport.restaurant,
        width: 25,
        height: 25,
        fit: BoxFit.scaleDown,
      );
    case 'Shopping':
      return Image.asset(
        AssetImport.shopping,
        width: 25,
        height: 25,
        fit: BoxFit.scaleDown,
      );
    case 'Entertainment':
      return Image.asset(
        AssetImport.entertainment,
        width: 25,
        height: 25,
        fit: BoxFit.scaleDown,
      );
    case 'Geschenk':
      return Image.asset(
        AssetImport.gift,
        width: 25,
        height: 25,
        fit: BoxFit.scaleDown,
      );
    case 'Sonstiges':
      return Image.asset(
        AssetImport.other,
        width: 25,
        height: 25,
        fit: BoxFit.scaleDown,
      );
    default:
      return Icon(
        Icons.error,
      );
  }
}