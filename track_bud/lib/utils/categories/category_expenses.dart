import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/enum/categories.dart';

/// This Widget displays a horizontal list of expense categories
class CategoriesExpense extends StatefulWidget {
  final Function(String) onCategorySelected;
  final String? selectedCategory;
  const CategoriesExpense({super.key, required this.onCategorySelected, this.selectedCategory});

  @override
  State<CategoriesExpense> createState() => _CategoriesExpenseState();
}

class _CategoriesExpenseState extends State<CategoriesExpense> {
  // Index of the currently selected category
  int? selectedIndex;
  // List of all expenseCategories
  final List<Categories> expenseCategories = [
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

  // checking if there is a selected category (for EditTransactionScreen)
  @override
  void initState() {
    super.initState();
    if (widget.selectedCategory != null) {
      selectedIndex = expenseCategories.indexWhere((category) => category.categoryName == widget.selectedCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * Constants.categoryHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: expenseCategories.length,
        itemBuilder: (context, index) {
          final category = expenseCategories[index];
          final isSelected = widget.selectedCategory != null ? category.categoryName == widget.selectedCategory : selectedIndex == index;

          return Padding(
            padding: const EdgeInsets.only(right: CustomPadding.mediumSpace),
            child: GestureDetector(
              onTap: () {
                // Update the selected index
                setState(() {
                  selectedIndex = index;
                });
                widget.onCategorySelected(category.categoryName);
              },
              child: Opacity(
                // Reduce opacity for non-selected categories
                opacity: widget.selectedCategory != null ? (isSelected ? 1.0 : 0.5) : (selectedIndex == null || isSelected ? 1.0 : 0.5),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: CustomPadding.categoryWidthSpace, vertical: CustomPadding.categoryHeightSpace),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(Constants.categoryBorderRadius), color: category.color),
                  child: Row(
                    children: [category.icon, const Gap(CustomPadding.smallSpace), Text(category.categoryName)],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
