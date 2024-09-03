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




class CustomSegmentControl extends StatefulWidget {
  final Function(int?) onValueChanged; // callback
  const CustomSegmentControl({
    super.key,
    required this.onValueChanged,
  });

  @override
  State<CustomSegmentControl> createState() => _CustomSegmentControlState();
}

class _CustomSegmentControlState extends State<CustomSegmentControl> {
  // _sliding: Tracks the currently selected segment (0 for expense, 1 for income)
  int? _sliding = 0;

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        width: double.infinity, // Ensures the control spans the full width
        child: CupertinoSlidingSegmentedControl(
          children: {
            // Expense segment
            0: Container(
              // Sets the height of the segment relative to screen height
              height: MediaQuery.sizeOf(context).height * Constants.segmentedControlHeight,
              alignment: Alignment.center,
              child: Text(AppTexts.expense,
                  // Applies different styles based on selection state
                  style: _sliding == 0 ? TextStyles.slidingStyleExpense : TextStyles.slidingStyleDefault),
            ),
            // Income segment
            1: Container(
              height: MediaQuery.sizeOf(context).height * Constants.segmentedControlHeight,
              alignment: Alignment.center,
              child: Text(AppTexts.income, style: _sliding == 1 ? TextStyles.slidingStyleIncome : TextStyles.slidingStyleDefault),
            ),
          },
          groupValue: _sliding, // Current selection
          onValueChanged: (int? newValue) {
            setState(() {
              _sliding = newValue;
            });
            widget.onValueChanged(newValue); // Call the callback
          },
          backgroundColor: CustomColor.white, // Background color of the control
        ),
      ),
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
