import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';

/// This Widget is a reusable DropDown Button
/// It is used in AddFriendSplit, AddGroupSplit and Analysis Screen
class CustomDropDown extends StatefulWidget {
  // List of possible choices
  final List<String> list;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final String? value;
  final Function(String)? onChanged;
  final double? dropdownWidth;

  const CustomDropDown({
    super.key,
    required this.list,
    this.width,
    this.height,
    this.padding,
    this.value,
    this.onChanged,
    this.dropdownWidth,
  });

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? value;

  @override
  void initState() {
    super.initState();
    // Set the initial value to the passed value or the first item in the list
    value = widget.value ?? (widget.list.isNotEmpty ? widget.list.first : null);
  }

  // builds menu item
  DropdownMenuItem<String> buildMenuItem(String item) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return DropdownMenuItem(
      value: item,
      child: Text(item,
          style: TextStyles.regularStyleDefault.copyWith(color: value == item ? CustomColor.bluePrimary : defaultColorScheme.primary)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return CustomShadow(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          items: widget.list.map(buildMenuItem).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                this.value = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            }
          },
          value: value,
          style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: widget.dropdownWidth ?? 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
              color: defaultColorScheme.surface,
            ),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(Constants.contentBorderRadius),
              thickness: WidgetStateProperty.all(6),
              thumbVisibility: WidgetStateProperty.all(true),
            ),
          ),
          buttonStyleData: ButtonStyleData(
            width: widget.width ?? double.infinity,
            height: widget.height ?? Constants.height,
            decoration: BoxDecoration(
              color: defaultColorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
          ),
          isExpanded: true,
        ),
      ),
    );
  }
}
