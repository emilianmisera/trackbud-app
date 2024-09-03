import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/strings.dart';

class GroupTitle extends StatelessWidget {
  const GroupTitle({
    super.key,
    required TextEditingController createGroupController,
  }) : _createGroupController = createGroupController;

  final TextEditingController _createGroupController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: Container(
            width: 60,
            height: 60,
            color: Colors.red,
          ),
        ),
        Gap(CustomPadding.mediumSpace),
        Expanded(
          child: CustomShadow(
            child: Container(
              height: Constants.height, // choose height of Textfield Box
              child: TextFormField(
                controller: _createGroupController,
                cursorColor: CustomColor.bluePrimary,
                decoration: InputDecoration(
                  hintText: AppTexts.groupNameHint,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: CustomPadding.defaultSpace,
                    vertical: CustomPadding.contentHeightSpace,
                  ),
                  hintStyle: TextStyles.hintStyleDefault,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor: CustomColor.white,
                  border:
                      OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
