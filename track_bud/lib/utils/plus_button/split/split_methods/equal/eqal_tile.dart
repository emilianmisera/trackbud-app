import 'package:flutter/material.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';

// Widget for displaying equal split tile
class EqualTile extends StatefulWidget {
  // User involved in the split
  final UserModel user;
  // The amount to be split for this person
  final double splitAmount;
  // Whether this is a friend's split (determines UI elements)
  final bool friendSplit;

  const EqualTile({
    super.key,
    required this.user,
    required this.splitAmount,
    required this.friendSplit,
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
          borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: CustomPadding.defaultSpace,
            vertical: CustomPadding.defaultSpace,
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Container(
              width: 40,
              height: 40,
              // Check if the profile picture URL is not empty, and display it
              child: widget.user.profilePictureUrl.isNotEmpty
                  ? Image.network(widget.user.profilePictureUrl,
                      fit: BoxFit.cover)
                  : const Icon(Icons.person, size: 30), // Fallback icon
            ),
          ),
          title: Text(widget.user.name, style: TextStyles.regularStyleDefault),
          trailing: widget.friendSplit
              ? SizedBox(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Display split amount
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: CustomColor.white,
                          borderRadius: BorderRadius.circular(
                              Constants.contentBorderRadius),
                          border: Border.all(color: CustomColor.grey),
                        ),
                        child: Text('${widget.splitAmount}€',
                            style: TextStyles.hintStyleDefault),
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
                        }),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        value: _checkBox,
                        onChanged: (value) =>
                            setState(() => _checkBox = value!),
                        activeColor: Colors.blueAccent,
                      ),
                    ],
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: CustomColor.white,
                    borderRadius:
                        BorderRadius.circular(Constants.contentBorderRadius),
                    border: Border.all(color: CustomColor.grey),
                  ),
                  child: Text('${widget.splitAmount}€',
                      style: TextStyles.hintStyleDefault),
                ),
        ),
      ),
    );
  }
}
