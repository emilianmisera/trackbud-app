import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/enum/categories.dart';

class CategoriesIncome extends StatefulWidget {
  final Function(String) onCategorySelected;
  final String? selectedCategory;
  const CategoriesIncome({super.key, required this.onCategorySelected, this.selectedCategory});

  @override
  State<CategoriesIncome> createState() => _CategoriesIncomeState();
}

class _CategoriesIncomeState extends State<CategoriesIncome> {
  // Index of the currently selected category
  int? selectedIndex;
  final List<Categories> filteredCategories = [
    Categories.gehalt,
    Categories.geschenk,
    Categories.sonstiges,
  ];

  // checking if there is a selected category (for EditTransactionScreen)
  @override
  void initState() {
    super.initState();
    if (widget.selectedCategory != null) {
      selectedIndex = filteredCategories.indexWhere((category) => category.categoryName == widget.selectedCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Set the height of the category list to a fraction of the screen height
      height: MediaQuery.sizeOf(context).height * Constants.categoryHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filteredCategories.length,
        itemBuilder: (context, index) {
          final category = filteredCategories[index];
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: CustomPadding.categoryWidthSpace,
                    vertical: CustomPadding.categoryHeightSpace,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: category.color,
                  ),
                  child: Row(
                    children: [
                      category.icon,
                      const Gap(CustomPadding.smallSpace),
                      Text(category.categoryName),
                    ],
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
