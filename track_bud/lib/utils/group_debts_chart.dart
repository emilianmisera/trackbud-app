//https://stackoverflow.com/a/63360734
//https://stackoverflow.com/a/53549197

import 'package:flutter/material.dart';
import 'package:track_bud/utils/buttons_widget.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/textfield_widget.dart';

class CategoryBar extends StatelessWidget {
  final Map<String, double> categoryExpenses;
  final Map<String, Color> categoryColors;

  const CategoryBar({
    Key? key,
    required this.categoryExpenses,
    required this.categoryColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the total expense by summing up all category expenses
    // fold() to iterate through all values and sum them up
    double totalExpense =
        categoryExpenses.values.fold(0, (sum, expense) => sum + expense);

    // Sort the expenses in descending order
    // convert the map entries to a list to sort
    List<MapEntry<String, double>> sortedExpenses = categoryExpenses.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    if (totalExpense == 0) {
      // If there are no expenses, return an empty grey container
      return ClipRRect(
        borderRadius: BorderRadius.circular(5), // apply rounded corners, as borderRadius doesn't work directly on Container
        child: Container(
          height: 20,
          color: CustomColor.grey,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        height: 20,
        child: Row(
          children: sortedExpenses.map((entry) {
            String category = entry.key;
            double expense = entry.value;
            // Calculate the percentage of this category's expense for width of bar
            double percentage = expense / totalExpense;
            return Expanded(
              // width of bar will be proportional to percentage
              flex: (percentage * 100).round(),
              child: Container(
                // if color not found, grey is used instead
                color: categoryColors[category] ?? CustomColor.grey,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class TransactionOverview extends StatelessWidget {
  final Map<String, double?> categoryAmounts;

  const TransactionOverview({
    super.key,
    required this.categoryAmounts,
  });

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: EdgeInsets.all(CustomPadding.defaultSpace),
        decoration: BoxDecoration(
          color: CustomColor.white,
          borderRadius: BorderRadius.circular(Constants.buttonBorderRadius),
        ),
        child: Column(
          children: [
            buildCategoryBar(),
            SizedBox(height: CustomPadding.bigSpace),
            buildCategoryList(),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryBar() {
    return CategoryBar(
      categoryExpenses: Map.fromEntries(
        categoryAmounts.entries.map((e) => MapEntry(e.key, e.value ?? 0.0))
      ),
      categoryColors: getCategoryColors(),
    );
  }

  Widget buildCategoryList() {
    List<MapEntry<String, double>> validCategories = categoryAmounts.entries
        .where((e) => e.value != null && e.value! > 0)
        .map((e) => MapEntry(e.key, e.value!))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: validCategories.map((entry) => 
        Padding(
          padding: EdgeInsets.only(bottom: CustomPadding.mediumSpace),
          child: CategoryInfo(
            categoryName: entry.key,
            icon: getCategoryIcon(entry.key),
            iconColor: getCategoryColor(entry.key),
            amount: entry.value,
          ),
        )
      ).toList(),
    );
  }

  String getCategoryIcon(String category) {
    switch (category) {
      case 'Lebensmittel': return AssetImport.shoppingCart;
      case 'Drogerie': return AssetImport.shopping;
      case 'Restaurant': return AssetImport.restaurant;
      case 'Mobilität': return AssetImport.mobility;
      case 'Shopping': return AssetImport.shopping;
      case 'Unterkunft': return AssetImport.home;
      case 'Entertainment': return AssetImport.entertainment;
      case 'Geschenk': return AssetImport.gift;
      default: return AssetImport.other;
    }
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Lebensmittel': return CustomColor.lebensmittel;
      case 'Drogerie': return CustomColor.drogerie;
      case 'Restaurant': return CustomColor.restaurant;
      case 'Mobilität': return CustomColor.mobility;
      case 'Shopping': return CustomColor.shopping;
      case 'Unterkunft': return CustomColor.unterkunft;
      case 'Entertainment': return CustomColor.entertainment;
      case 'Geschenk': return CustomColor.geschenk;
      default: return CustomColor.sonstiges;
    }
  }

  Map<String, Color> getCategoryColors() {
    return {
      'Lebensmittel': CustomColor.lebensmittel,
      'Drogerie': CustomColor.drogerie,
      'Restaurant': CustomColor.restaurant,
      'Mobilität': CustomColor.mobility,
      'Shopping': CustomColor.shopping,
      'Unterkunft': CustomColor.unterkunft,
      'Entertainment': CustomColor.entertainment,
      'Geschenk': CustomColor.geschenk,
      'Sonstiges': CustomColor.sonstiges,
    };
  }
}


class CategoryInfo extends StatelessWidget {
  final String categoryName;
  final String icon;
  final Color iconColor;
  final double? amount;
  const CategoryInfo({super.key, required this.categoryName, required this.icon, required this.iconColor, required this.amount });

  String _formatAmount(double? value) {
    if (value == null) return '0.00€';
    return '${value.toStringAsFixed(2)}€';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CategoryIcon(color: iconColor, iconWidget: Image.asset(icon, height: 20, width: 20, fit: BoxFit.scaleDown,)),
        SizedBox(width: CustomPadding.mediumSpace,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(categoryName, style: CustomTextStyle.regularStyleMedium,),
            Text(_formatAmount(amount), style: CustomTextStyle.hintStyleDefault,),
          ],
        )
      ],
    );
  }
}