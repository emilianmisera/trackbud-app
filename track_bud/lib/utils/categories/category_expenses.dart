// Widget to display a horizontal list of expense categories
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/enum/categories.dart';

class CategoriesExpense extends StatefulWidget {
  final Function(String) onCategorySelected;
  const CategoriesExpense({super.key, required this.onCategorySelected});

  @override
  State<CategoriesExpense> createState() => _CategoriesExpenseState();
}

class _CategoriesExpenseState extends State<CategoriesExpense> {
  // Index of the currently selected category
  int? selectedIndex;

  final List<Categories> filteredCategories = [
    Categories.lebensmittel,
    Categories.drogerie,
    Categories.restaurant,
    Categories.shopping,
    Categories.unterkunft,
    Categories.mobility,
    Categories.entertainment,
    Categories.geschenk,
    Categories.sonstiges,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Set the height of the category list to a fraction of the screen height
      height: MediaQuery.sizeOf(context).height * Constants.categoryHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Make the list scroll horizontally
        itemCount: filteredCategories.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(
              right:
                  CustomPadding.mediumSpace), // add Padding between categories
          child: GestureDetector(
            onTap: () {
              setState(() => selectedIndex = index);
              widget.onCategorySelected(filteredCategories[index].categoryName);
            },
            child: Opacity(
              // Reduce opacity for non-selected categories
              opacity:
                  selectedIndex == null || selectedIndex == index ? 1.0 : 0.5,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: CustomPadding.categoryWidthSpace,
                  vertical: CustomPadding.categoryHeightSpace,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: filteredCategories[index].color,
                ),
                child: Row(
                  children: [
                    filteredCategories[index].icon, // Display category icon
                    const Gap(CustomPadding.smallSpace),
                    Text(filteredCategories[index]
                        .categoryName), // Display category name
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
