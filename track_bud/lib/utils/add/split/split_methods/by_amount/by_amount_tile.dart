import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/textfield_widgets.dart';

/// Widget for displaying split by amount tile
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
          trailing: Container(
              width: 80,
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColor.grey), borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
              child: TextFieldByAmount(
                controller: _inputController,
                inputStyle: TextStyles.regularStyleDefault,
                suffixStyle: TextStyles.regularStyleDefault,
              )),
        ),
      ),
    );
  }
}
