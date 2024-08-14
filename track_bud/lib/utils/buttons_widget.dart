import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';

class AccAdjustmentButton extends StatelessWidget {
  final String icon;
  final String name;
  final void Function() onPressed;
  final Widget? widget;
  const AccAdjustmentButton(
      {super.key,
      required this.icon,
      required this.name,
      required this.onPressed,
      this.widget});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: SvgPicture.asset(icon),
      label: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: CustomTextStyle.regularStyleDefault,
          ),
          widget ?? Icon(Icons.arrow_forward_ios)
        ],
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColor.backgroundPrimary,
        foregroundColor: CustomColor.black,
        fixedSize: const Size(double.infinity, 60),
        elevation: 0,
        surfaceTintColor: CustomColor.backgroundPrimary,
      ),
    );
  }
}

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({super.key});

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  final _currencyList = [
    "€",
    "\$",
    "£",
    "¥",
  ]; // List of currency Symbols
  String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      // conatiner decoration
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: CustomColor.grey,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: DropdownButton<String>(
          // DropdownButton
          items: _currencyList.map(buildMenuItem).toList(),
          onChanged: (value) => setState(() {
            this.value = value;
          }),
          value: value,
          elevation: 0,
          style: CustomTextStyle.regularStyleMedium,
          dropdownColor: CustomColor.white,
          iconSize: 0.0,
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: CustomTextStyle.titleStyleMedium,
        ),
      );
}

class AccAdjustmentWidget extends StatefulWidget {
  final String icon;
  final String name;
  final Widget? widget;
  const AccAdjustmentWidget(
      {super.key, required this.icon, required this.name, this.widget});

  @override
  State<AccAdjustmentWidget> createState() => _AccAdjustmentWidgetState();
}

class _AccAdjustmentWidgetState extends State<AccAdjustmentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      padding: EdgeInsets.only(
          left: CustomPadding.defaultSpace, right: CustomPadding.defaultSpace),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: CustomColor.backgroundPrimary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(widget.icon),
              SizedBox(
                width: 8,
              ),
              Text(
                widget.name,
                style: CustomTextStyle.regularStyleDefault,
              ),
            ],
          ),
          widget.widget ?? Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}

class CustomSegmentControl extends StatefulWidget {
  final Function(int?) onValueChanged; // callback
  const CustomSegmentControl({super.key, required this.onValueChanged});

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
              height: MediaQuery.sizeOf(context).height *
                  Constants.segmentedControlHeight,
              alignment: Alignment.center,
              child: Text(AppString.expense,
                  // Applies different styles based on selection state
                  style: _sliding == 0
                      ? CustomTextStyle.slidingStyleExpense
                      : CustomTextStyle.slidingStyleDefault),
            ),
            // Income segment
            1: Container(
              height: MediaQuery.sizeOf(context).height *
                  Constants.segmentedControlHeight,
              alignment: Alignment.center,
              child: Text(AppString.income,
                  style: _sliding == 1
                      ? CustomTextStyle.slidingStyleIncome
                      : CustomTextStyle.slidingStyleDefault),
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

// Widget for individual category items
class CustomCategory extends StatelessWidget {
  final Color color;
  final String icon;
  final String categoryName;

  const CustomCategory({
    super.key,
    required this.color,
    required this.icon,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: CustomPadding.categoryWidthSpace,
        vertical: CustomPadding.categoryHeightSpace,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: color,
      ),
      child: Row(
        children: [
          SvgPicture.asset(icon), // Display category icon
          SizedBox(width: CustomPadding.smallSpace),
          Text(categoryName), // Display category name
        ],
      ),
    );
  }
}

// Widget to display a horizontal list of expense categories
class CategoriesExpense extends StatefulWidget {
  CategoriesExpense({super.key});

  @override
  State<CategoriesExpense> createState() => _CategoriesExpenseState();
}

class _CategoriesExpenseState extends State<CategoriesExpense> {
  // Index of the currently selected category
  int? selectedIndex;

  // List of categories
  List<CustomCategory> categories = [
    CustomCategory(color: CustomColor.lebensmittel, icon: AssetImport.info, categoryName: AppString.lebensmittel),
    CustomCategory(color: CustomColor.drogerie, icon: AssetImport.info, categoryName: AppString.drogerie),
    CustomCategory(color: CustomColor.restaurant, icon: AssetImport.info, categoryName: AppString.restaurants),
    CustomCategory(color: CustomColor.mobility, icon: AssetImport.info, categoryName: AppString.mobility),
    CustomCategory(color: CustomColor.shopping, icon: AssetImport.info, categoryName: AppString.shopping),
    CustomCategory(color: CustomColor.unterkunft, icon: AssetImport.info, categoryName: AppString.unterkunft),
    CustomCategory(color: CustomColor.entertainment, icon: AssetImport.info, categoryName: AppString.entertainment),
    CustomCategory(color: CustomColor.geschenk, icon: AssetImport.info, categoryName: AppString.geschenke),
    CustomCategory(color: CustomColor.sonstiges, icon: AssetImport.info, categoryName: AppString.sonstiges)
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // Set the height of the category list to a fraction of the screen height
      height: MediaQuery.sizeOf(context).height * Constants.categoryHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Make the list scroll horizontally
        itemCount: categories.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(right: CustomPadding.mediumSpace), // add Padding between categories
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index; // Update the selected index
                //TODO: Connect with backend
              });
            },
            child: Opacity(
              // Reduce opacity for non-selected categories
              opacity: selectedIndex == null || selectedIndex == index ? 1.0 : 0.5,
              child: categories[index],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoriesIncome extends StatefulWidget {
  const CategoriesIncome({super.key});

  @override
  State<CategoriesIncome> createState() => _CategoriesIncomeState();
}

class _CategoriesIncomeState extends State<CategoriesIncome> {
   // Index of the currently selected category
  int? selectedIndex;

  // List of categories
  List<CustomCategory> categories = [
    CustomCategory(color: CustomColor.unterkunft, icon: AssetImport.info, categoryName: AppString.gehalt),
    CustomCategory(color: CustomColor.geschenk, icon: AssetImport.info, categoryName: AppString.geschenke),
    CustomCategory(color: CustomColor.sonstiges, icon: AssetImport.info, categoryName: AppString.sonstiges)
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // Set the height of the category list to a fraction of the screen height
      height: MediaQuery.sizeOf(context).height * Constants.categoryHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Make the list scroll horizontally
        itemCount: categories.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(right: CustomPadding.mediumSpace), // add Padding between categories
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index; // Update the selected index
                //TODO: Connect with backend
              });
            },
            child: Opacity(
              // Reduce opacity for non-selected categories
              opacity: selectedIndex == null || selectedIndex == index ? 1.0 : 0.5,
              child: categories[index],
            ),
          ),
        ),
      ),
    );
  }
}
