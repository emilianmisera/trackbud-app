import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';

// Enum to represent different split methods
enum SplitMethod { equal, percent, amount }

// Widget for a single split button
class SplitButton extends StatefulWidget {
  // The icon to display on the button
  final String icon;
  // The text to display on the button
  final String text;
  // Function to call when the button is pressed
  final void Function() onPressed;
  // Whether this button is currently selected
  final bool isSelected;

  const SplitButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  State<SplitButton> createState() => _SplitButtonState();
}

class _SplitButtonState extends State<SplitButton> {
  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: ElevatedButton(
        onPressed: widget.onPressed,
        child: Column(
          children: [
            // Display the icon
            SvgPicture.asset(
              widget.icon,
              color: widget.isSelected ? CustomColor.bluePrimary : CustomColor.hintColor,
            ),
            SizedBox(height: CustomPadding.smallSpace),
            // Display the text
            Text(
              widget.text,
              style: CustomTextStyle.hintStyleDefault.copyWith(
                color: widget.isSelected ? CustomColor.bluePrimary : CustomColor.hintColor,
              ),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(Constants.buttonBorderRadius))
          ),
          minimumSize: Size(25, 10),
          padding: EdgeInsets.symmetric(
            horizontal: CustomPadding.defaultSpace,
            vertical: CustomPadding.contentHeightSpace
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

// Widget for selecting the split method
class SplitMethodSelector extends StatefulWidget {
  // Callback function to be called when the split method changes
  final ValueChanged<SplitMethod> onSplitMethodChanged;
  // The currently selected split method
  final SplitMethod selectedMethod;

  const SplitMethodSelector({
    Key? key,
    required this.onSplitMethodChanged,
    required this.selectedMethod,
  }) : super(key: key);

  @override
  State<SplitMethodSelector> createState() => _SplitMethodSelectorState();
}

class _SplitMethodSelectorState extends State<SplitMethodSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppString.distribution,
          style: CustomTextStyle.regularStyleMedium,
        ),
        SizedBox(height: CustomPadding.mediumSpace),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Equal split button
            SplitButton(
              icon: AssetImport.equal,
              text: AppString.equal,
              onPressed: () => widget.onSplitMethodChanged(SplitMethod.equal),
              isSelected: widget.selectedMethod == SplitMethod.equal,
            ),
            // Percent split button
            SplitButton(
              icon: AssetImport.percent,
              text: AppString.percent,
              onPressed: () => widget.onSplitMethodChanged(SplitMethod.percent),
              isSelected: widget.selectedMethod == SplitMethod.percent,
            ),
            // By amount split button
            SplitButton(
              icon: AssetImport.byAmount,
              text: AppString.byAmount,
              onPressed: () => widget.onSplitMethodChanged(SplitMethod.amount),
              isSelected: widget.selectedMethod == SplitMethod.amount,
            ),
          ],
        ),
      ],
    );
  }
}

// Widget for displaying equal split tile
class EqualTile extends StatefulWidget {
  // Name of the person (null for 'Du')
  final String? name;
  // The amount to be split for this person
  final double splitAmount;
  // Whether this is a friend's split (determines UI elements)
  final bool friendSplit;

  const EqualTile({
    super.key,
    this.name,
    required this.splitAmount,
    required this.friendSplit
  });

  @override
  State<EqualTile> createState() => _EqualTileState();
}

class _EqualTileState extends State<EqualTile> {
  // State of the checkbox
  bool _checkBox = true;

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        decoration: BoxDecoration(
          color: CustomColor.white,
          borderRadius: BorderRadius.circular(Constants.buttonBorderRadius)
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Container(
              width: 40,
              height: 40,
              color: Colors.red, // TODO: Replace with profile picture
            ),
          ),
          title: Text(
            widget.name ?? 'Du',
            style: CustomTextStyle.regularStyleDefault,
          ),
          trailing: widget.friendSplit
            ? SizedBox(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Display split amount
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: CustomColor.white,
                        borderRadius: BorderRadius.circular(Constants.buttonBorderRadius),
                        border: Border.all(color: CustomColor.grey),
                      ),
                      child: Text('${widget.splitAmount}€', style: CustomTextStyle.hintStyleDefault),
                    ),
                    // Checkbox for friend's split
                    Checkbox(
                      hoverColor: CustomColor.bluePrimary,
                      checkColor: CustomColor.white,
                      fillColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          return states.contains(WidgetState.selected)
                            ? CustomColor.bluePrimary
                            : CustomColor.white;
                        }
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                      ),
                      value: _checkBox,
                      onChanged: (value) {
                        setState(() {
                          _checkBox = value!;
                        });
                      },
                      activeColor: Colors.blueAccent,
                    ),
                  ],
                ),
              )
            : Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: CustomColor.white,
                  borderRadius: BorderRadius.circular(Constants.buttonBorderRadius),
                  border: Border.all(color: CustomColor.grey),
                ),
                child: Text('${widget.splitAmount}€', style: CustomTextStyle.hintStyleDefault),
              ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: CustomPadding.defaultSpace,
            vertical: CustomPadding.defaultSpace
          ),
        ),
      ),
    );
  }
}

// Widget for displaying equal split for multiple people
class EqualSplitWidget extends StatelessWidget {
  // Total amount to be split
  final double amount;
  // List of names of people involved in the split
  final List<String> names;
  // Whether this is a group split
  final bool? isGroup;

  const EqualSplitWidget({
    Key? key,
    required this.amount,
    required this.names,
    this.isGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the split amount for each person
    final double splitAmount = amount / names.length;

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: names.length,
      separatorBuilder: (context, index) => SizedBox(height: CustomPadding.mediumSpace),
      itemBuilder: (context, index) {
        return EqualTile(
          name: names[index],
          splitAmount: splitAmount,
          friendSplit: isGroup ?? false,
        );
      },
    );
  }
}

// Widget for displaying percentage split tile
class PercentTile extends StatelessWidget {
  // Total amount to be split
  final double amount;
  // Name of the person (null for 'Du')
  final String? name;
  // Current value of the slider (percentage)
  final double sliderValue;
  // Callback function when slider value changes
  final Function(double) onChanged;

  const PercentTile({
    Key? key,
    required this.amount,
    this.name,
    required this.sliderValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.buttonBorderRadius),
          color: CustomColor.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.only(left: CustomPadding.defaultSpace),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Container(
                  width: 40,
                  height: 40,
                  color: Colors.red, // TODO: Replace with profile picture
                ),
              ),
              title: Text(
                name ?? 'Du',
                style: CustomTextStyle.regularStyleMedium,
              ),
              subtitle: Text(
                '${sliderValue.round()}% = ${(amount * (sliderValue / 100)).toStringAsFixed(2)}€',
                style: CustomTextStyle.regularStyleDefault.copyWith(fontSize: CustomTextStyle.fontSizeHint),
              ),
            ),
            Slider(
              onChanged: onChanged,
              max: 100.00,
              divisions: 20,
              value: sliderValue,
              activeColor: CustomColor.bluePrimary,
              inactiveColor: CustomColor.grey,
            )
          ],
        ),
      )
    );
  }
}

// Widget for displaying percentage split for multiple people
class PercentalSplitWidget extends StatefulWidget {
  // Total amount to be split
  final double amount;
  // List of names of people involved in the split
  final List<String> names;

  const PercentalSplitWidget({
    Key? key,
    required this.amount,
    required this.names,
  }) : super(key: key);

  @override
  _PercentalSplitWidgetState createState() => _PercentalSplitWidgetState();
}

class _PercentalSplitWidgetState extends State<PercentalSplitWidget> {
  // List to store slider values for each person
  late List<double> _sliderValues;

  @override
  void initState() {
    super.initState();
    // Initialize slider values equally among all people
    _sliderValues = List.filled(widget.names.length, 100 / widget.names.length);
  }

  // Method to update slider values
  void updateSlider(int index, double value) {
    setState(() {
      if (widget.names.length == 2) {
        // For two people: automatic adjustment
        _sliderValues[index] = value;
        _sliderValues[1 - index] = 100 - value;
      } else {
        // For three or more people: independent sliders
        _sliderValues[index] = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.names.length,
      separatorBuilder: (context, index) => SizedBox(height: CustomPadding.mediumSpace),
      itemBuilder: (context, index) {
        return PercentTile(
          amount: widget.amount,
          name: widget.names[index],
          sliderValue: _sliderValues[index],
          onChanged: (value) => updateSlider(index, value),
        );
      },
    );
  }
}

// Widget for displaying split by amount tile
class ByAmountTile extends StatefulWidget {
  // Name of the person (null for 'Du')
  final String? name;

  const ByAmountTile({super.key, this.name});

  @override
  State<ByAmountTile> createState() => _ByAmountTileState();
}

class _ByAmountTileState extends State<ByAmountTile> {
  // Controller for the input text field
  TextEditingController _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        decoration: BoxDecoration(
          color: CustomColor.white,
          borderRadius: BorderRadius.circular(Constants.buttonBorderRadius)
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Container(
              width: 40,
              height: 40,
              color: Colors.red, // TODO: Replace with profile picture
            ),
          ),
          title: Text(
            widget.name ?? 'Du',
            style: CustomTextStyle.regularStyleDefault,
          ),
          trailing: Container(
            width: 80,
            decoration: BoxDecoration(
              border: Border.all(color: CustomColor.grey),
              borderRadius: BorderRadius.circular(Constants.buttonBorderRadius)
            ),
            child: TextFieldByAmount(
              controller: _inputController,
              inputStyle: CustomTextStyle.regularStyleDefault,
              suffixStyle: CustomTextStyle.regularStyleDefault,
            )
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: CustomPadding.defaultSpace,
            vertical: CustomPadding.defaultSpace
          ),
        ),
      ),
    );
  }
}

// Widget for displaying split by amount for multiple people
class ByAmountSplitWidget extends StatelessWidget {
  // List of names of people involved in the split
  final List<String> names;

  const ByAmountSplitWidget({
    Key? key,
    required this.names,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: names.length,
      separatorBuilder: (context, index) => SizedBox(height: CustomPadding.mediumSpace),
      itemBuilder: (context, index) {
        return ByAmountTile(name: names[index]);
      },
    );
  }
}