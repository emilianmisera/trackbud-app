import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';

/// Enum to represent all categories
enum Categories { lebensmittel, drogerie, restaurant, shopping, unterkunft, mobility, entertainment, geschenk, gehalt, sonstiges }

// Icon for each category
extension IconCategory on Categories {
  Image get icon {
    switch (this) {
      case Categories.lebensmittel:
        return Image.asset(AssetImport.shoppingCart, width: Constants.iconSize, height: Constants.iconSize, fit: BoxFit.scaleDown);
      case Categories.drogerie:
        return Image.asset(AssetImport.drogerie, width: Constants.iconSize, height: Constants.iconSize, fit: BoxFit.scaleDown);
      case Categories.restaurant:
        return Image.asset(AssetImport.restaurant, width: Constants.iconSize, height: Constants.iconSize, fit: BoxFit.scaleDown);
      case Categories.shopping:
        return Image.asset(AssetImport.shopping, width: Constants.iconSize, height: Constants.iconSize, fit: BoxFit.scaleDown);
      case Categories.unterkunft:
        return Image.asset(AssetImport.home, width: Constants.iconSize, height: Constants.iconSize, fit: BoxFit.scaleDown);
      case Categories.mobility:
        return Image.asset(AssetImport.mobility, width: Constants.iconSize, height: Constants.iconSize, fit: BoxFit.scaleDown);
      case Categories.entertainment:
        return Image.asset(AssetImport.entertainment, width: Constants.iconSize, height: Constants.iconSize, fit: BoxFit.scaleDown);
      case Categories.geschenk:
        return Image.asset(AssetImport.gift, width: Constants.iconSize, height: Constants.iconSize, fit: BoxFit.scaleDown);
      case Categories.gehalt:
        return Image.asset(AssetImport.gehalt, width: Constants.iconSize, height: Constants.iconSize, fit: BoxFit.scaleDown);
      case Categories.sonstiges:
        return Image.asset(AssetImport.other, width: Constants.iconSize, height: Constants.iconSize, fit: BoxFit.scaleDown);
    }
  }
}

// Color for each category
extension CategoryColor on Categories {
  Color get color {
    switch (this) {
      case Categories.lebensmittel:
        return CustomColor.lebensmittel;
      case Categories.drogerie:
        return CustomColor.drogerie;
      case Categories.restaurant:
        return CustomColor.restaurant;
      case Categories.shopping:
        return CustomColor.shopping;
      case Categories.unterkunft:
        return CustomColor.unterkunft;
      case Categories.mobility:
        return CustomColor.mobility;
      case Categories.entertainment:
        return CustomColor.entertainment;
      case Categories.geschenk:
        return CustomColor.geschenk;
      case Categories.gehalt:
        return CustomColor.gehalt;
      case Categories.sonstiges:
        return CustomColor.sonstiges;
    }
  }
}

// Display Name of each category
extension Name on Categories {
  String get categoryName {
    switch (this) {
      case Categories.lebensmittel:
        return AppTexts.lebensmittel;
      case Categories.drogerie:
        return AppTexts.drogerie;
      case Categories.restaurant:
        return AppTexts.restaurants;
      case Categories.shopping:
        return AppTexts.shopping;
      case Categories.unterkunft:
        return AppTexts.unterkunft;
      case Categories.mobility:
        return AppTexts.mobility;
      case Categories.entertainment:
        return AppTexts.entertainment;
      case Categories.geschenk:
        return AppTexts.geschenke;
      case Categories.gehalt:
        return AppTexts.workIncome;
      case Categories.sonstiges:
        return AppTexts.sonstiges;
    }
  }
}
