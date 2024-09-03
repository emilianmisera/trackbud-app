import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/textfield_widgets.dart';

// Widget for displaying equal split tile
class EqualTile extends StatefulWidget {
  // Name of the person (null for 'Du')
  final String? name;
  // The amount to be split for this person
  final double splitAmount;
  // Whether this is a friend's split (determines UI elements)
  final bool friendSplit;

  const EqualTile({super.key, this.name, required this.splitAmount, required this.friendSplit});

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
        decoration: BoxDecoration(color: CustomColor.white, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace, vertical: CustomPadding.defaultSpace),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Container(
              width: 40,
              height: 40,
              color: Colors.red, // TODO: Replace with profile picture
            ),
          ),
          title: Text(widget.name ?? 'Du', style: TextStyles.regularStyleDefault),
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
                          borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
                          border: Border.all(color: CustomColor.grey),
                        ),
                        child: Text('${widget.splitAmount}€', style: TextStyles.hintStyleDefault),
                      ),
                      // Checkbox for friend's split
                      Checkbox(
                        hoverColor: CustomColor.bluePrimary,
                        checkColor: CustomColor.white,
                        fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                          return states.contains(WidgetState.selected) ? CustomColor.bluePrimary : CustomColor.white;
                        }),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        value: _checkBox,
                        onChanged: (value) => setState(() => _checkBox = value!),
                        activeColor: Colors.blueAccent,
                      ),
                    ],
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: CustomColor.white,
                    borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
                    border: Border.all(color: CustomColor.grey),
                  ),
                  child: Text('${widget.splitAmount}€', style: TextStyles.hintStyleDefault),
                ),
        ),
      ),
    );
  }
}
