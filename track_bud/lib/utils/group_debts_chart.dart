//https://stackoverflow.com/a/63360734
//https://stackoverflow.com/a/53549197

import 'package:flutter/material.dart';
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
  // Declare variables for each category's expense
  final double? lebensmittel;
  final double? drogerie;
  final double? restaurant;
  final double? mobility;
  final double? shopping;
  final double? unterkunft;
  final double? entertainment;
  final double? geschenk;
  final double? sonstiges;

  const TransactionOverview({
    super.key,
    this.lebensmittel,
    this.drogerie,
    this.restaurant,
    this.mobility,
    this.shopping,
    this.unterkunft,
    this.entertainment,
    this.geschenk,
    this.sonstiges
  });

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: EdgeInsets.all(CustomPadding.defaultSpace),
        decoration: BoxDecoration(
            color: CustomColor.white,
            borderRadius: BorderRadius.circular(Constants.buttonBorderRadius)),
        child: Column(
          children: [
            CategoryBar(
              // 0.0 as the default value to make category empty
              categoryExpenses: {
                'Lebensmittel': lebensmittel ?? 0.0,
                'Drogerie': drogerie ?? 0.0,
                'Restaurant': restaurant ?? 0.0,
                'Mobilität': mobility ?? 0.0,
                'Shopping': shopping ?? 0.0,
                'Unterkunft': unterkunft ?? 0.0,
                'Entertainment': entertainment ?? 0.0,
                'Geschenk': geschenk ?? 0.0,
                'Sonstiges': sonstiges ?? 0.0,
              },
              categoryColors: {
                'Lebensmittel': CustomColor.lebensmittel,
                'Drogerie': CustomColor.drogerie,
                'Restaurant': CustomColor.restaurant,
                'Mobilität': CustomColor.mobility,
                'Shopping': CustomColor.shopping,
                'Unterkunft': CustomColor.unterkunft,
                'Entertainment': CustomColor.entertainment,
                'Geschenk': CustomColor.geschenk,
                'Sonstiges': CustomColor.sonstiges,
              },
            ),
          ],
        ),
      ),
    );
  }
}