import 'package:flutter/material.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/textfields/textfield_split_by_amount.dart';

/// Widget for displaying split by amount tile
class ByAmountTile extends StatefulWidget {
  // Name of the person (null for 'Du')
  final UserModel user; // Add this to receive UserModel

  const ByAmountTile({super.key, required this.user});
  @override
  State<ByAmountTile> createState() => _ByAmountTileState();
}

class _ByAmountTileState extends State<ByAmountTile> {
  // Controller for the input text field
  final TextEditingController _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: Container(
        decoration: BoxDecoration(
            color: CustomColor.white,
            borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
              horizontal: CustomPadding.defaultSpace,
              vertical: CustomPadding.defaultSpace),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: SizedBox(
              width: 40,
              height: 40,
              // Use profilePictureUrl from UserModel
              child: widget.user.profilePictureUrl.isNotEmpty
                  ? Image.network(widget.user.profilePictureUrl,
                      fit: BoxFit.cover)
                  : const Icon(Icons.person, color: Colors.grey),
            ),
          ),
          title: Text(widget.user.name, style: TextStyles.regularStyleDefault),
          trailing: Container(
              width: 80,
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColor.grey),
                  borderRadius:
                      BorderRadius.circular(Constants.contentBorderRadius)),
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
