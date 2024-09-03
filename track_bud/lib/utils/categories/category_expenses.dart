// Widget to display a horizontal list of expense categories
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/enum/categories.dart';

class CategoriesExpense extends StatefulWidget {
  final Function(String) onCategorySelected;
  CategoriesExpense({super.key, required this.onCategorySelected});

  @override
  State<CategoriesExpense> createState() => _CategoriesExpenseState();
}

class _CategoriesExpenseState extends State<CategoriesExpense> {
  // Index of the currently selected category
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Set the height of the category list to a fraction of the screen height
      height: MediaQuery.sizeOf(context).height * Constants.categoryHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Make the list scroll horizontally
        itemCount: Categories.values.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(right: CustomPadding.mediumSpace), // add Padding between categories
          child: GestureDetector(
            onTap: () {
              setState(() => selectedIndex = index);
              widget.onCategorySelected(Categories.values[index].categoryName);
            },
            child: Opacity(
              // Reduce opacity for non-selected categories
              opacity: selectedIndex == null || selectedIndex == index ? 1.0 : 0.5,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: CustomPadding.categoryWidthSpace,
                  vertical: CustomPadding.categoryHeightSpace,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: Categories.values[index].color,
                ),
                child: Row(
                  children: [
                    Categories.values[index].icon, // Display category icon
                    Gap(CustomPadding.smallSpace),
                    Text(Categories.values[index].categoryName), // Display category name
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}