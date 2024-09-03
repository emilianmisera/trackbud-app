// ignore: unused_import
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/enum/categories.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widgets.dart';

class AccAdjustmentButton extends StatelessWidget {
  final String icon;
  final String name;
  final void Function() onPressed;
  final EdgeInsets? padding;
  final Widget? widget;
  const AccAdjustmentButton({super.key, required this.icon, required this.name, required this.onPressed, this.widget, this.padding});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: SvgPicture.asset(icon),
      label: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyles.regularStyleDefault,
          ),
          Icon(Icons.arrow_forward_ios_rounded),
        ],
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: CustomColor.backgroundPrimary,
          foregroundColor: CustomColor.black,
          fixedSize: const Size(double.infinity, Constants.height),
          elevation: 0,
          surfaceTintColor: CustomColor.backgroundPrimary,
          padding: padding ?? EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace)),
    );
  }
}






// Widget to display a horizontal list of expense categories
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

class CategoriesIncome extends StatefulWidget {
  final Function(String) onCategorySelected;
  CategoriesIncome({super.key, required this.onCategorySelected});

  @override
  State<CategoriesIncome> createState() => _CategoriesIncomeState();
}

class _CategoriesIncomeState extends State<CategoriesIncome> {
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
              setState(() {
                selectedIndex = index; // Update the selected index
              });
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

// Widget for individual category icon
class CategoryIcon extends StatelessWidget {
  final Color color;
  final Widget iconWidget;

  const CategoryIcon({
    super.key,
    required this.color,
    required this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        CustomPadding.categoryIconSpace,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: color,
      ),
      child: iconWidget, // Display category icon
    );
  }
}
